import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import '../../widgets/swiper_pagination.dart';
import '../../common/common_functions.dart';
import '../../shared/scoreCounter.dart';
import '../../shared/options.dart';
import '../../common/common_functions.dart';
class TestPage extends StatefulWidget {
  final String level;
  TestPage({this.level});
  TestPageState createState() => TestPageState(level:this.level);
}

class TestPageState extends State<TestPage> {
  final String level;
  TestPageState({this.level});
  bool favourite=false;
  List<String> quoteIds=[];
  SharedPreferences preferences;
  int prev_level_score=0;
  int prev_level=0;
  final SwiperController _swiperController = SwiperController();
  int _pageCount;
  int _currentIndex = 0,_curQuesIndex=0;
  int answerCounter=0,score=0,answered=0;
  final List<Color> pageBgs = [
    Colors.blue.shade300,
    Colors.grey.shade600,
    Colors.cyan.shade300
  ];

  initializePreference() async{
    preferences=await SharedPreferences.getInstance();
    setState(() {
      prev_level_score=preferences.get(prev_level.toString())!=null ? preferences.getInt(prev_level.toString()) :null;
    });
  }

  void initState(){
    Provider.of<ScoreCounter>(context,listen: false).score=0;
    Provider.of<ScoreCounter>(context,listen: false).quesAnswered=0;
    prev_level=int.parse(level)-1;
    initializePreference();
    favourite=false;
    this.quoteIds=[];
    score=0;
    answered=0;

  }
  @override
  Widget build(BuildContext context) {
    if(int.parse(level)!=1 && prev_level_score==null){
      return Scaffold(
          backgroundColor: Colors.white,
          body:Center(
            child:
            Text(
              'Please Take Previous Level Quiz First.'
            )
          )
      );
    }
    else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Consumer<ScoreCounter>(
                        builder: (BuildContext context, ScoreCounter value,
                            Widget child) {
                          print(value.quesAnswered);
                          answered = value.quesAnswered;
                          if (answered == _pageCount) {
                            print(level);
                            print("all answers received");
                            preferences.setInt(level, value.score);
                            print(preferences.getInt(level));
                          }
                          score = value.score;
                          return Text(
                            '${score}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .display1,
                          );
                        }
                    )
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  child: Text(
                    'Swipe Right For Next Question Once Answered',
                    style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                Expanded(child:
                StreamBuilder(
                    stream: Firestore.instance
                        .collection('quiz')
                        .where("quizLevel", isEqualTo: level)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text("Loading"));
                      }
                      if (snapshot.hasData) {
                        _pageCount = snapshot.data.documents.length;
                        //Provider.of<ScoreCounter>(context,listen: false).totalScore=_pageCount;
                        if (_pageCount > 0) {
                          return Swiper(
                            index: _currentIndex,
                            controller: _swiperController,
                            itemCount: snapshot.data.documents.length,
                            onIndexChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                                answerCounter = 0;
                                _curQuesIndex=0;
                              });
                            },
                            loop: false,
                            itemBuilder: (context, index) {
                              return _buildPage(
                                  title: 'Whats shown in the Pic?',
                                  pageBg: snapshot.data.documents[index]
                                  ['imageUrl'],
                                  options: snapshot.data
                                      .documents[index]['options'],
                                  correct: snapshot.data
                                      .documents[index]['correct']);
                            },
                            pagination: SwiperPagination(
                                builder: CustomPaginationBuilder(
                                    activeSize: Size(10.0, 20.0),
                                    size: Size(10.0, 15.0),
                                    color: Colors.grey.shade600)),
                          );
                        }
                        else {
                          return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  CommonFunctions.getSubjectValueInCamelCase(
                                      "Coming soon Or You dont have active internet connection"),
                                  style: TextStyle(color: Colors.black,
                                      fontSize: 24.0),
                                ),
                              ));
                        }
                      } else {
                        return Center(
                            child: Text(
                              "Coming soon",
                              style: TextStyle(color: Colors.black),
                            ));
                      }
                    })),
                /*,
              model==null ? Text('Loading') : _buildButtons()*/
              ],
            ),
          ],
        ),
      );
    }
  }

  callBack(value) => setState(
          () => answerCounter+=value);
  Widget _buildOptionsPallete(List<dynamic> options,int correct){
    int count=1;
    bool answer=false;
    return Column(
        children: options.map(
        (textVal)=>
            /*OptionsPallette(textVal: textVal,
                correct: correct,
                answerCounter: answerCounter,
                curQuesIndex: _curQuesIndex,
                count: count++,
              callBack:callBack)*/
          RadioListTile(
            /*secondary: Icon(
              answer ? Icons.thumb_up :Icons.thumb_down,
              color: answer ? Colors.green :Colors.red,
              size: 14.0,
            ),
            */value: count++,
            title: Text(CommonFunctions.getSubjectValueInCamelCase(textVal.toString())),
            groupValue: _curQuesIndex,
            onChanged: (val){
              setState(() {
                if(answerCounter==1){
                  showDialog(
                      context: context,builder: (_) => AssetGiffyDialog(
                    onlyOkButton: true,
                    image: Image.asset('assets/images/thumbs_up.gif'),
                    title: Text('Answer',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w600),
                    ),
                    description: Text('Your Answer is already submitted.',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                    entryAnimation: EntryAnimation.LEFT,
                    onOkButtonPressed: () {Navigator.pop(context);},
                  ) );
                  /*showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Answer"),
                        content: Text("Your Answer is already Noted Down."),
                        actions: [
                          FlatButton(
                            child: IconButton(
                                icon: Icon(Icons.thumb_up),
                                color: Colors.green,
                                onPressed: () {
                                  Navigator.pop(context);
                                }
                            ),
                            onPressed: () {

                            },
                          ),
                        ],
                      );
                    },
                  );*/
                }
                else {
                  answerCounter++;
                  _curQuesIndex=val;
                  _curQuesIndex == correct ? answer = true : answer = false;
                  if (answer) {
                    Provider.of<ScoreCounter>(context, listen: false)
                        .increment();

                    Provider.of<ScoreCounter>(context, listen: false).quesAnswered+=1;
                    showDialog(
                        context: context,builder: (_) => AssetGiffyDialog(
                      onlyOkButton: true,
                      image: Image.asset('assets/images/thumbs_up.gif'),
                      title: Text('Answer',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                      description: Text('Your Answer is correct.',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                      entryAnimation: EntryAnimation.LEFT,
                      onOkButtonPressed: () {Navigator.pop(context);},
                    ) );
                  }
                  else {
                    Provider.of<ScoreCounter>(context, listen: false).quesAnswered+=1;
                    showDialog(
                        context: context,builder: (_) => AssetGiffyDialog(
                      onlyOkButton: true,
                      image: Image.asset('assets/images/thumbs_down.gif'),
                      title: Text('Answer',
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w600),
                      ),
                      description: Text('Your Answer is Incorrect.',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                      entryAnimation: EntryAnimation.LEFT,
                      onOkButtonPressed: () {Navigator.pop(context);},
                    ) );
                  }
                }
              });
            }
    )).toList()
    );
  }

  Widget _buildPage({String title, String pageBg,List<dynamic> options,int correct}) {
    final TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.white);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.3,
            child: InkWell(
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 10.0,
                child: CachedNetworkImage(
                    imageUrl: pageBg=="" ? "https://firebasestorage.googleapis.com/v0/b/education-manner.appspot.com/o/sea.jpg?alt=media&token=028276a0-0855-4108-8b75-e89f88b5f42f" : pageBg,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    fadeInDuration: Duration(seconds: 3),
                    placeholder: (context, url) => SizedBox(
                        height: 10.0,
                        width: 10.0,
                        child:
                        CircularProgressIndicator(
                            strokeWidth: 1.0)
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error)
                ),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
          ),
          _buildOptionsPallete(options,correct)

        ]);
  }
}
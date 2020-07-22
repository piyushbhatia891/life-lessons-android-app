import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './model/share-model.dart';
import '../../widgets/swiper_pagination.dart';
import '../../common/common_functions.dart';
class HomePage extends StatefulWidget {
  final String title;
  HomePage({this.title});
  HomePageState createState() => HomePageState(title: this.title);
}

class HomePageState extends State<HomePage> {
  final String title;
  bool favourite=false;
  List<String> quoteIds=[];
  HomePageState({this.title});
  SharedPreferences preferences;
  final SwiperController _swiperController = SwiperController();
  int _pageCount;
  int _currentIndex = 0;
  ShareModel model;
  final List<Color> pageBgs = [
    Colors.blue.shade300,
    Colors.grey.shade600,
    Colors.cyan.shade300
  ];

  initializePreference() async{
    preferences=await SharedPreferences.getInstance();
  }

  void initState(){
    initializePreference();
    favourite=false;
    this.quoteIds=[];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('quotes')
                          .where("category", isEqualTo: title)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text("Loading"));
                        }
                        if (snapshot.hasData) {
                          _pageCount=snapshot.data.documents.length;
                          if(_pageCount>0) {
                            return Swiper(
                              index: _currentIndex,
                              controller: _swiperController,
                              itemCount: snapshot.data.documents.length,
                              onIndexChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                  model = new ShareModel(name: snapshot.data
                                      .documents[index]['category'],
                                      description: snapshot.data
                                          .documents[index]
                                      ['description'],
                                      favourite:preferences.get('favourites')!=null
                                          ? (preferences.getStringList('favourites').contains(snapshot.data.documents[index].documentID)
                                          ? true : false) : false);
                                });
                              },
                              loop: false,
                              itemBuilder: (context, index) {
                                model = new ShareModel(
                                    id: snapshot.data.documents[index].documentID,
                                    name: snapshot.data
                                    .documents[index]['category'],
                                    description: snapshot.data.documents[index]
                                    ['description'],
                                    favourite:preferences.get('favourites')!=null
                                    ? (preferences.getStringList('favourites').contains(snapshot.data.documents[index].documentID)
                                        ? true : false) : false);
                                return _buildPage(
                                    title: CommonFunctions.getSubjectValueInCamelCase(snapshot.data.documents[index]
                                    ['description']),
                                    pageBg: snapshot.data.documents[index]
                                    ['imageUrl'],
                                    favourite:preferences.get('favourites')!=null
                                        ? (preferences.getStringList('favourites').contains(snapshot.data.documents[index].documentID)
                                        ? true : false) : false);
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
                                    CommonFunctions.getSubjectValueInCamelCase("Coming soon Or You dont have active internet connection"),
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
                      }))/*,
              model==null ? Text('Loading') : _buildButtons()*/
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(bool favourite) {
    Icon icon=favourite ? Icon(Icons.favorite): Icon(Icons.favorite_border);
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            textColor: Colors.grey.shade600,
            child: Text("Back"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: IconButton(
                icon: icon,
                onPressed: (){
                    setState(() {
                        model.favourite=!model.favourite;
                        if(model.favourite){
                          !quoteIds.contains(model.id) ? quoteIds.add(model.id) :"";
                        }
                        else
                          quoteIds.contains(model.id) ? quoteIds.remove(model.id) :"";
                        if(preferences.get('favourites')!=null){
                          List list=preferences.getStringList('favourites');
                          list.contains(quoteIds[0]) ?"" : list.add(quoteIds[0]);
                          preferences.setStringList('favourites', list);
                        }
                        else
                          preferences.setStringList('favourites',quoteIds);
                        print(preferences.get('favourites'));
                        quoteIds=[];
                    });
                }),
            onPressed: null,
          ),
          FlatButton(
            textColor: Colors.grey.shade600,
            child: IconButton(
              icon: Icon(
                  Icons.share
              ),
              onPressed: () => share(context, model),
            ),
            onPressed: (){}
          ),

        ],
      ),
    );
  }

  share(BuildContext context, ShareModel shareModel) {
    final RenderBox box = context.findRenderObject();

    Share.share("${shareModel.name} - ${shareModel.description}",
        subject: shareModel.description,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Widget _buildPage({String title, String pageBg,bool favourite}) {
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
          _buildButtons(favourite)
        ]);
  }
}
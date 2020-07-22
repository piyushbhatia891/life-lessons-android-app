import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/scoreCounter.dart';
class OptionsPallette extends StatefulWidget{
  final int correct;
  final int answerCounter;
  final int count;
  final String textVal;
  final int curQuesIndex;
  final Function callBack;
  OptionsPallette({this.correct,this.answerCounter,this.curQuesIndex,this.textVal,this.callBack,this.count});
  OptionsPallettePage  createState()=>OptionsPallettePage(correct: this.correct,answerCounter: this.answerCounter,
  curQuesIndex: this.curQuesIndex,textVal: this.textVal,count:this.count,callBack: this.callBack);
}

class OptionsPallettePage extends State<OptionsPallette>{
  final int correct;
  int answerCounter;
  final String textVal;
  final int count;
  int curQuesIndex;
  bool answer;
  Function callBack;
  OptionsPallettePage({this.correct,this.answerCounter,this.curQuesIndex,this.textVal,this.count,this.callBack});
  Widget build(BuildContext context){
    return RadioListTile(
        value: count,
        title: Text("$textVal"),
        groupValue: curQuesIndex,
        onChanged: (val){
          setState(() {
            if(answerCounter==1){
              showDialog(
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
              );
            }
            else {
              //print(answerCounter);
              callBack(1);
              curQuesIndex=val;
              curQuesIndex == correct ? answer = true : answer = false;
              if (answer) {
                Provider.of<ScoreCounter>(context, listen: false)
                    .increment();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Answer"),
                      content: Text("Your Answer is correct."),
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
                );
              }
              else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Answer"),
                      content: Text("Your Answer is wrong."),
                      actions: [
                        FlatButton(
                          child: IconButton(
                              icon: Icon(Icons.thumb_down),
                              color: Colors.red,
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
                );
              }
              //print(answer);
            }
          });
        }
    );
  }
}
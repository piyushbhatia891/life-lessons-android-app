import 'package:flutter/foundation.dart';
class ScoreCounter with ChangeNotifier{
  int _score=0;
  int _totalScore=0;

  int _quesAnswered=0;

  int get quesAnswered=>_quesAnswered;
  int get score =>_score;
  int get totalScore => _totalScore;

  set score(int score){
    _score=score;
    notifyListeners();
  }

  set totalScore(int totalScore){
    _totalScore=totalScore;
    notifyListeners();
  }

  set quesAnswered(int ques){
    _quesAnswered=ques;
    notifyListeners();
  }

  increment(){
    score=score+1;
  }


}
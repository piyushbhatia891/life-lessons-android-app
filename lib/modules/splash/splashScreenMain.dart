import 'package:flutter/material.dart';
import './SplashScreen.dart';
import './EnterExitRoute.dart';
import 'dart:async';

class SplashScreenMain extends StatefulWidget{

  _splashScreenMainState createState()=>_splashScreenMainState();

}
class _splashScreenMainState extends State<SplashScreenMain> with TickerProviderStateMixin {
  void initState(){
    super.initState();
    Timer(
      Duration(seconds: 3),
    ()=>{
        //HomePage(title: 'Sales Dashboard 2018')
        /*Navigator.push(context,
        EnterExitRoute(exitPage: this, enterPage: SplashScreen))*/
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreen()))
    });

  }

  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Text(
            'Life Lessons',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0
            ),
          ),
        ),
      ),
    );
  }
}

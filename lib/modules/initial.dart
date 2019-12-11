import 'package:flutter/material.dart';
import './splash/SplashScreen.dart';
class InitialHomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SplashScreen(),
    );
  }

}
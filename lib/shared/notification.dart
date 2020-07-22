/*
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
class FirebaseNotification {
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase(){
    _firebaseMessaging=FirebaseMessaging();
  }

  void firebase_Listeners(){
    _firebaseMessaging.getToken().then((token){
      print("token is :"+token);
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
}
*/

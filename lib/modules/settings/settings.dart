import 'package:flutter/material.dart';
class SettingsPage extends StatefulWidget{
  SettingsPageState createState()=>SettingsPageState();
}

class SettingsPageState extends State<SettingsPage>{

  Widget build(BuildContext context){
    return ListView.builder(
        itemBuilder:(context,index) {
          return ListTile(
            leading: Icon(
              Icons.notification_important,
              color: Colors.grey,
              size: 14.0,
            ),
            onTap: (){},

          );
        },
        itemCount: 2,
    );
  }
}

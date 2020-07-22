import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PointsPage extends StatefulWidget{
 PointsPageState createState()=>PointsPageState();
}
class PointsPageState extends State<PointsPage> {
  SharedPreferences preferences;
  final String levelConst="Level Not Taken";
  int level1=0,level2=0,level3=0;
  Future<Null> initializePreference() async{
    preferences=await SharedPreferences.getInstance();

    setState(() {
      level1=preferences.get('1')!=null ? preferences.getInt('1') :0;
      level2=preferences.get('2')!=null ? preferences.getInt('2') :0;
      level3=preferences.get('3')!=null ? preferences.getInt('3') :0;
    });
  }

  void initState() {
    super.initState();
    initializePreference();
  }

  Widget build(BuildContext context) {
      TextStyle style=TextStyle(
        fontSize: 30.0
      );
      return Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    'Easy',
                    style: style
                ),
                SizedBox(
                  width: 30.0,
                ),Text(
                      '${level1}',
                  style: style,
                  ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    'Medium',
                  style: style,
                ),
                SizedBox(
                  width: 30.0,
                ),
                Text(
                    '${level2}',
                  style: style,
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                    'Hard',
                  style: style,
                ),
                SizedBox(
                  width: 30.0,
                ),
                Text(
                    '${level3}',
                  style: style,
                )
              ],
            )
          ],
        ),
      );

  }
}


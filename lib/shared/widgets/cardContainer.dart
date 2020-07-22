import 'package:flutter/material.dart';
import '../../modules/test/test.dart';
import '../../modules/test/testCategories.dart';
import '../../modules/home/home-page.dart';
import '../../modules/categories/categories.dart';
import '../../modules/about_us/about-us.dart';
import '../../modules/points/points.dart';
class CardContainer extends StatefulWidget {
  final String category;
  final String imageUrl;
  final String title;
  final String level;
  CardContainer({this.category,this.imageUrl,this.title,this.level});
  CardContainerState createState()=>CardContainerState(category: this.category,imageUrl: this.imageUrl,title:this.title,level: this.level);
}

class CardContainerState extends State<CardContainer>{
  final String category;
  final String imageUrl;
  final String title;
  String level;
  CardContainerState({this.imageUrl,this.category,this.title,this.level});
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          height: 120.0,
          child: InkWell(
            onTap: () {
              //myInterstitial..load()..show();
              if(category=="quiz")
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestCategories()));
              else if(category=="quiz-category")
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestPage(level: level)));
              else if(category=="about")
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutUsPage()));
    else if(category=="points")
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => PointsPage()));
              else if(category=="learn")
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Categories()));
              else
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(title: category)));
            },
            child: imageUrl!=""? Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              //color: Colors.blue,
              elevation: 10.0,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.fill,
              ),
            ):
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
              ),
              color: Colors.green,
              elevation: 10.0,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 20.0,),

                ),
              )
            ),
          ),
        ),
        SizedBox(height: 2.0),
        if(imageUrl!="")
          Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 20.0),
        )
      ],
    );
  }
}
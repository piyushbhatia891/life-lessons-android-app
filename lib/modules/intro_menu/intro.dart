import 'package:flutter/material.dart';
import '../about_us/about-us.dart';
import '../categories/categories.dart';
import '../test/test.dart';
import '../../shared/widgets/rowWidgets.dart';
import '../../shared/models/categories.dart';

class IntroPage extends StatelessWidget{
  List<CategoriesModel> categoriesList1=[new CategoriesModel(title:'Learn & Grow',
      imageUrl:'assets/images/respect.jpg', category:"learn"),new CategoriesModel(title:'Take A quiz',
      imageUrl:'assets/images/quiz.jpg', category:"quiz")];
  List<CategoriesModel> categoriesList2=[new CategoriesModel(title:'About Us',
      imageUrl:'assets/images/about_us.jpg', category:"about"),
  new CategoriesModel(title:'Points',
      imageUrl:'assets/images/points.jpg', category:"points")];

  Widget build(BuildContext context){
    return Scaffold(
      drawer: Drawer(
        elevation: 10.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text('Life Lessons',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.0)),
                      ),
                    ],
                  )),
            ),
            ListTile(
              leading: Icon(Icons.home),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 14.0,
              ),
              title: Center(
                child: Text('Home'),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Categories()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 14.0,
              ),
              title: Center(
                child: Text('About Us'),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()));
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Life Lessons'),
        elevation: 10.0,
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            RowWidget(model: categoriesList1),
            RowWidget(model: categoriesList2)
          ],
        ),
      )
    );
  }
}
import 'package:flutter/material.dart';
import '../about_us/about-us.dart';
import '../categories/categories.dart';
import '../test/test.dart';
import '../../shared/widgets/rowWidgets.dart';
import '../../shared/models/categories.dart';

class TestCategories extends StatefulWidget{
  TestCategoriesPage createState()=>TestCategoriesPage();
}
class TestCategoriesPage extends State<TestCategories>{
  List<CategoriesModel> categoriesList1=[new CategoriesModel(title:'Easy',
      imageUrl:'assets/images/easy.jpg', category:"quiz-category",level: '1'),new CategoriesModel(title:'Medium',
      imageUrl:'assets/images/medium.jpg', category:"quiz-category",level: '2')];
  List<CategoriesModel> categoriesList2=[new CategoriesModel(title:'Hard',
      imageUrl:'assets/images/hard.jpg', category:"quiz-category",level: '3')];

  Widget build(BuildContext context){
    return Scaffold(
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
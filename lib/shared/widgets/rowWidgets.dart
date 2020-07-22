import 'package:flutter/material.dart';
import './cardContainer.dart';
import '../models/categories.dart';
class RowWidget extends StatelessWidget{
  final List<CategoriesModel> model;
  RowWidget({this.model});

  Widget build(BuildContext context){
    List<Widget> widgets=model.map((val)=>
        Expanded(
            child: CardContainer(title:val.title,
                imageUrl:val.imageUrl, category:val.category,level: val.level)
        )).toList();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets
      ),
    );
  }
}
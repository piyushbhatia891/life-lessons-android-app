import 'package:flutter/foundation.dart';
class ShareModel{
  String id;
  String name;
  String description;
  String imageUrl;
  bool favourite;
  ShareModel({this.id,@required this.name,@required this.description,this.imageUrl,this.favourite});
}
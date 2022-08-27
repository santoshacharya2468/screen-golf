import 'package:cloud_firestore/cloud_firestore.dart';

class UserPoints{
 late final int point;
 late final String  title;
   String? descriptions;
  late DateTime createdAt;
  UserPoints.fromMap(Map<String,dynamic> map){
    point=map['point']??0;
    title=map['title']??'';
    descriptions=map['descriptions'];
    
    createdAt=(map['createdAt'] as Timestamp).toDate();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class  Message{
  String? docId;
  late final String roomId;
  late final  String senderId;
  late final String receiverId;
  late final  String body;
  late final DateTime sentAt;
  late final String shopId;
  
  Message({required this.roomId,required this.senderId,required this.receiverId,required this.body,required this.shopId});
  Message.fromMap(Map<String,dynamic> map,this.docId){
     roomId=map['roomId'];
     senderId=map['senderId'];
     receiverId=map['receiverId'];
     body=map['body'];
     sentAt=map['sentAt']==null?DateTime.now():(map['sentAt'] as Timestamp).toDate();
  }
  Map<String,dynamic> toMap(){
    return {
      'roomId':roomId,
      'senderId':senderId,
      'receiverId':receiverId,
      'body':body,
      'shopId':shopId,
      'sentAt':FieldValue.serverTimestamp()
    };
  }

}
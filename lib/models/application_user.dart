
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:massageapp/models/shop.dart';
class ApplicationUser{
 String? email;
 String? name;
 String? uid;
 String? profilePicture;
 Shop? shop;
 String? fcmId;
 late bool isSuperUser;
 Placemark? fullAddress;
 LatLng? position;
 late int points;
 ApplicationUser({this.email,this.name,this.uid,this.profilePicture,this.shop,this.isSuperUser=false,required this.points});
 Map<String,dynamic> toMap(){
   return {
     'userId':this.uid,
     'name':this.name,
     'email':email,
     'points':points,
     'profilePicture':this.profilePicture
   };
 }
 String get namePlaceholder=> name==null || name!.isEmpty? email!:name!;
 ApplicationUser.fromMap(Map<String ,dynamic> map){
    email=map['email'];
    name=map['name'];
    uid=map['userId'];
    profilePicture=map['profilePicture'];
    fcmId=map['fcmId'];
    isSuperUser= uid=="J9p0hNeuP8NFY4sbfNjXCziKZIB3";
    if(map['fullAddress']!=null){
      fullAddress=Placemark.fromMap(map['fullAddress']);
    }
    if(map['location']!=null && map['location'] is Map){
      position=LatLng(map['location']['latitude'],map['location']['longitude']);
    }
    points=map['points']??0;
 }
}
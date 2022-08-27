import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/get_location.dart';
import 'package:massageapp/models/models.dart';

class AuthController extends GetxController {
  var currentUser=ApplicationUser(points: 0).obs;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth =>_auth;
  final docRef = FirebaseFirestore.instance
      .collection(FirebaseCollections.USER_COLLECTIONS);
  @override
  onInit() {
    super.onInit();
  }

updateUser()async{
   final doc=await FirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS).doc(_auth.currentUser!.uid).get();
  if(doc.exists){
    currentUser.value=ApplicationUser.fromMap(doc.data()!);
  }
  update();
  final fcmId=await FirebaseMessaging.instance.getToken();
  if(currentUser.value.fcmId!=fcmId){
  updateFcm(fcmId);
  }

}
updateFcm(String? fcmId)async{

 await FirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS).doc(auth.currentUser?.uid).update({
    'fcmId':fcmId
  });
  
}
  listenAuthState() {}
  Future<void> loginWithGoogle() async {}
  Future<UserCredential?> loginWithEmailAndPassword(
      {required String email, required String password}) async {
        try{
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
           updateUser();
           //user-not-found
            return result;
        } on FirebaseAuthException catch(  e){
          String error=translator.error;
          switch(e.code){
            case 'user-not-found':
            error=translator.userNotFound;
            break;
            case 'wrong-password':
            error=translator.emailPasswordError;
            break;
          }
          Get.rawSnackbar(title: translator.error,message:error,backgroundColor: Colors.red);
          return null;
        }

  }

  Future<UserCredential?> registerWithEmailAndPassword(
      {required String email, required String password,required String name}) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
         FirebaseAuth.instance.currentUser!.updateDisplayName(name);
         final ApplicationUser user=ApplicationUser(
           email: email,
           name: name,
           points: 0,
           uid: FirebaseAuth.instance.currentUser?.uid
         );
         final data=user.toMap();
         data['fcmId']=await FirebaseMessaging.instance.getToken();
         final position=await getCurrentLocation();
         if(position!=null){
           data['fullAddress']=await  fullAddressFromPosition(LatLng(position.latitude, position.latitude));
           data['location']={'longitude':position.longitude,'latitude':position.latitude};
         }
        await  FirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS).doc(_auth.currentUser?.uid).set(data
         );
        updateUser();
      return result;
    } on FirebaseAuthException catch (e) {
      
      print(e.code);
       Get.rawSnackbar(title: translator.error,message:e.code=="email-already-in-use"? translator.emailAlreadyTakenError:  e.message,backgroundColor: Colors.red);
       return null;
    }
  }

  Future<bool> hasShop(String uId) async {
    final doc = await FirebaseFirestore.instance
        .collection(FirebaseCollections.SHOP_COLLECTIONS)
        .where('userId', isEqualTo: uId)
        .get();
    return doc.docs.length > 0;
  }
  fetchUserShop()async{
  final result=await FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_COLLECTIONS)
  .where('userId',
  isEqualTo: _auth.currentUser!.uid
  ).get();
  if(result.docs.length>0){
   var shop=result.docs.first;
   currentUser.value.shop=Shop.fromMap(shop.data(), shop.id);
  }else{
    currentUser.value.shop=null;
  }
  }
}

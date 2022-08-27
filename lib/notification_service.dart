import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/screens/screens.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class NotificationService{
Future<String> getImageFilePathFromAssets(String asset) async {
  final byteData = await rootBundle.load(asset);

  final file =
      File('${(await getTemporaryDirectory()).path}/${asset.split('/').last}');
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file.path;
}
  void showNotification(String? title,String? body,RemoteMessage message)async{
    AwesomeNotifications().isNotificationAllowed().then((v)async{
      if(!v){
        await  AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
   
   await AwesomeNotifications().createNotification(
  content: NotificationContent(
      id: message.hashCode,
      channelKey: 'basic_channel',
      title: title,
      bigPicture: message.notification?.android?.imageUrl,
      body: body,
      displayOnBackground: true,
      displayOnForeground: true,
      wakeUpScreen: true,
      payload: message.data.map((key, value) => MapEntry(key, value.toString())),
       notificationLayout: message.notification?.android?.imageUrl!=null?NotificationLayout.BigPicture:null
  )
);
  }
  void initializeLocalNotifications()async{
       AwesomeNotifications().initialize(
  null,
  [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        enableLights: true,
        enableVibration: true,
      
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white)
  ],
);
AwesomeNotifications().actionStream.listen((event)async { 
  try{
  if(event.payload?['shopId']!=null){
    
    final shopData=await FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_COLLECTIONS).doc(event.payload!['shopId']).get();
   if(shopData.exists){
    final  shop=Shop.fromMap(shopData.data()!, shopData.id);
   
     if(Get.context!=null) Navigator.of(Get.context!).pushNamed(ShopDetailScreen.routeName,arguments: shop);
    }

  }
  }catch(e){}
});
  }
//  Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/${url.split('/').last}';
//     final Response response = await get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }
}
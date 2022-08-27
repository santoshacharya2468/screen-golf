import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:massageapp/admin/models/app_notification.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';

class NotificationController extends GetxController{
   
   
  Future<void> sendPushNotification(AppNotification notification)async{
   await FirebaseFirestore.instance.collection(FirebaseCollections.NOTIFICATION_COLLECIONS).add(notification.toMap());
    showSuccessToast(translator.sucess);
   }
}
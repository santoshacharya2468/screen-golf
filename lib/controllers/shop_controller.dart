import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:massageapp/admin/models/message.dart';
import 'package:massageapp/admin/screens/chat_screen.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/functions/compress_image.dart';
import 'package:massageapp/functions/fileupload.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/dialog_helper.dart';
import 'package:massageapp/helper/get_location.dart';
import 'package:massageapp/helper/get_roomid.dart';
import 'package:massageapp/models/massage_categories.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/models/shop_categories.dart';
import 'package:massageapp/models/shop_recomendation_vm.dart';

class ShopController extends GetxController {
  var shops = List<Shop>.empty(growable: true).obs;
  var allshops = List<Shop>.empty(growable: true).obs;
  var shopByCategory = List<Shop>.empty(growable: true).obs;
  var currentShops = List<Shop>.empty(growable: true).obs;
  final docRef = FirebaseFirestore.instance
      .collection(FirebaseCollections.SHOP_COLLECTIONS);
  var shopsByMassageId = List<Shop>.empty(growable: true).obs;
  var allCategories = List<ShopCategory>.empty(growable: true).obs;
  var massageCategories = List<MassageTypes>.empty(growable: true).obs;

  ///recomended shops
  fetchShops() async {
    final docs = (await docRef.where('isActive', isEqualTo: true).get()).docs;
    shops.clear();
    for (var doc in docs) {
      shops.add(Shop.fromMap(doc.data(), doc.id));
    }
    final cLocation = await getCurrentLocation();
    if (cLocation != null) {
      Get.find<AuthController>().currentUser.value.position =
          LatLng(cLocation.latitude, cLocation.longitude);
      shops.sort((a, b) => Geolocator.distanceBetween(a.position!.latitude,
              a.position!.longitude, cLocation.latitude, cLocation.longitude)
          .compareTo(Geolocator.distanceBetween(b.position!.latitude,
              b.position!.longitude, cLocation.latitude, cLocation.longitude)));
    }
  }

  fetchAllShop() async {
    final docs = (await docRef.get()).docs;
    allshops.clear();
    for (var doc in docs) {
      allshops.add(Shop.fromMap(doc.data(), doc.id));
    }
  }

  onInit() {
    super.onInit();
    // fetchAllCategories();
  }

  fetchShopsByCategory(ShopCategory category) async {
    final shops = await FirebaseFirestore.instance
        .collection(FirebaseCollections.SHOP_COLLECTIONS)
        .where('category', isEqualTo: category.id)
        .get();
    shopByCategory.clear();
    shops.docs.forEach((element) {
      shopByCategory.add(Shop.fromMap(element.data(), element.id));
    });
  }

  Future<DocumentReference<Map<String, dynamic>>> addNewShop(Shop shop) async {
    return await docRef.add(shop.toJson());
  }

  Future<List<WorkGallery>> getWorkGallery(String shopId) async {
    final docref = await FirebaseFirestore.instance
        .collection(FirebaseCollections.WORK_GALLERY)
        .where('shopId', isEqualTo: shopId)
        .get();
    List<WorkGallery> gallery = [];
    docref.docs.forEach((element) {
      gallery.add(WorkGallery.fromMap(element.data(), element.id));
    });
    return gallery;
  }

  Future<WorkGallery?> addImageToWorkGallery(
      String shopId, String decription, File selectedFile) async {
    final fileRef = FirebaseStorage.instance.ref('work-gallery');
    final thumbnail = await compressAndGetFile(selectedFile, quality: 20);
    final thumbnailLink = await uploadAndGetUrl(thumbnail.path, fileRef);
    final compressedFile = await compressAndGetFile(selectedFile, quality: 60);
    final imageUrl = await uploadAndGetUrl(compressedFile.path, fileRef);
    final workGallery = WorkGallery(
        thumbnail: thumbnailLink,
        imageUrl: imageUrl,
        description: decription,
        shopId: shopId);
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.WORK_GALLERY)
        .add(workGallery.toMap());
    return workGallery;
  }

  editShop(Shop shop) async {
    await docRef.doc(shop.id).update({
      'name': shop.name,
      'percentageDiscount': shop.percentageDiscount,
      'phoneNumber': shop.phoneNumber,
      'openAt': shop.openAt,
      'closeAt': shop.closeAt,
      'shopDesciption': shop.shopDesciption,
      'notificationKmRange': shop.notificationKmRange,
      'placemark': shop.placemark?.toJson(),
      'location': shop.position?.toJson(),
      'address': shop.address,
      'images': shop.images,
      "bankAccountHolderName": shop.bankAccountHolderName,
      "bankAccountNumber": shop.bankAccountNumber,
      "bankName": shop.bankName
    });
    Get.find<AuthController>().fetchUserShop();
    return true;
  }

  Future<bool> removeShop(Shop shop) async {
    try {
      final dialog = await DialogHelper.showConfirmDialog(Get.context!,
          confirmMessage: 'Are you sure want to remove this shop?');
      if (dialog == true) {
        await FirebaseFirestore.instance
            .collection(FirebaseCollections.SHOP_COLLECTIONS)
            .doc(shop.id)
            .delete();
        showSuccessToast(translator.sucess);
        fetchShops();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showErrorToasts(translator.error);
      return false;
    }
  }

  Future<bool> changeShopState(Shop shop) async {
    try {
      final String message =
          shop.isActive ? translator.deactive : translator.active;
      final dialog = await DialogHelper.showConfirmDialog(Get.context!,
          confirmMessage:
              '${translator.areYouSureWantTo} $message  ${translator.shop}?');
      if (dialog == true) {
        await FirebaseFirestore.instance
            .collection(FirebaseCollections.SHOP_COLLECTIONS)
            .doc(shop.id)
            .update({'isActive': !shop.isActive});
        fetchShops();
        showSuccessToast(translator.sucess);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showErrorToasts(translator.error);
      return false;
    }
  }

  Future<bool> changeSingleFieldOnShop(
      {required String key, dynamic value, required String shopId}) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.SHOP_COLLECTIONS)
        .doc(shopId)
        .update({key: value});
    showSuccessToast(translator.sucess);
    return true;
  }

  viewShop(String shopId) {
    FirebaseFirestore.instance
        .collection(FirebaseCollections.SHOP_COLLECTIONS)
        .doc(shopId)
        .collection(FirebaseCollections.SHOP_VIEWS)
        .add({
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'time': FieldValue.serverTimestamp()
    });
  }

  Future<bool> addOrEditCategory(
      {ShopCategory? category, required String name, File? file}) async {
    String? url = category?.iconUrl;
    if (file != null) {
      url = await uploadAndGetUrl(
          file.path, FirebaseStorage.instance.ref('categories'),
          showSnack: true);
    }
    if (category != null) {
      await FirebaseFirestore.instance
          .collection(FirebaseCollections.SHOP_CATEGORY)
          .doc(category.id)
          .update({'name': name, 'icon': url});
    } else {
      await FirebaseFirestore.instance
          .collection(FirebaseCollections.SHOP_CATEGORY)
          .add(ShopCategory(name: name, iconUrl: url!, id: '').toMap());
    }

    return true;
  }

  Future<void> writeReview(
      {required String review,
      required double rating,
      required String shopId}) async {
    final docId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final previousReview = await FirebaseFirestore.instance
        .collection(FirebaseCollections.REVIEW_COLLECTION)
        .where('userId', isEqualTo: docId)
        .where('shopId', isEqualTo: shopId)
        .limit(1)
        .get();
    if (previousReview.docs.length > 0) {
      showErrorToasts(translator.alreadySubmitted);
      return;
    }
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.REVIEW_COLLECTION)
        .add({
      'review': review,
      'rating': rating,
      'userId': docId,
      'shopId': shopId,
      'createdAt': FieldValue.serverTimestamp()
    });
    showSuccessToast(translator.sucess);
  }

  Future<bool> bookMarkShop({required Shop shop}) async {
    final docId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final shopId = shop.id;
    final preDoc = await FirebaseFirestore.instance
        .collection(FirebaseCollections.BOOKMARK_COLLECTION)
        .where('userId', isEqualTo: docId)
        .where('shopId', isEqualTo: shopId)
        .limit(1)
        .get();
    bool bookmark = true;
    if (preDoc.docs.length > 0) {
      await preDoc.docs.first.reference.delete();
      bookmark = false;
    } else {
      await FirebaseFirestore.instance
          .collection(FirebaseCollections.BOOKMARK_COLLECTION)
          .add({
        'userId': docId,
        'shopId': shopId,
        'createdAt': FieldValue.serverTimestamp()
      });

      AdminChatScreen.sendMessage(
        Message(
          roomId: getRoomId(docId, shop.userId!),
          senderId: docId,
          receiverId: shop.userId!,
          // body: 'Shop Bookmarked',
          body: '북마크된 상점',
          shopId: shopId,
        ),
        isBookMark: bookmark,
      );
    }
    showSuccessToast(translator.sucess);
    return true;
  }

  Future<bool> addShopRecomendation(ShopRecomendationVm vm) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.recomendations)
        .add(vm.toMap());
    showSuccessToast(translator.sucess);
    return true;
  }
}

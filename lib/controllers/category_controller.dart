import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/models/shop_categories.dart';

class CategoryController extends GetxController {
  var categories = List<ShopCategory>.empty(growable: true).obs;
  final firebaseRef =
      FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_CATEGORY);

  onInit() {
    super.onInit();
   // fetchCategory();
  }

  fetchCategory() async {
    final docs = (await firebaseRef.get()).docs;
    for (var doc in docs) {
      categories.add(ShopCategory.fromMap(doc.data(), doc.id));
    }
  }

  Future<ShopCategory?> getCategoryById(String categoryId) async {
    final doc = await firebaseRef.doc(categoryId).get();
    if (doc.exists) {
      return ShopCategory.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
}

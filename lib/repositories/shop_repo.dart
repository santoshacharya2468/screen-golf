import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:massageapp/constant/app_constants.dart';
import 'package:massageapp/models/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:massageapp/models/models.dart';

class ShopByCategory {
  String category;
  List<Shop> shops;

  ShopByCategory(this.category, this.shops);
}

class ShopRepo {
  Future<Either<List<Shop>, Failure>> getShopsByCategories(
      String category) async{
    List<Shop> shops = [];
    try{
      final docData = await FirebaseFirestore.instance
          .collection('shops')
          .where(AppConstants.Categories, isEqualTo: category).get();
      docData.docs.map((e) => shops.add(Shop.fromMap(e.data(), e.id))).toList();
      return Left(shops);
    } on FirebaseException catch(e){
      return Right(Failure(message: e.message));
    }
  }
}

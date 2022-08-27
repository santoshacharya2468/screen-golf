import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/widgets/widgets.dart';

class FavoriteShopListScreen extends StatefulWidget {
  static const String routeName='/favorite_shop_list_screen';
  const FavoriteShopListScreen({ Key? key }) : super(key: key);

  @override
  State<FavoriteShopListScreen> createState() => _FavoriteShopListScreenState();
}

class _FavoriteShopListScreenState extends State<FavoriteShopListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.favorite+' '+ translator.shop),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(FirebaseCollections.BOOKMARK_COLLECTION)
        .where('userId',isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
        builder: (_,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snpashot){
          if(snpashot.hasData && snpashot.data!=null){
            return  GridView.builder(
        itemCount:snpashot.data!.docs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
        childAspectRatio: 4/5
        ),
        itemBuilder: (_,index){
          final shopData=snpashot.data!.docs[index].data();
          return FutureBuilder(
            future: FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_COLLECTIONS)
           
            .doc(shopData['shopId']).get(),
            builder: (_,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snpahost){
              if(snpahost.hasData && snpahost.data!=null){
                if(snpahost.data!.exists){
                  final shop=Shop.fromMap(snpahost.data!.data()!, snpahost.data!.id);
                  if(shop.isActive){
                  return SingleShopview(shop: shop);
                  }
                }
                return Text('Shop Not Found');
              }
              return Loading();
            },
          );
        },
      );
          }
          return Loading();
        },
      ),
    );
  }
}
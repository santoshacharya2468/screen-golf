import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/screens/screens.dart';

class TopVisitedShops extends StatelessWidget {
  const TopVisitedShops({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(FirebaseCollections.SHOP_COLLECTIONS)
            .where('isActive', isEqualTo: true)
            .orderBy('totalvisits', descending: true)
            .where('isSell', isEqualTo: false)
            .where('isLease', isEqualTo: false)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final docs = snapshot.data!.docs;
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 08),
                child: Container(
                  height: 90.0,
                  width: deviceSize.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var shopData = docs[index];
                      final shop = Shop.fromMap(shopData.data(), shopData.id);
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ShopDetailScreen.routeName,
                              arguments: shop);
                        },
                        child: Container(
                          width: 90.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 30.0,
                                backgroundImage: CachedNetworkImageProvider(
                                    shop.images.first),
                              ),
                              Center(
                                child: Text(
                                  shop.name,
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ));
          } else {
            return SizedBox();
          }
        });
  }
}

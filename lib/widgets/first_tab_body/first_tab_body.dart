import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/models/massage_categories.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/screens/screens.dart';
import 'package:massageapp/widgets/input_spacer.dart';

import '../hotel_info_card.dart';

class FirstTabBody extends StatefulWidget {
  final int index;
  final String massageId;

  const FirstTabBody({Key? key, required this.index, required this.massageId})
      : super(key: key);

  @override
  _FirstTabBodyState createState() => _FirstTabBodyState();
}

class _FirstTabBodyState extends State<FirstTabBody> {
  final shopController = Get.find<ShopController>();
  List<MassageTypes>? currentMassageType = [];

  @override
  void initState() {
    super.initState();
    currentMassageType = shopController.massageCategories;
    // shopController.fetchShopsByMassageTypes(
    //     massageTypeId: currentMassageType?.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          InputSpacer(
            child: Container(
                height: size.height * 0.05,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.grey[300]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InputSpacer(
                      child: Text(
                        "Wow",
                        // style: Theme.of(context)
                        //     .textTheme
                        //     .bodyText1
                        //     ?.copyWith(color: Colors.black),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.query_builder, color: Colors.black),
                        InputSpacer(child: Text("Query"))
                      ],
                    )
                  ],
                )),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseCollections.shopRef
                .where("massageType", isEqualTo: widget.massageId)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              List<Shop> shops = [];
              var docs = snapshot.data?.docs;
              for (var doc in docs ?? []) {
                shops.add(Shop.fromMap(doc.data(), doc.id));
              }
              return ListView.builder(
                itemCount: shops.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, ShopDetailScreen.routeName,
                            arguments: shops[index]);
                      },
                      child: HotelInfoCard(shop: shops[index]));
                },
              );
            },
          )

          // Obx(
          //       () =>
          //       ListView.builder(
          //         physics: NeverScrollableScrollPhysics(),
          //         shrinkWrap: true,
          //         itemCount: shopController.shopsByMassageId.length,
          //         itemBuilder: (context, index) {
          //           return InputSpacer(
          //               child: InkWell(
          //                   onTap: () {
          //                     Navigator.pushNamed(
          //                         context, ShopDetailScreen.routeName, arguments: shopController.shopsByMassageId[index]);
          //                   },
          //                   child: HotelInfoCard(
          //                     shop: shopController.shopsByMassageId[index],
          //                   )));
          //         },
          //       ),
          // ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.vertical,
          //   // physics: AlwaysScrollableScrollPhysics(),
          //   child:

          //   Column(
          //     children: [
          //       InputSpacer(child: HotelInfoCard(shop: )),
          //       InputSpacer(child: HotelInfoCard()),
          //       InputSpacer(child: HotelInfoCard()),
          //       InputSpacer(child: HotelInfoCard()),
          //       InputSpacer(child: HotelInfoCard()),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}

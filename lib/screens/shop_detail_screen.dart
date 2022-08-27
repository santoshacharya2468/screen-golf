import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:massageapp/admin/screens/chat_screen.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/widgets/column_with_padding.dart';
import 'package:massageapp/widgets/rating_widget.dart';
import 'package:massageapp/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart' as laucher;

class ShopDetailScreen extends StatefulWidget {
  static const String routeName = '/shop_details';
  final Shop shop;

  const ShopDetailScreen({Key? key, required this.shop}) : super(key: key);

  @override
  _ShopDetailScreenState createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final _auth = FirebaseAuth.instance;
  List<WorkGallery>? workGallery;

  void _fetchWorkGalleryView() async {
    workGallery =
        await Get.find<ShopController>().getWorkGallery(widget.shop.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchWorkGalleryView();
    Get.find<ShopController>().viewShop(widget.shop.id);
  }
  

  @override
  Widget build(BuildContext context) {
    final authController=Get.find<AuthController>();
    final shop=widget.shop;
    return Scaffold(
      floatingActionButton:  Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        if(shop.phoneNumber!=null)  Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
               heroTag: 'call',
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      laucher.launch('tel:${shop.phoneNumber}');
                    },
                    child: Icon(Icons.call),
                  ),
          ),
             
          if(widget.shop.allowChat)Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: 'message',
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if(widget.shop.userId!=null){
                      Navigator.of(context).pushNamed(AdminChatScreen.routeName,
                         arguments: widget.shop
                      );
                      }else {
                        showErrorToasts(translator.error);
                      }
                    },
                    child: Icon(Icons.message),
                  ),
          ),
                
              if(widget.shop.position!=null)  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    heroTag: 'location',
                      backgroundColor: Theme.of(context).primaryColor,
                    onPressed: ()async{
                      String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${widget.shop.position!.latitude},${widget.shop.position!.longitude}';
                      laucher.launch(googleUrl);
                    },
                    child: Icon(Icons.location_on_outlined),
                  ),
                )
        ],
      ),
      appBar: MyAppBar(
        widget.shop,
        title: Text('${translator.storeInformation}'),
       
       showBooking:!(widget.shop.isSell || widget.shop.isLease),
      
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
               SizedBox(
                 height: 200,

                 child: ListView.builder(
                   itemCount: shop.images.length,
                   scrollDirection: Axis.horizontal,
                   itemBuilder: (a,index){
                     final url=shop.images[index];
                     return Container(
                       width: MediaQuery.of(context).size.width,
                       child: CachedNetworkImage(imageUrl: url,
                        fit: BoxFit.fitWidth,
                       ));
                   },
                 ),
               ),
               
              BodyPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Text(widget.shop.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),

                    
                  // if(widget.shop.isSell || widget.shop.isLease)  Expanded(
                    
                  //     child: 
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //  children:_tabs.map((e) => InkWell(
                     
                  //    onTap: (){
                  //    setState(() {
                  //      _currenTab=_tabs.indexOf(e);
                  //    });
                  //  }, child: Container(
                  //    padding: const EdgeInsets.all(10),
                  //    width: 120,
                  //    decoration: BoxDecoration(
                  //      borderRadius: BorderRadius.circular(10),
                  //       color: _tabs.indexOf(e)==_currenTab?Theme.of(context).primaryColor:Colors.grey
                  //    ),
                  //    child: Center(child: Text(e,
                  //      style: Theme.of(context).textTheme.button!.copyWith(
                  //        color: Colors.white
                  //      ),
                  //    ))))).toList()
                  //   )
                  //   )
                  ],
                ),
              ),
              if(workGallery!=null && workGallery!.isNotEmpty)  Container(
                height: 100,
                  child: WorkGalleryView(
                shop: widget.shop,
                workGallery: workGallery,
              )),
               
              const SizedBox(height: 03,),
              _buildInformationBar(widget.shop,authController.currentUser.value),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildShopInoformations(),
              ),
               SizedBox(height: kBottomNavigationBarHeight,)
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
  _buildInformationBar(Shop shop,ApplicationUser currentUser){
    return Container
    (
      height: 50
      ,
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(horizontal: 08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_COLLECTIONS)
            .doc( shop.id).
            snapshots(),
            builder: (context,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              double averageRating=0;
              int totalRating=0;
               if(snapshot.hasData && snapshot.data!=null){
                 final doc=snapshot.data!;
                 final updatedShop=Shop.fromMap(doc.data()!, doc.id);
                 averageRating=updatedShop.rating.toDouble();
                  totalRating=updatedShop.totalReviews;
               }

              return InkWell(
                onTap: (){
                  if(shop.userId==_auth.currentUser?.uid){
                    showErrorToasts(translator.youCantReviewownShop);
                    return;
                  }
                  AddRatingView.showRatingDialog(shop, context);
                },
                child: _buildIconAndLabel( Icon(Icons.star,
                 color: Theme.of(context).primaryColor,
                ), '$averageRating($totalRating)'),
              );
            }
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection(FirebaseCollections.BOOKMARK_COLLECTION)
            .where('shopId',isEqualTo: shop.id).snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot) {
              int totalBookmarks=0;
              bool hasBookmarked=false;
               if(snapshot.hasData&& snapshot.data!=null){
                 final docs=snapshot.data!.docs;
                 totalBookmarks=docs.length;
                 docs.forEach((element) {
                    if(element.data()['userId']==_auth.currentUser?.uid){
                      hasBookmarked=true;
                    }
                  });
                  
               }
              return InkWell(
                onTap: (){
                  Get.find<ShopController>().bookMarkShop(shop: shop);
                },
                child: _buildIconAndLabel(Icon(
                 !hasBookmarked? Icons.favorite_outline:Icons.favorite,
                  color:Theme.of(context).primaryColor), '$totalBookmarks ${translator.steams}'));
            }
          ),
           Builder(
             builder: (context) {
               String text='----';
               if(shop.position!=null && currentUser.position!=null){
               final meters=Geolocator.distanceBetween(
                 currentUser.position!.latitude,
                 currentUser.position!.longitude,
                 shop.position!.latitude,
                 shop.position!.longitude
               )
               ;
               var km=meters/1000.0;
                  text='${km.toStringAsFixed(2)} KM';
               }
               return _buildIconAndLabel(Icon(Icons.location_on_outlined,color:Theme.of(context).primaryColor), text);
             }
           ),

         
         
        ],
      ),
    );
  }
 Widget _buildShopInoformations(){
   if(widget.shop.isSell || widget.shop.isLease){
   if(widget.shop.isSell){
     return _buildSellInformationTab(widget.shop);
   }else {
     return _buildRentInformationTab(widget.shop);
   }
   }else {
     return _buildBookingShopInformationTab(widget.shop);
   }
 }
 _buildAverageVisitor(Shop shop){
    return FutureBuilder(
      future: FirebaseFirestore.instance.
      collection(FirebaseCollections.SHOP_COLLECTIONS)
      .doc(shop.id).collection(FirebaseCollections.SHOP_VIEWS).get(),
      builder: (_,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snpahost){
        if(snpahost.hasData && snpahost.data!=null){
           
          return Text(snpahost.data!.docs.length.toString());
        }
        else  return Text('--');
      },
    );
 }
 _buildSellInformationTab(Shop shop){
   return ColumnWithPadding(padding: const EdgeInsets.only(bottom: 20), children: [
       _buildInforamtionKeyValue(translator.depositMonthlyRent,(shop.deposit??'--')+'원'),
       _buildInforamtionKeyValue(translator.facilityEquipmentFee,(shop.facility??'--')+'원'),
      _buildInforamtionKeyValue('${translator.members}','${shop.averageMonthlyVisitor}${translator.noOfPeople}',),
      _buildInforamtionKeyValue('${translator.sale}/${translator.lease} ${translator.price}',(shop.sellPrice??'--')+'원'),
      _buildInforamtionKeyValue('${translator.contact}',shop.phoneNumber??'--'),
      _buildInforamtionKeyValue(translator.address,shop.addressName),
        _buildInforamtionKeyValue(translator.description,shop.shopDesciption??''),
   ]);
 }
 _buildBookingShopInformationTab(Shop shop){
   return ColumnWithPadding(padding: const EdgeInsets.only(bottom: 20), children: [
      _buildInforamtionKeyValue('${translator.contact}',shop.phoneNumber??'--'),
      _buildInforamtionKeyValue(translator.address,shop.addressName),
       _buildInforamtionKeyValue(translator.discount,'${shop.percentageDiscount} %'),
        _buildInforamtionKeyValue('${translator.reservation} ${translator.time}',shop.openAt==null?'----':'${shop.openAt} ~ ${shop.closeAt}'),
      _buildInforamtionKeyValue('${translator.companion}','',customValue: _buildAverageVisitor(shop)),
       _buildInforamtionKeyValue(translator.description,shop.shopDesciption??''),
     
   ]);
 }
 _buildRentInformationTab(Shop shop){
    return ColumnWithPadding(padding: const EdgeInsets.only(bottom: 20), children: [
       _buildInforamtionKeyValue(translator.depositMonthlyRent,(shop.monthlyRent??'--')+'원'),
       _buildInforamtionKeyValue(translator.facilityEquipmentFee,(shop.equiptmentFee??'--')+'원'),
      _buildInforamtionKeyValue('${translator.members}','${shop.averageMonthlyVisitor}${translator.noOfPeople}',),
      _buildInforamtionKeyValue('${translator.sale}/${translator.lease} ${translator.price}',(shop.rentalPrice??'--')+'원'),
      _buildInforamtionKeyValue('${translator.contact}',shop.phoneNumber??'--'),
      _buildInforamtionKeyValue(translator.address,shop.addressName),
       _buildInforamtionKeyValue(translator.description,shop.shopDesciption??''),
   ]);
 }

  Widget _buildInforamtionKeyValue(String key,String value,{Widget? customValue}){
    return Column(
      children: [
        Row(
          children: [
            Text(key,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.black
              ),
            ),
            const SizedBox(width: 20,),
          customValue??  Text(value)
          ],
        ),
        Divider()
      ],
    );
  }
Widget  _buildIconAndLabel(Widget icon,String label){
    return Row(
      children: [
        icon,Text(label)
      ],
    );
  }




}

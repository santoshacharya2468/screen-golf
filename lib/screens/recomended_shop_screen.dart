import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/screens/recomend_shop_screen.dart';
import 'package:massageapp/widgets/column_with_padding.dart';
import 'package:massageapp/widgets/scrollable_items_with_pagination.dart';
import 'package:massageapp/widgets/widgets.dart';

class ShopRecomendedListScreen extends StatelessWidget {
  static const String routeName='/shop_recomended_screen';
  const ShopRecomendedListScreen({ Key? key }) : super(key: key);
  _buildKeyValue(String key,String value,BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key,
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(value)
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final myId=FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      floatingActionButton: FloatingActionButton
      (
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).pushNamed(RecomendShopScreen.routeName);
        },
      ),
       appBar: AppBar(
         title: Text('${translator.shop} ${translator.recomend}'),
       ),
       body: StreamBuilder(
         stream: FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_COLLECTIONS)
         .where(
           'recomendedBy',isEqualTo: myId
         )
         .snapshots(),
         builder: (_,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.hasData && snapshot.data!=null){
            return ScrollableItemWithPagination<QueryDocumentSnapshot<Map<String, dynamic>>>(
              onNewItemsDemanded: (){},
             itemBuilder: (doc,index){
               final vm =Shop.fromMap(doc.data(),doc.id);
               return InputSpacer(child: Card(
                 
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ColumnWithPadding(
                     padding: const EdgeInsets.symmetric(vertical: 05),
                     children: [
                       Center(
                         child: CircleAvatar(
                           radius: 65,
                           backgroundImage: CachedNetworkImageProvider( vm.images.first,
                           
                           ),
                         ),
                       ),
                       _buildKeyValue('${translator.shop} ${translator.name}',vm.name,context),
                       _buildKeyValue('${translator.shop} ${translator.address}', vm.address,context),
                       _buildKeyValue('${translator.contact}', vm.phoneNumber??'',context),
                        // _buildKeyValue('Category', '${vm.category}',context),
                        
                       Container(
                         height: 30,
                         decoration:BoxDecoration(
                           borderRadius: BorderRadius.circular(05),
                           color: Theme.of(context).primaryColor,

                         ) ,
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 06),
                           child: Center(
                             child: Text(vm.isActive?translator.accepted:translator.pending,
                               style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                 color: Colors.white
                               )
                             ),
                           ),
                         ),
                       ),


                     ],
                   ),
                 ),
               ));
             },
              items: snapshot.data!.docs);
          }
          return Loading();
         },
       ),

    );
  }
}
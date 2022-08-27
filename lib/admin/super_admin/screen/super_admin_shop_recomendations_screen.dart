import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/models/application_user.dart';
import 'package:massageapp/models/shop_recomendation_vm.dart';
import 'package:massageapp/screens/recomend_shop_screen.dart';
import 'package:massageapp/widgets/column_with_padding.dart';
import 'package:massageapp/widgets/scrollable_items_with_pagination.dart';
import 'package:massageapp/widgets/widgets.dart';

class SuperAdminShopRecomendationScreen extends StatelessWidget {
  static const String routeName='/super_admin_shop_recomended_screen';
   SuperAdminShopRecomendationScreen({ Key? key }) : super(key: key);
  _buildKeyValue(String key,String value,BuildContext context,{Widget? customValue}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key,
          style: Theme.of(context).textTheme.headline6,
        ),
       if(customValue==null) Text(value)
       else customValue
      ],
    );
  }
  final List<String> status=['Pending','Accept','Reject'];
  @override
  Widget build(BuildContext context) {
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
         title: Text('Shop Recomended'),
       ),
       body: StreamBuilder(
         stream: FirebaseFirestore.instance.collection(FirebaseCollections.recomendations)
         
         .snapshots(),
         builder: (_,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.hasData && snapshot.data!=null){
            return ScrollableItemWithPagination<QueryDocumentSnapshot<Map<String, dynamic>>>(
              onNewItemsDemanded: (){},
             itemBuilder: (doc,index){
               final vm =ShopRecomendationVm.fromMap(doc.data());
               return InputSpacer(child: Card(
                 
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ColumnWithPadding(
                     padding: const EdgeInsets.symmetric(vertical: 05),
                     children: [
                       FutureBuilder(
                         future: FirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS).doc(vm.recomendedBy).get(),
                         builder: (_,AsyncSnapshot<DocumentSnapshot<Map<String,dynamic>>> snapshot){
                           if(snapshot.hasData && snapshot.data!.exists){
                             final appuser=ApplicationUser.fromMap(snapshot.data!.data()!);
                             return    _buildKeyValue('User Name',appuser.name??appuser.email??'',context);
                           }
                           return SizedBox();
                         },
                       ),
                       _buildKeyValue('Shop Name',vm.name,context),
                       _buildKeyValue('Shop Address', vm.address,context),
                        _buildKeyValue('Owner Name',vm.ownerName,context),
                       _buildKeyValue('Phone Number', vm.phoneNumber,context),
                        _buildKeyValue('Point Earned', '${vm.pointEarn??0}',context),
                        _buildKeyValue('Status', vm.getStatus(),context,customValue: DropdownButton<String>(items: status.map((e) => DropdownMenuItem(child: Text(e),value: e,)).toList(), onChanged: (e)async{
                          bool acepted=vm.status==1;
                          if(acepted){
                            FirebaseFirestore.instance.collection(FirebaseCollections.POINT_COLLECTION)
                            .doc('shop_reco_${doc.id}')
                            .set({
                              'point':10,
                              'title':'Point for shop recomendations',
                              'userId':vm.recomendedBy,
                              'createdAt':FieldValue.serverTimestamp(),
                              'docId':'shop_reco'+doc.id
                            });
                          }
                          doc.reference.update(
                            {'status':status.indexOf(e??'Pending',
                          
                          ),
                            'pointEarn':acepted?10:0,
                          });
                        },
                         value:status[vm.status],
                        )),
                        
                      //  Align(
                      //    alignment: Alignment.bottomRight,
                      //    child: InkWell(
                      //      onTap: (){
                           
                      //      },
                      //      child: Container(
                      //        height: 30,
                      //        width: 70,
                      //        decoration:BoxDecoration(
                      //          borderRadius: BorderRadius.circular(05),
                      //          color: Theme.of(context).primaryColor,

                      //        ) ,
                      //        child: Padding(
                      //          padding: const EdgeInsets.symmetric(horizontal: 06),
                      //          child: Center(
                      //            child: Text('Action',
                      //              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      //                color: Colors.white
                      //              )
                      //            ),
                      //          ),
                      //        ),
                      //      ),
                      //    ),
                      //  ),


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
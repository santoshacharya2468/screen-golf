import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/application_user.dart';
import 'package:massageapp/models/book_model.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/screens/user_point_screen.dart';
import 'package:massageapp/widgets/column_with_padding.dart';
import 'package:massageapp/widgets/widgets.dart';

class SuperAdminShopDetailsScreen extends StatefulWidget {
  static const String routeName = '/super_admin_shop_details_screen';
  final String shopId;
  const SuperAdminShopDetailsScreen({Key? key, required this.shopId})
      : super(key: key);

  @override
  State<SuperAdminShopDetailsScreen> createState() =>
      _SuperAdminShopDetailsScreenState();
}

class _SuperAdminShopDetailsScreenState
    extends State<SuperAdminShopDetailsScreen> {
  Widget _buildActionTile({required String title, required Widget action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline6!.copyWith(
            color: Colors.black
          ),
        ),
        action
      ],
    );
  }
  final _notificationCountController=TextEditingController();
  final _virtualNumberController=TextEditingController();
  bool _phoneSet=false;

  @override
  Widget build(BuildContext context) {
    final _shopController=Get.find<ShopController>();
    return Scaffold(
      appBar: AppBar(title: Text(translator.storeInformation)),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(FirebaseCollections.SHOP_COLLECTIONS)
              .doc(widget.shopId)
              .snapshots(),
          builder: (_,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final shop =
                  Shop.fromMap(snapshot.data!.data()!, snapshot.data!.id);
                  if(_notificationCountController.text.isEmpty){
                  _notificationCountController.text=shop.maximumNotifications.toString();
                  }
                  if(!_phoneSet){
                     _virtualNumberController.text=shop.virtualNumber??'';
                     _phoneSet=true;
                  }
              return ColumnWithPadding(
                padding: const EdgeInsets.only(bottom: 10,left: 08,right: 08,top: 08),
                children: [
                  
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover, imageUrl: shop.images.first)),
                    if(shop.recomendedBy!=null) FutureBuilder(
                     future: FirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS).doc(shop.recomendedBy).get(),
                      builder: (_,AsyncSnapshot<DocumentSnapshot<Map<String,dynamic>>> snpshot){
                         if(snapshot.hasData && snpshot.data!=null){
                           final user=ApplicationUser.fromMap(snpshot.data!.data()!);
                           return Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(translator.recomendedBy,
                                style: Theme.of(context).textTheme.headline6!,
                               ),
                               Text(user.namePlaceholder)
                             ],
                           );
                         }
                         return SizedBox();
                      },
                  ),
                     _buildActionTile(
                      title: translator.contact,
                      action: Text(shop.phoneNumber??'')
                          ),   
                  _buildActionTile(
                      title: '${translator.shopEnableDisable}',
                      action: CupertinoSwitch(
                          value: shop.isActive, onChanged: (e) async{
                             
                            _shopController.changeShopState(shop);
                            if(e && shop.recomendedBy!=null){
                              //ip0B7nFrBqsw64xu4eiu
                              final points= (await FirebaseFirestore.instance.collection('configurations').doc('configurations').get()).data()!['initialPoints'];
                              FirebaseFirestore.instance.collection(FirebaseCollections.POINT_COLLECTION)
                            .doc('shop_reco_${shop.id}')
                            .set({
                              'point':points,
                              'title':'매장 추천으로 포인트 적립',
                              'userId':shop.recomendedBy,
                              'createdAt':FieldValue.serverTimestamp(),
                              'docId':'shop_reco'+shop.id
                            });
                            }
                          })),
                  _buildActionTile(title: '${translator.enableDisablePushNotification}', 
                  action: CupertinoSwitch(
                          value: shop.allowPush, 
                          onChanged: (e)async {
                          await _shopController.changeSingleFieldOnShop(key: 'allowPush', shopId: shop.id,value: e);
                          }
                  )
                  )  , 
                  _buildActionTile(title: '${translator.enableDisableChatMessage} ', 
                  action: CupertinoSwitch(
                          value: shop.allowChat, 
                          onChanged: (e)async {
                          await _shopController.changeSingleFieldOnShop(key: 'allowChat', shopId: shop.id,value: e);
                          }
                  )
                  )  , 
                   _buildActionTile(title: '${translator.maximumPoushNotification} ', 
                  action: Container(
                    width: 80,
                    height: 40,

                    child: TextField(
                      controller: _notificationCountController,
                      onSubmitted: (e){
                        try{
                          _shopController.changeSingleFieldOnShop(key:'maximumNotifications' , shopId: shop.id,
                        value: int.parse(e)
                        );
                        }
                        catch(e){

                        }
                        
                      },
                        keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        
                        border: OutlineInputBorder()
                      ),
                    ),
                  )
                  ),  
                  _buildActionTile(title: translator.packageExpiryDate, 
                  action: Row(
                    children: [
                    Builder(builder: (context){
                        String data='----';
                         if(shop.packageExpiryDate!=null){
                          data= DateFormat('yyyy-MM-dd').format(shop.packageExpiryDate!);
                         }
                        return Text(data);
                      }),
                      IconButton(onPressed: ()async{
                        final dateTime=await showDatePicker(context: context, 
                        initialDate: shop.packageExpiryDate??DateTime.now(), 
                        firstDate: DateTime.now(),
                         lastDate: DateTime.now().add(Duration(days: 365*2))
                         );
                         if(dateTime!=null){
                           _shopController.changeSingleFieldOnShop(key:'packageExpiryDate' , shopId: shop.id,
                             value: dateTime.toString()
                           );
                         }
                      }, icon: Icon(Icons.arrow_drop_down,color: Colors.black,)),
                    ],
                  )
                  )  ,  
                  //   _buildActionTile(title: 'Virtual Number', 
                  // action: Container(
                  //   width: 200,
                  //   height: 40,

                  //   child: TextField(
                  //     controller: _virtualNumberController,
                      
                  //     onSubmitted: (e){
                  //       try{
                  //         _shopController.changeSingleFieldOnShop(key:'virtualNumber' , shopId: shop.id,
                  //       value:e
                  //       );
                  //       }
                  //       catch(e){

                  //       }
                        
                  //     },
                  //       keyboardType: TextInputType.number,
                  //     decoration: InputDecoration(
                        
                  //       border: OutlineInputBorder()
                  //     ),
                  //   ),
                  // )
                  // ), 
                   const  SizedBox(height: 20,),
                  SuperAdminShopExtraDetailsTab(
                    shop: shop,
                  ),

                ],
              );
            }
            return const Center(child: Loading());
          },
        ),
      ),
    );
  }
}

class SuperAdminShopExtraDetailsTab extends StatefulWidget {
  final Shop shop;
  const SuperAdminShopExtraDetailsTab({ Key? key ,required this.shop}) : super(key: key);

  @override
  State<SuperAdminShopExtraDetailsTab> createState() => _SuperAdminShopExtraDetailsTabState();
}

class _SuperAdminShopExtraDetailsTabState extends State<SuperAdminShopExtraDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:Column(
        children: [
          TabBar(tabs: [['Users',translator.users],['Bookings',translator.bookings]].map((e) => Text(e.last,
            style: Theme.of(context).textTheme.headline6,
          )).toList()),
          SizedBox(height: 20,),
          SizedBox(
            height: 400,
            child: TabBarView(children: [UserListView(shop: widget.shop,),BookingListView(shop: widget.shop,)] )),
            SizedBox(height: 10,)
        ],
      ) ,
    );
  }
}


class UserListView extends StatelessWidget {
  final Shop shop;
  const UserListView({ Key? key,required this.shop }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
       stream: FirebaseFirestore.instance.
       collection(FirebaseCollections.MESSAGECOLLECTION)
       .where('shopId',isEqualTo: shop.id)
       .orderBy('sentAt',descending: true)
       .snapshots(),
       builder: (_,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
         if(snapshot.hasData && snapshot.data!=null){
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
               itemBuilder: (_,index){
                  final data=snapshot.data!.docs[index].data();
                 final users=data['users'] as List;
                 String userId='';
                 if(users.first==shop.userId){
                   userId=users.last;
                 }else {
                   userId=users.first;
                 }
                 return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS)
                    .doc(userId).snapshots(),
                    builder: (_,AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> usersnapshot){
                      if(usersnapshot.hasData && usersnapshot.data!=null && usersnapshot.data!.exists){
                         final user=ApplicationUser.fromMap(usersnapshot.data!.data()!);
                        return Card(
                   child: ListTile(
                     onTap: (){
                       Navigator.of(context).pushNamed(UserPointScreen.routeName,arguments: user.uid);
                     },
                      contentPadding: const  EdgeInsets.symmetric(horizontal: 03,vertical: 05),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 10,),
                          //Text(message),
                          const SizedBox(height: 10,),
                          Text('${user.points} ${translator.points}',
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                      
                      leading: user.profilePicture==null?Icon(Icons.person):CircleAvatar(
                        backgroundImage:NetworkImage(user.profilePicture!)
                      ),
                     title: Text(user.name!=null && user.name!.isNotEmpty?user.name!:user.email?? user.uid!),
                   ),
                 );
                      }else {
                        return SizedBox();
                      }
                    }
                 );
                
               },
            );
         }
         return SizedBox();
       },
    );
  }
}


class BookingListView extends StatefulWidget {
  final Shop shop;
  const BookingListView({ Key? key,required this.shop }) : super(key: key);

  @override
  State<BookingListView> createState() => _BookingListViewState();
}

class _BookingListViewState extends State<BookingListView> {
  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
       stream: FirebaseFirestore.instance.collection(FirebaseCollections.BOOKINGS).where('massage_shop_id',isEqualTo: widget.shop.id)
       .orderBy('created_at',descending: true)
       .snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.hasData && snapshot.data!=null){

return  ListView.builder(
         itemCount:snapshot.data!.docs.length,
         
         itemBuilder: (_,index){
            final doc=snapshot.data!.docs[index];
           final book=BookingModel.fromJson(doc.data(), doc.id);
           String namePlaceholder='';
           if(book.bookedUser.name!=null && book.bookedUser.name!.isNotEmpty){
              namePlaceholder=book.bookedUser.name!;
           }else {
             namePlaceholder=book.bookedUser.email??'';
           }
           return Card(
             
             child: ListTile(
               leading: Text('${index+1}',
                 style: Theme.of(context).textTheme.headline5,
               ),
               title: Text(translator.personName+" : "+namePlaceholder,
                 style: Theme.of(context).textTheme.bodyText2,
               ),
                trailing: PopupMenuButton(
                   onSelected: (e)async{
                     int newStatus=book.status;
                     if(e=='Accept'){
                       newStatus=1;
                     }else if(e=='Reject'){
                       newStatus=3;
                     }else if(e=='Mark As Complete'){
                        newStatus=2;
                     }
                    await  Get.find<BookingController>().changeStatus(book.bookingId??'', newStatus);
                    book.status=newStatus;
                    setState(() {
                      
                    });
                   },
                  itemBuilder: (_)=>[
                 ['Accept',translator.accept],
                 ['Reject',translator.reject],
                 ['Mark As Complete',translator.markAsComplete]
                ].map((e) => PopupMenuItem(child: Text(e.last),value: e.first,)).toList()
                ),
               subtitle: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  //  Text('${translator.booking} ${translator.date} ${book.createdAt.toString().split(' ').first}'),
                  //   SizedBox(height: 05,),
                  
                   Text('${translator.reservationDate} : ${book.startingDate}'),
                  //  SizedBox(height: 05,),
                  //  Text('${translator.to} ${book.endingDate}'),
                  //  SizedBox(height: 05,),
                  Text('${translator.reservationTime} : ${book.visitingTime}'),
                    SizedBox(height: 05,),
                  Text('${translator.contact} : ${book.phoneNumber}',),
                   SizedBox(height: 05,),
                   Text('${translator.numberOfConpanions} : ${book.noOfClients}'),
                  SizedBox(height: 05,),
                   Text('${translator.status} : ${book.getStatus}')
                 ],
               ),
             ),
           );
         },
      );
          }
          return Loading();
        },
    );
  }
}

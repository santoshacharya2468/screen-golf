import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/admin/screens/chat_screen.dart';
import 'package:massageapp/admin/widgets/pushnotification_dialog.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/application_user.dart';

class AdminBookmarkedUsersList extends StatefulWidget {
   AdminBookmarkedUsersList({ Key? key }) : super(key: key);

  @override
  State<AdminBookmarkedUsersList> createState() => _AdminBookmarkedUsersListState();
}

class _AdminBookmarkedUsersListState extends State<AdminBookmarkedUsersList> {
 
 int _currentTab=0;

  @override
  Widget build(BuildContext context) {
    final List<String> tabs=[
     // translator.all,
      '메시지 한 유저',
      "찜한 유저"
      // translator.favorite
      ];
    final shop=Get.find<AuthController>().currentUser.value.shop!;
    return Column(
      children: [
        Container(
          child: Row(
            children: tabs.map((e) => InkWell(
              onTap: (){
                setState(() {
                  _currentTab=tabs.indexOf(e);
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                decoration: BoxDecoration(
                  color:_currentTab==tabs.indexOf(e)? Theme.of(context).primaryColor:Colors.grey,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Center(
                  child: Text(e,
                   style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
        Builder(
          builder: (context) {
          var query=  FirebaseFirestore.instance.
                 collection(FirebaseCollections.MESSAGECOLLECTION)
                 .where('shopId',isEqualTo: shop.id);
                 if(_currentTab==1){
                   query=query.where('isBookMark',isEqualTo: true);
                 }
            return Expanded(
              child: StreamBuilder(
                 stream: query
                 .orderBy('sentAt',descending: true)
                 .snapshots(),
                 builder: (_,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                   if(snapshot.hasData && snapshot.data!=null){
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                         itemBuilder: (_,index){
                          final data=snapshot.data!.docs[index].data();
                           final users=data['users'] as List;
                           String message=data['body'];
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
                                 if(!shop.allowChat){
                                   showErrorToasts(translator.notallowed);
                                   return;
                                 }
                                 Navigator.of(context).pushNamed(AdminChatScreen.routeName,arguments: user);
                               },
                                contentPadding: const  EdgeInsets.symmetric(horizontal: 03,vertical: 05),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     const SizedBox(height: 10,),
                                    Text(message),
                                    const SizedBox(height: 10,),
                                    Text('${user.points} ${translator.points}',
                                      style: Theme.of(context).textTheme.headline6,
                                    )
                                  ],
                                ),
                                 trailing: PopupMenuButton(
                                    onSelected: (e){
                                      if(e=='Send Notification'){
                                        if(!shop.allowPush){
                                          showErrorToasts(translator.notallowed);
                                          return;
                                        }
                                         showDialog(context: context, builder: (_)=>PushNotificationDialog(user: user));
                                      }else if(e=='Make Discount'){
                                        int? pointSelected;
                                         showDialog(context: context, builder: (context)=>StatefulBuilder(
                                           builder: (context,changeState) {
                                             return AlertDialog(
                                                title: Text('${translator.make} ${translator.discount}'),
                                                 content: Column(
                                                   mainAxisSize: MainAxisSize.min,
                                                   children: [5,10,15,20,25,30,35,40,45,50].map((e) => InkWell(
                                                     onTap: (){
                                                       changeState((){
                                                         pointSelected=e;
                                                       });
                                                     },
                                                     child: Container(
                                                         margin: const EdgeInsets.symmetric(vertical: 06),
                                                         height: 30,
                                                       decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(10),
                                                         color:e==pointSelected?Theme.of(context).primaryColor: Theme.of(context).primaryColor.withOpacity(.5)
                                                       ),
                                                       child: Builder(builder: (_){
                                                        String text='$e% ${translator.discount}($e ${translator.points})';
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                                          child: Center(
                                                            child: Text(text,
                                                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                color: Colors.white
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                       }),
                                                     ),
                                                   )).toList(),
                                                 ),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    Navigator.of(context).pop();
                                                  }, child: Text(translator.cancel)),
                                                  TextButton(onPressed: ()async{
                                                    if(pointSelected==null){
                                                      showErrorToasts(translator.discount +' '+ translator.required);
                                                      return;
                                                    }
                                                
                                                    else if(pointSelected!>user.points){
                                                      showErrorToasts(translator.points +' '+ translator.userDontHaveEnoghPoints);
                                                      return;
                                                    }
                                                  
                                                   await FirebaseFirestore.instance.
                                                    collection(FirebaseCollections.POINT_COLLECTION)
                                                    .add({
                                                      'title':'매장에서 포인트를 할인받았습니다',
                                                      'userId':user.uid,
                                                      'point':-pointSelected!,
                                                      'createdAt':FieldValue.serverTimestamp(),
                                                    });
                                                    await FirebaseFirestore.instance.
                                                    collection(FirebaseCollections.POINT_COLLECTION)
                                                    .add({
                                                      'title':'할인을 통해 적립되는 포인트 ${user.namePlaceholder}',
                                                      'userId':shop.userId,
                                                      'point':pointSelected!,
                                                      'createdAt':FieldValue.serverTimestamp(),
                                                    });
                                                    showSuccessToast(translator.sucess);
                                                    Navigator.of(context).pop();
                                                  }, child: Text(translator.submit)),
                                                ],
                                             );
                                           }
                                         ));
                                      }
                                    },
                                   itemBuilder: (_)=>[['Send Notification','${translator.pushNotification}'],['Make Discount','${translator.doDiscount}']].map((e) => PopupMenuItem(child: Text(e.last),value: e.first,)).toList(),
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
              ),
            );
          }
        ),
      ],
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/dialog_helper.dart';
import 'package:massageapp/models/application_user.dart';
import 'package:massageapp/screens/user_point_screen.dart';
import 'package:massageapp/widgets/widgets.dart';

class SuperAdminUserScreen extends StatefulWidget {
  static const String routeName='/super_admin_user_screen';
  const SuperAdminUserScreen({ Key? key }) : super(key: key);

  @override
  State<SuperAdminUserScreen> createState() => _SuperAdminUserScreenState();
}

class _SuperAdminUserScreenState extends State<SuperAdminUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.all+' '+translator.users),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS).snapshots(),
        builder: (_,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!=null && snapshot.data!.docs.length>0){
               return Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('${translator.total} ',
                           style: Theme.of(context).textTheme.headline5,
                         ),
                         Text('${snapshot.data?.docs.length}',
                            style: Theme.of(context).textTheme.headline5,
                         )
                       ],
                     ),
                   ),
                   Expanded(
                     child: ListView.builder(
                       itemCount: snapshot.data?.docs.length,
                       
                        itemBuilder: (_,index){
                          final user=ApplicationUser.fromMap(snapshot.data!.docs[index].data());
                           return  Card(
                            
                             child: ListTile(
                               onTap: (){
                                 Navigator.of(context).pushNamed(UserPointScreen.routeName,arguments: user.uid);
                               },
                               subtitle: Text('${user.points} ${translator.points}'),
                               leading: Container(
                                 padding: const EdgeInsets.all(08),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle
                                  ),
                                 child: Text('${index+1}',
                                   style: TextStyle(
                                     color: Colors.white
                                   ),
                                 ),
                               ),
                                trailing: PopupMenuButton(
                                  onSelected: (e)async{
                                    if(e=='Remove'){
                                     final result=await  DialogHelper.showConfirmDialog(context, confirmMessage: translator.userDeleteConfirm);
                                     if(result==true){
                                      await FirebaseFirestore.instance.collection(FirebaseCollections.USER_COLLECTIONS).doc(user.uid).delete();
                                       showSuccessToast(translator.sucess);
                                     }
                                    }
                                  },
                                  itemBuilder: (_)=>[['Remove',translator.remove],].map((e) => PopupMenuItem(child: Text(e.last),value: e.first,)).toList(),
                                ),
                               contentPadding: const EdgeInsets.symmetric(horizontal: 03,vertical: 05),
                                title: Text(user.namePlaceholder),
                             ),
                           );
                        },
                     ),
                   ),
                 ],
               );
            }
          else{
          return NoRecord();
          }
          }
          return Loading();
        },
      ),
    );
  }
}
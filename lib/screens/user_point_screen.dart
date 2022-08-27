import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/point.dart';
import 'package:massageapp/widgets/scrollable_items_with_pagination.dart';
import 'package:massageapp/widgets/widgets.dart';

class UserPointScreen extends StatefulWidget {
  final String? userId;
  static const String routeName='/user_point_screen';
  const UserPointScreen({ Key? key ,required this.userId}) : super(key: key);

  @override
  State<UserPointScreen> createState() => _UserPointScreenState();
}

class _UserPointScreenState extends State<UserPointScreen> {
  late  String? userId;
  @override
  void initState() {
   
    super.initState();
    userId=FirebaseAuth.instance.currentUser?.uid;
  }
  @override
  Widget build(BuildContext context) {
    if(widget.userId!=null){
      userId=widget.userId;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userId==null? '${translator.my} ${translator.points}':'${translator.points}'),
      ),
      body:userId==null?SizedBox(): StreamBuilder(
         stream: FirebaseFirestore.instance.collection(FirebaseCollections.POINT_COLLECTION)
         .where('userId',isEqualTo: userId)
         .orderBy('createdAt',descending: true)
         .snapshots(),
         builder: (_,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
           if(snapshot.hasData && snapshot.data!=null){
             return  Column(
               children: [
                 Container(
                   height: 40,
                   padding: const EdgeInsets.symmetric(horizontal: 10),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('${translator.total} ',
                         style: Theme.of(context).textTheme.headline6,
                       ),
                       Builder(builder: (context){
                         int total=0;
                         for(var doc in snapshot.data!.docs){
                           total+=doc.data()['point']as int;
                         }
                         return Text('$total',
                          style: Theme.of(context).textTheme.headline6,
                         );
                       })
                     ],
                   ),
                 ),
                 const SizedBox(height: 10,),
                 Expanded(
                   child: ScrollableItemWithPagination<QueryDocumentSnapshot<Map<String, dynamic>>>(
                     onNewItemsDemanded: (){},
                     
                    itemBuilder: (doc,index){
                     final point=UserPoints.fromMap(doc.data());
                     return Card(
                       child: ListTile(
                         title: Text(point.title),
                         subtitle: Text(DateFormat('EEE, M/d/y').format(point.createdAt)),
                        leading: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: point.point>0?Colors.green:Colors.red,
                          ),
                          child: Center(
                            child: Text('${point.point}',
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                       ),
                     );
                    },
                     items: snapshot.data!.docs
                     ),
                 ),
               ],
             );
           }
           else  return Loading();
         },
      ),
    );
  }
}
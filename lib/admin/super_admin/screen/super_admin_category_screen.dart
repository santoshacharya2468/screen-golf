import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/admin/super_admin/screen/add_category_screen.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/models/shop_categories.dart';
import 'package:massageapp/widgets/widgets.dart';

class SuperAdminCategoryScreen extends StatefulWidget {
  static const String routeName='/super_admin_category_screen';
  const SuperAdminCategoryScreen({ Key? key }) : super(key: key);

  @override
  State<SuperAdminCategoryScreen> createState() => _SuperAdminViewScreenState();
}

class _SuperAdminViewScreenState extends State<SuperAdminCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).pushNamed(AddCategoryScreen.routeName);
        },
      ),
      appBar: AppBar(
         title: Text('All Category'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_CATEGORY).snapshots(),
         builder: (_,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
           if(snapshot.hasData){
             if(snapshot.data!=null && snapshot.data!.docs.length>0){
               return ListView.builder(
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (_,index){
                   final category=ShopCategory.fromMap(snapshot.data!.docs[index].data(), snapshot.data!.docs[index].id);
                   return Card(
                     child: ListTile(
                       onTap: (){
                          Navigator.of(context).pushNamed(AddCategoryScreen.routeName,arguments: category);
                       },
                       title:Text(category.name) ,
                       leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(category.iconUrl),
                       ),
                     ),
                   );
                 },
               );
             }
             return NoRecord();
           }
           return Loading();
         },

      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/dialog_helper.dart';
import 'package:massageapp/screens/screens.dart';

class AdminAppBar extends StatelessWidget  with PreferredSizeWidget{
  final String title;
  const AdminAppBar({ Key? key,required this.title }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(onPressed: ()async{
          final result=await DialogHelper.showConfirmDialog(context, confirmMessage: translator.logoutConfirm);
          if(result==null || result==false)return;
          final _auth=FirebaseAuth.instance;
         await _auth.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName, (route) => false);
        }, icon: Icon(Icons.lock))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
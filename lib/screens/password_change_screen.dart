import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/dialog_helper.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/widgets/widgets.dart';

class PasswordChangeScreen extends StatefulWidget {
  static const String routeName='/password_change_screen';
  const PasswordChangeScreen({ Key? key }) : super(key: key);

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey=GlobalKey<FormState>();
  final _currentPasswordController=TextEditingController();
  final _newPasswordController=TextEditingController();
  void _changePassword(String currentPassword, String newPassword) async {
final user =  FirebaseAuth.instance.currentUser;
final cred = EmailAuthProvider.credential(
    email: user!.email!, password: currentPassword);
try{

await    user.reauthenticateWithCredential(cred);
await user.updatePassword(newPassword);
showSuccessToast(translator.sucess);


}
 on FirebaseAuthException catch (e){
   showErrorToasts(e.message??translator.error);
 }
 catch(e){
   showErrorToasts(e.toString());
 }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.changePassword),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputSpacer(
                
                child: TextFormField(
                  controller: _currentPasswordController,
                   validator: InputValidators.validatePassword,
                decoration: InputDecoration(
                  label: Text('${translator.current} ${translator.password}')
                  ,
                ),
              )),
              InputSpacer(
                
                child: TextFormField(
                  controller: _newPasswordController,
                   validator: InputValidators.validatePassword,
                decoration: InputDecoration(
                  label: Text('${translator.newText} ${translator.password}')
                  ,
                ),
              )),
              InputButton(buttonText: translator.changePassword, onPressed: ()async{
                  if(_formKey.currentState!.validate()){
                    final submitted=await DialogHelper.showConfirmDialog(context, confirmMessage: translator.passwordChangeConfirm);
                    if(submitted==true){
                     _changePassword(_currentPasswordController.text, _newPasswordController.text);
                    }
                  }
              })
            ],
          )
        ),
      ),
    );
  }
}
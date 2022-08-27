import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName='/forgot_password_screen';

  const ForgotPasswordScreen({ Key? key }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey=GlobalKey<FormState>();
  final _emailController=TextEditingController();
  _sendResetLink(String email)async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSuccessToast(translator.passwordResetLinkSent);
    }
    on FirebaseAuthException catch(e) {
      showErrorToasts(e.message??translator.error);
    }
     }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.forgotPassword),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputSpacer(child: TextFormField(
                controller: _emailController,
                validator: InputValidators.validateEmail,
                 decoration: InputDecoration(
                   label: Text(translator.email)
                 ),
              )),


              InputButton(buttonText: translator.sendResetMail, onPressed: ()async{
                if(_formKey.currentState!.validate()){
                   _sendResetLink(_emailController.text);
                }
              })
            ],
          )
        ),
      ),
    );
  }
}
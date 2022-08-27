import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massageapp/controllers/auth_controller.dart';
import 'package:massageapp/screens/forgot_password_screen.dart';
import 'package:massageapp/screens/screens.dart';
import 'package:massageapp/screens/user_register_screen.dart';
import 'package:massageapp/widgets/password_field.dart';
import 'package:massageapp/widgets/widgets.dart';

import '../get_localization.dart';
import 'nav_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey=GlobalKey<FormState>();
  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  bool _isProcessing=false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Form(
        key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(translator.welcomeBack),
           InputSpacer(
             child: TextFormField(
               keyboardType: TextInputType.emailAddress,
               controller: _emailController,
               validator: (e){
                return GetUtils.isEmail(e??'')?null:e==null || e.isEmpty?translator.required:translator.invalidEmail;
               },
               decoration: InputDecoration(
                 labelText: translator.email,
               
               ),
             ),
           ),
           InputSpacer(
             child: PasswordField(
               controller: _passwordController,
               labelText: translator.password,
             ),
           ),
           Container(
             width: double.infinity,
             height: 65,
             child: InputSpacer(child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                  _isProcessing?Colors.grey:  Theme.of(context).primaryColor
                  )
                ),
               onPressed:_isProcessing?(){}: ()async{
                 if(_formKey.currentState!.validate()){
                  if(mounted) setState(() {
                     _isProcessing=true;
                   });
                 final result=await   Get.find<AuthController>().loginWithEmailAndPassword( 
                     email: _emailController.text,
                     password: _passwordController.text
                    );
                    if( result!=null && result.user!=null){
                  //   bool state=await  authController.hasShop(result.user!.uid);
                    // final routeName=state?NavigationScreen.routeName:ShopRegisteScreen.routeName;
                     
                       Navigator.of(context).pushNamedAndRemoveUntil(NavigationScreen.routeName, (route) => false);
                     
                    }
                  if(mounted)  setState(() {
                      _isProcessing=false;
                    });
                 }
                 
               },
               child: Text(translator.login),
             )),
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               InkWell(
                 onTap: (){
                   Navigator.of(context).pushNamed(ForgotPasswordScreen.routeName);
                 },
                 child: Padding(padding: const EdgeInsets.all(10),
                  child: Text(translator.forgotPassword,
                  
                   style: Theme.of(context).textTheme.button!.copyWith(
                     color: Colors.blue,
                     decoration: TextDecoration.underline
                   ),
                  ),
                 ),
               ),
             ],
           ),


           InputSpacer(child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
                OutlinedButton(
                 onPressed: (){
                   Navigator.of(context).pushNamed(UserRegisterScreen.routeName);
                 },
                 child: Text(translator.registerNewUser,
                 
                
                 style: Theme.of(context).textTheme.bodyText1!.copyWith(
                   color: Colors.blue,
                   
                 ),
                 ),
               ),
               OutlinedButton(
                 onPressed: (){
                   Navigator.of(context).pushNamed(ShopRegisteScreen.routeName);
                 },
                 child: Text(translator.registerNewShop,
                 
                
                 style: Theme.of(context).textTheme.bodyText1!.copyWith(
                   color: Colors.blue,
                   
                 ),
                 ),
               )
             ],
           )),
           
          
        ],
      )),
    );
  }
}

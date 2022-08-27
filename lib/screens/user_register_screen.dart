import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/widgets/password_field.dart';
import 'package:massageapp/widgets/widgets.dart';

import 'nav_screen.dart';

class UserRegisterScreen extends StatefulWidget {
  static const String routeName='/user_register';
  const UserRegisterScreen({ Key? key }) : super(key: key);

  @override
  _UserRegisterScreenState createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  final _nameController=TextEditingController();
  final  _formKey=GlobalKey<FormState>();
  bool _processing=false;
  //Position? position;
  @override
  void initState() {
    super.initState();
    _getLocation();
  }
_getLocation()async{
 // position=await   getCurrentLocation();
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translator.registerNewUser),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                      InputSpacer(
                        child:TextFormField(
                          controller:_nameController,
                          validator: InputValidators.validateName,
                          decoration: InputDecoration(
                            label: Text(translator.fullName)
                          ),
                      )),
                       InputSpacer(
                        child:TextFormField(
                          controller:_emailController,
                          validator: InputValidators.validateEmail,
                          decoration: InputDecoration(
                            label: Text(translator.email)
                          ),
                      )),
                       InputSpacer(
                        child:PasswordField(
                          controller:_passwordController,
                          labelText: translator.password,
                          validator: InputValidators.validatePassword,
                      )),
                      InputButton(
                         state:! _processing,
                        buttonText: translator.register, onPressed: ()async{
                        if(_formKey.currentState!.validate()){
                         if(mounted) setState(() {
                            _processing=true;
                          });
                          final result=await Get.find<AuthController>()
                          .registerWithEmailAndPassword(email: _emailController.text, password: _passwordController.text,name: _nameController.text);
                          if(mounted)setState(() {
                            _processing=false;
                          });
                          if(result!=null){
                           
                            Navigator.of(context).pushNamedAndRemoveUntil(NavigationScreen.routeName, (route) => false);
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        ),
    );
  }
}
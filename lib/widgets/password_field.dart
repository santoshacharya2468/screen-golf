import 'package:flutter/material.dart';
import 'package:massageapp/helper/input_validator.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String ? Function(String?)? validator;
  const PasswordField({ Key? key,required this.controller,required this.labelText,this.validator }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword=false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_showPassword,
      validator:widget.validator?? InputValidators.validatePassword,
      decoration: InputDecoration(
        label: Text(widget.labelText),
        suffixIcon: GestureDetector(
          onTap: (){
            setState(() {
              _showPassword=!_showPassword;
            });
          },
          child: Icon(
           ! _showPassword?Icons.visibility:Icons.visibility_off
          ),
        )
      ),
      
    );
  }
}
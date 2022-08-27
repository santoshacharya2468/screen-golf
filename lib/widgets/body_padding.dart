import 'package:flutter/material.dart';

class BodyPadding extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;
  const BodyPadding({ Key? key,this.padding= const  EdgeInsets.symmetric(horizontal:03,vertical: 01),required this.child }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
      
    );
  }
}
import 'package:flutter/material.dart';

class InputSpacer extends StatelessWidget {
  final Widget child;
  const InputSpacer({ Key? key,required this.child }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}
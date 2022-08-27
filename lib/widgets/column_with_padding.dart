import 'package:flutter/material.dart';

class ColumnWithPadding extends StatelessWidget {
  final EdgeInsets padding;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  const ColumnWithPadding({ Key? key ,required this.padding,required this.children,
  this.crossAxisAlignment=CrossAxisAlignment.start,this.mainAxisAlignment=MainAxisAlignment.start
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      children: children.map((e) => Padding(padding: padding,child: e,)).toList(),
    );
  }
}
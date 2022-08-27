import 'package:flutter/material.dart';
import 'package:massageapp/get_localization.dart';

class NoRecord extends StatelessWidget {
  final String? text;
  const NoRecord({ Key? key,this.text }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text??translator.noRecords
      ),
    );
  }
}
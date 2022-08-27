import 'package:flutter/material.dart';
import 'package:massageapp/get_localization.dart';

class NoRecords extends StatelessWidget {
  const NoRecords({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(translator.noRecords),
      
    );
  }
}
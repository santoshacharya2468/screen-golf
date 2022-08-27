import 'package:flutter/material.dart';

class LoadingMoreIcon extends StatelessWidget {
  const LoadingMoreIcon({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 30,
      width: 30,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
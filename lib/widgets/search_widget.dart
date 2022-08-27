import 'package:flutter/material.dart';
import 'package:massageapp/screens/screens.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showSearch(context: context, delegate: SearchScreen());
        },
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ));
  }
}

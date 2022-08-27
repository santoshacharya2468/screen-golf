
import 'package:flutter/material.dart';
import 'package:massageapp/admin/widgets/visit_graph.dart';

class AdminVisitScreen extends StatelessWidget {
  const AdminVisitScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          VisitGraph(),
          BookMarkGraph(),
        ],
      ),
      
    );
  }
}

import 'package:flutter/material.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/widgets/app_bar.dart';

///usedful fo r work gallery images view
class PhotoView extends StatelessWidget {
  static const String routeName='/photo_view';
  final WorkGallery workGallery;
  const PhotoView({ Key? key,required this.workGallery, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        null,
        title: Text(translator.image),
      ),
      body: Center(child: Image.network(
        workGallery.imageUrl,
        // loadingBuilder: (_,a,c)=>Loading(),
      )),
      
    );
  }
}
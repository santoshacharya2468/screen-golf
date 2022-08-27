import 'package:flutter/material.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/screens/screens.dart';
import 'package:massageapp/widgets/widgets.dart';

class WorkGalleryView extends StatefulWidget {
  final Shop shop;
  final List<WorkGallery>? workGallery;
  const WorkGalleryView({Key? key, required this.shop, this.workGallery})
      : super(key: key);

  @override
  _WorkGalleryViewState createState() => _WorkGalleryViewState();
}

class _WorkGalleryViewState extends State<WorkGalleryView> {
  @override
  Widget build(BuildContext context) {
    if (widget.workGallery == null)
      return Loading();
    else if (widget.workGallery?.length == 0) return SizedBox();
    return ListView.builder(
        itemCount: widget.workGallery?.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          final gallery = widget.workGallery![index];
          return Container(
            height: 100,
            width: 100,
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(PhotoView.routeName, arguments: gallery);
              },
              child: Card(
                elevation: 0.0,
                child: Image.network(
                  gallery.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }
}

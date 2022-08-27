import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/widgets/input_spacer.dart';

class StackedImageHeader extends StatelessWidget {
  final Shop shopInfo;
  const StackedImageHeader({Key? key, required this.shopInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CachedNetworkImage(
            imageUrl:
                shopInfo.images.first,
            height: size.height * 0.25,
            fit: BoxFit.cover,
            width: double.infinity),
        InputSpacer(
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("Lorem", style: TextStyle(color: Colors.white)),
              )),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          child: InputSpacer(
            child: Row(children: [
              Icon(Icons.star, color: Colors.yellow),
              Text(
                "4.0 (75)",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.white),
              )
            ]),
          ),
        )
      ],
    );
  }
}

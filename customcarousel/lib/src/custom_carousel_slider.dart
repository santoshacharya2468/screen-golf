import 'package:flutter/material.dart';

class CustomCarouselSlider extends StatefulWidget {
  final double width;
  final double height;
  final List<Widget> child;
  const CustomCarouselSlider(
      {Key? key,
      required this.width,
      required this.height,
      required this.child})
      : super(key: key);

  @override
  _CustomCarouselSliderState createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // height: widget.height,
        width: widget.width,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics:const PageScrollPhysics(),
          children: widget.child,
        ));
  }
}

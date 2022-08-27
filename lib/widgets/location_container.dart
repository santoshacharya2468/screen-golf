import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'input_spacer.dart';

class LocationContainer extends StatefulWidget {
  final IconData icon;
  final String text;

  const LocationContainer({Key? key, required this.text, required this.icon})
      : super(key: key);

  @override
  _LocationContainerState createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Expanded(
      child: InputSpacer(
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 5),
          height: 40,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          // width: size.width * 0.3,

          child: Row(
            children: [
              InputSpacer(
                child: FaIcon(
                  widget.icon,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                  child: Text(
                widget.text,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ))
            ],
          ),
        ),
      ),
    );
  }
}

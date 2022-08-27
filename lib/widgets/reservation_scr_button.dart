import 'package:flutter/material.dart';

import 'input_spacer.dart';

class ReservationScreenButton extends StatelessWidget {
  final Function() onTap;
  final Color buttonColor;
  final String title;

  const ReservationScreenButton(
      {Key? key,
      required this.onTap,
      required this.buttonColor,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputSpacer(
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: InputSpacer(
              child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Colors.white),
          )),
          decoration: BoxDecoration(
              color: Colors.blue[500], borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}

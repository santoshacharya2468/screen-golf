import 'package:flutter/material.dart';
import 'package:massageapp/widgets/widgets.dart';

class InputButton extends StatelessWidget {
  final String buttonText;
  ///enable or not by default state==[true]
  final bool state;
  final void Function() onPressed;
  InputButton({Key? key, required this.buttonText, required this.onPressed,this.state=true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 65,
      child: InputSpacer(
          child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(
                state?  Theme.of(context).primaryColor:Colors.grey[350]
                  )
                ),
        onPressed: state?onPressed:(){},
        child: Text(buttonText),
      )),
    );
  }
}

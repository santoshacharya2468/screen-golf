import 'package:flutter/material.dart';
import 'package:massageapp/get_localization.dart';

class DialogHelper {
  static showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Container(
              color: Colors.transparent,
              child: Container(
                height: 150,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ));
  }

  static hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static showConfirmDialog(BuildContext context,
      {required String confirmMessage,
      String? headMessage,
      Color okButtonColor = Colors.red}) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                headMessage??translator.confirm,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              content: Text(
                confirmMessage,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              actions: [
                OutlinedButton(
                  child: Text(
                    translator.cancel,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                OutlinedButton(
                  child: Text(
                   translator.yes,
                    style: TextStyle(
                      color: okButtonColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ));
  }
}

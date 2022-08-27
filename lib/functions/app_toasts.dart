import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showErrorToasts(String toastMessage) {
  return Fluttertoast.showToast(
    msg: toastMessage,
    backgroundColor: Colors.red,
  );
}

showInfoToast(String toastMessage) {
  return Fluttertoast.showToast(
    msg: toastMessage,
    backgroundColor: Colors.blue,
  );
}

showSuccessToast(String toastMessage) {
  return Fluttertoast.showToast(
    msg: toastMessage,
    backgroundColor: Colors.green,
  );
}

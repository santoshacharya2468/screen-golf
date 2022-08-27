import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

uploadAndGetUrl(String filePath, Reference ref,
    {bool showSnack = false, String? title, String? body}) async {
  String name = '${DateTime.now().toString()}' + filePath.split('/').last;
  if (showSnack) {}
  var uploadTaskFront = ref.child(name).putFile(File(filePath));
  return await uploadTaskFront.then((f) async {
    var downloadPath = await f.ref.getDownloadURL();
    return downloadPath;
  });
}

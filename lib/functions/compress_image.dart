import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pf;

Future<File> compressAndGetFile(File file, {int quality = 60}) async {
  final dir = await pf.getApplicationDocumentsDirectory();
  final targetPath = dir.path + path.extension(file.path);
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: quality,
  );

  return result ?? file;
}

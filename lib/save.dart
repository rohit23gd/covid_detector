import 'dart:io';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

Future<String> save_img(Image img1) async {
  final extDir = await getExternalStorageDirectory();
  print(extDir);
  String p = '${extDir!.path}/new_image.png';
  print(p);
  File file = await File(p).create(recursive: true);
  file.writeAsBytesSync(encodePng(img1));
  return p;
}

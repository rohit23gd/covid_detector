import 'dart:io';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

Future<String> save_img(Image img1) async {
  // final tempPath = await getTemporaryDirectory();
  // String p = tempPath.path;
  String p = await getFilePath();
  print(p);
  p = p + '/new_image.png';
  print(p);
  File file = File(p);
  file.writeAsBytesSync(encodePng(img1));
  return p;
}

Future<String> getFilePath() async {
  Directory appDocumentsDirectory =
      await getApplicationDocumentsDirectory(); // 1

  return appDocumentsDirectory.path;
}

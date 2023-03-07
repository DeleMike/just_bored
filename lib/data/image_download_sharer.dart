import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../configs/debug_fns.dart';

/// downloads images and help to share them to socials
class ImageDownloaderSharer {
 
  /// downloads images and help to share them to socials
  ImageDownloaderSharer();

  /// Download image then save to temp directory
  Future<File?> downloadImage(String url, String fileName) async {
    printOut('Url = $url, filename = $fileName ', 'ImageDownloaderSharer');
    File? file;
    try {
      // download file
      final http.Response response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      // save temporarily to file directory
      final appDir = await getTemporaryDirectory();
      final imageFile = File('${appDir.path}/$fileName');
      file = await imageFile.writeAsBytes(bytes);
    } catch (e, s) {
      printOut('An error occured while downloading file: $e, $s');
    }
    return file;
  }
}

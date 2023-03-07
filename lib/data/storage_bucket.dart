import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import '../configs/debug_fns.dart';

/// Storage Bucket maintains all functions about FirebaseStorage
class StorageBucketUploader {
  StorageBucketUploader._();

  static final _instance = StorageBucketUploader._();
  static StorageBucketUploader get instance => _instance;

  final storageRef = FirebaseStorage.instance.ref();

  /// upload user favourite picture to the cloud
  Future<String> uploadFavoritePicture(String filePath, String fileName) async {
    String downloadUrl = '';
    // get image bytes to simulate image resource download
    try {
      final http.Response response = await http.get(Uri.parse(filePath));
      final bytes = response.bodyBytes;

      // upload to firebase storage with filename
      final time = DateTime.now();
      String imgFileName =
          '${fileName.toLowerCase().trim().replaceAll(' ', '_')}_${time.toString().trim().replaceAll(' ', '_').replaceAll('-', '_')}';

      final UploadTask uploadTask = storageRef.child('favorites_images/$imgFileName').putData(bytes);

      // uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      // }); --- we can listen for app progress

      final TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() => null);

      downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e, s) {
      printOut('Error uploading image: $e, $s');
    }
    return downloadUrl;
  }

  Future<void> deleteFavouritePicture(String name) async {
    try {
      // Create a reference to the file to delete
      final imageRef = storageRef.child("images/$name");

      // Delete the file
      await imageRef.delete();
    } on FirebaseException catch (e, s) {
      printOut('Error deleting image: $e, $s');
    }
  }
}

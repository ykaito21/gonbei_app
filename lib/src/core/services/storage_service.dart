import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();
  final _storage = FirebaseStorage.instance;
  // factory StorageService() => instance;

  Future<String> uploadFile({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    try {
      print('uploading to: $path');
      final StorageUploadTask uploadTask = _storage
          .ref()
          .child(path)
          .putFile(file, StorageMetadata(contentType: contentType));
      final StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      if (snapshot.error != null) {
        //TODO maybe need show each case
        //https://qiita.com/kwmt@github/items/2e81b46d62beb091d18b
        print('upload error code: ${snapshot.error}');
        throw snapshot.error;
      }
      // url used to download file/image
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('downloadUrl: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteFile(String url) async {
    try {
      final StorageReference res = await _storage.getReferenceFromUrl(url);
      res.delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // compress image
  // Future<File> compressImage(
  //     {@required String photoId, @required File image}) async {
  //   try {
  //     final Directory tempDir = await getTemporaryDirectory();
  //     final path = tempDir.path;
  //     File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
  //       image.absolute.path,
  //       '$path/img_$photoId.jpg',
  //       quality: 70,
  //     );
  //     return compressedImageFile;
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
// }
//* could be important to check not same pic is compressed?
//https://www.youtube.com/watch?v=G5lDugVd8n0&t=622s
// static Future<String> uploadUserProfileImage(
//* need to provider current user imageUrl
//     String url, File imageFile) async {
//   String photoId = Uuid().v4();
//   File image = await compressImage(photoId, imageFile);

//   if (url.isNotEmpty) {
//     // Updating user profile image
//     RegExp exp = RegExp(r'userProfile_(.*).jpg');
//     photoId = exp.firstMatch(url)[1];
//   }

//   StorageUploadTask uploadTask = storageRef
//       .child('images/users/userProfile_$photoId.jpg')
//       .putFile(image);
//   StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
//   String downloadUrl = await storageSnap.ref.getDownloadURL();
//   return downloadUrl;
// }

// static Future<File> compressImage(String photoId, File image) async {
//   final tempDir = await getTemporaryDirectory();
//   final path = tempDir.path;
//   File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
//     image.absolute.path,
//     '$path/img_$photoId.jpg',
//     quality: 70,
//   );
//   return compressedImageFile;
// }
}

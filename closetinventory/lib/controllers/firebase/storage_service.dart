import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:closetinventory/controllers/firebase/database_service.dart';

class FirebaseStorageService {
  final FirebaseStorage _storageService = FirebaseStorage.instance;
  final FirebaseDataServices _dataServices = FirebaseDataServices();

  FirebaseStorage getStorage() {
    return _storageService;
  }

  Future<String?> uploadItemPhoto(XFile photo, String userId, String itemId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final String fileName = '${itemId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storageService.ref().child('item_photos/$userId/$fileName');
      
      final imageBytes = await photo.readAsBytes();
      
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        cacheControl: 'public, max-age=3600',
        customMetadata: kIsWeb ? {
          'platform': 'web',
          'uploaded_by': 'flutter_web_app',
        } : {
          'platform': 'mobile',
          'uploaded_by': 'flutter_mobile_app',
        },
      );
      
      final UploadTask uploadTask = ref.putData(imageBytes, metadata);
      final TaskSnapshot snapshot = await uploadTask;
      
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      if (kIsWeb) {
        final uri = Uri.parse(downloadUrl);
        downloadUrl = uri.replace(
          queryParameters: {
            ...uri.queryParameters,
            'alt': 'media',
          },
        ).toString();
      }
      
      _dataServices.createLogTransaction("UPLOAD_ITEM_PHOTO", true, userId, 'Photo uploaded successfully');
      return downloadUrl;
      
    } catch (e) {
      _dataServices.createLogTransaction("UPLOAD_ITEM_PHOTO", false, userId, 'Error: ${e.toString()}');
      return null;
    }
  }

  Future<void> deleteItemPhoto(String photoUrl, String userId) async {
    try {
      final Reference ref = _storageService.refFromURL(photoUrl);
      await ref.delete();
      _dataServices.createLogTransaction("DELETE_ITEM_PHOTO", true, userId, 'Photo deleted');
    } catch (e) {
      _dataServices.createLogTransaction("DELETE_ITEM_PHOTO", false, userId, 'Error: ${e.toString()}');
    }
  }

  Future<Uint8List?> getFile(String uid, String fileName) async {
    try {
      final imageRef = _storageService.ref().child('$uid/$fileName');
      _dataServices.createLogTransaction("ERRORMESSAGE_GETFILE", true, uid, '');
      return imageRef.getData();
    } catch (e) {
      _dataServices.createLogTransaction(
        "ERRORMESSAGE_GETFILE",
        false,
        uid,
        'Error occurred getting file. - ${e.toString()}',
      );
    }
    return null;
  }

  Future<void> uploadFile(String uid, String fileName, XFile file) async {
    try {
      final imageRef = _storageService.ref().child('$uid/$fileName');
      final imageBytes = await file.readAsBytes();
      await imageRef.putData(imageBytes);
      _dataServices.createLogTransaction(
        "ERRORMESSAGE_UPLOADFILE",
        true,
        uid,
        '',
      );
    } catch (e) {
      _dataServices.createLogTransaction(
        "ERRORMESSAGE_UPLOADFILE",
        false,
        uid,
        'Error occurred uploading file. - ${e.toString()}',
      );
    }
  }

  Future<void> deleteFile(String uid, String fileName) async {
    try {
      final imageRef = _storageService.ref().child('$uid/$fileName');
      await imageRef.delete();
      _dataServices.createLogTransaction(
        "ERRORMESSAGE_DELETEFILE",
        true,
        uid,
        '',
      );
    } catch (e) {
      _dataServices.createLogTransaction(
        "ERRORMESSAGE_DELETEFILE",
        false,
        uid,
        'Error occurred deleting file. - ${e.toString()}',
      );
    }
  }
}
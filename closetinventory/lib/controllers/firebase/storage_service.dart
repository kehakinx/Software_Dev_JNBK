import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:closetinventory/controllers/firebase/database_service.dart';

class FirebaseStorageService {
  final FirebaseStorage _storageService = FirebaseStorage.instance;
  final FirebaseDataServices _dataServices = FirebaseDataServices();

  FirebaseStorage getStorage() {
    return _storageService;
  }

  // CREATE FUNCTION

  // READ FUNCTION
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

  // UPDATE FUNCTION
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

  // DELETE FUNCTION
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:closetinventory/models/outfit_dataobj.dart';
import 'package:closetinventory/models/user_dataobj.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';

class FirebaseDataServices {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  FirebaseFirestore getFirestore() {
    return _fireStore;
  }

  // CREATE FUNCTIONS
  Future<DocumentReference<Map<String, dynamic>>> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _fireStore.collection(collection).add(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating document: $e');
      }
      rethrow;
    }
  }

  Future<void> createDocumentWithId(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _fireStore.collection(collection).doc(documentId).set(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating document with ID: $e');
      }
      rethrow;
    }
  }

  Future<void> createUser(USER user) async {
    try {
      await createDocumentWithId(CONSTANTS.usersCollection, user.userId, user.toJson());
      createLogTransaction("CREATE_USER", true, user.userId, '');
    } catch (e) {
      createLogTransaction("CREATE_USER", false, user.userId, e.toString());
      rethrow;
    }
  }

  Future<void> createOutfit(Outfit outfit) async {
    try {
      await createDocument(CONSTANTS.outfitsCollection, outfit.toJson());
      createLogTransaction("CREATE_OUTFIT", true, outfit.outfitId, '');
    } catch (e) {
      createLogTransaction("CREATE_OUTFIT", false, outfit.outfitId, e.toString());
      rethrow;
    }
  }

  Future<void> createLogTransaction(
    String transactionType,
    bool blSuccess,
    String recordid,
    String errorMsg,
  ) async {
    try {
      Map<String, dynamic> data = {
        'tranxType': transactionType,
        'tranxWasSuccessful': blSuccess,
        'tranxForID': recordid,
        'tranxErrorMsg': errorMsg,
        'tranxDateTime': Timestamp.now(),
      };
      await createDocument("logTrx", data);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating transaction log. - ${e.toString()}');
      }
    }
  }

  // READ FUNCTIONS
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collection,
    String documentId,
  ) async {
    try {
      return await _fireStore.collection(collection).doc(documentId).get();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting document: $e');
      }
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String collection,
  ) async {
    try {
      return await _fireStore.collection(collection).get();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting collection: $e');
      }
      rethrow;
    }
  }

  // UPDATE FUNCTIONS

  // DELETE FUNCTIONS
}
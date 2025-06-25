import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseDataServices {
  // Add your Firebase database service methods here
  // For example, methods to read/write data to Firestore or Realtime Database
  // This is a placeholder for the actual implementation

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

import 'dart:async';

import 'package:closetinventory/models/item_dataobj.dart';
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
      DocumentReference<Map<String, dynamic>> doc = await _fireStore.collection(collection).add(data);
      if(collection != 'logTrx'){
        createLogTransaction("CREATING $collection", true, doc.id, '');
      }
      switch(collection){
        case CONSTANTS.itemsCollection:
          await doc.update({'itemId': doc.id});
        case CONSTANTS.outfitsCollection:
          await doc.update({'outfitId': doc.id});
        default:
         break;
      }
       return doc;
    } catch (e) {
      if(collection != 'logTrx'){
        createLogTransaction("CREATING $collection", false, '', e.toString());
      }
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

  Future<void> createItem(Item item) async{
    try {
      await createDocument(CONSTANTS.itemsCollection, item.toJson());
      createLogTransaction("CREATE_ITEM", true, item.itemId, '');
    } catch (e) {
      createLogTransaction("CREATE_ITEM", false, item.itemId, e.toString());
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
  Future<DocumentSnapshot> getDocument(
    String collection,
    String documentId,
  ) async {
    try {
      DocumentSnapshot dsResults = await _fireStore.collection(collection).doc(documentId).get();
      createLogTransaction("GETTING DOCUMENT FOR: $collection", true, documentId, '');
      return dsResults;
    } catch (e) {
      createLogTransaction("GETTING DOCUMENT FOR: $collection", false, documentId, e.toString());
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

  Future<USER?> getUserData(String userId) async{
    try{
      DocumentSnapshot userDoc = await getDocument(CONSTANTS.usersCollection,userId,);
      if (userDoc.exists) {
          USER user = USER.fromJson(userDoc.data() as Map<String, dynamic>);
          createLogTransaction("GETTING USER DATA",true,userId,'',);
          return user;
      }
    }catch(e){
      createLogTransaction("GETTING USER DATA",false,userId,e.toString(),);
    }
    return null;
  }

  Future<List<Item>> getAllClosetItemsForUser(String userId) async{
    List<Item> closetItems = [];
    try{
      QuerySnapshot closetItemsSnapShot = await _fireStore.collection(CONSTANTS.itemsCollection).where('userId', isEqualTo: userId).get();
      if(closetItemsSnapShot.size > 0){
        final allData = closetItemsSnapShot.docs.map((doc) => doc.data()).toList();
        for(Object? obj in allData){
          closetItems.add(Item.fromJson(obj as Map<String, dynamic>));
        }
        createLogTransaction("GETTING CLOSET ITEM DATA",true,userId,'',);
        return closetItems;
      }else{
        createLogTransaction("GETTING CLOSET ITEM DATA",true,userId,'No Records Found!',);
        return closetItems;
      }
   }catch(e){
      createLogTransaction("GETTING CLOSET ITEM DATA",false,userId,e.toString(),);
    }
    return closetItems;
  }

  // UPDATE FUNCTIONS
  Future<void> updateDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    try {
      switch(collection){
        case CONSTANTS.itemsCollection:
          await _fireStore.collection(collection).doc(data['itemId']).update(data);
          createLogTransaction("UPDATING $collection", true, data['itemId'], '');
        default:
          break;
      }
    }catch(e){
      createLogTransaction("UPDATING $collection", false, data['itemId'], e.toString());
    }
  }

  Future<void> updateItem(Item editItem) async {
    try{
      updateDocument(CONSTANTS.itemsCollection, editItem.toJson());
      createLogTransaction("UPDATE ${CONSTANTS.itemsCollection}", true, editItem.itemId, '');
    }catch(e){
      createLogTransaction("UPDATE ${CONSTANTS.itemsCollection}", false, editItem.itemId, e.toString());
    }
  }

  // DELETE FUNCTIONS
}
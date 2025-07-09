import 'package:closetinventory/controllers/firebase/database_service.dart';
import 'package:closetinventory/models/user_dataobj.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDataServices _dataServices = FirebaseDataServices();

  FirebaseAuth getAuth() {
    return _auth;
  }

  FirebaseDataServices getDataServices() {
    return _dataServices;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  bool isUserLoggedIn() {
    User? user = _auth.currentUser;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<USER?> registerWithEmailPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = result.user;
      if (firebaseUser != null) {
        final newUser = USER(
          userId: firebaseUser.uid,
          email: email,
          displayName: displayName,
          createdDate: Timestamp.now(),
        );

        await _dataServices.createUser(newUser);

        CONSTANTS.mockUsers.add(newUser);

        _dataServices.createLogTransaction(
          "REGISTER_USER",
          true,
          firebaseUser.uid,
          '',
        );
        return newUser;
      }
      return null;
    } catch (e) {
      _dataServices.createLogTransaction(
        "REGISTER_USER",
        false,
        '',
        e.toString(),
      );
      rethrow;
    }
  }

  Future<USER?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = result.user;
      if(firebaseUser != null){
         _dataServices.createLogTransaction("LOGIN_USER",true,firebaseUser.uid, '',);

        USER? user = await _dataServices.getUserData(firebaseUser.uid);
        if(user != null){
          _dataServices.createLogTransaction("GET USER DATA", true, user.userId, '');
          return user;
        }else{
          _dataServices.createLogTransaction("GET USER DATA", false, '', 'User data was null!');
          return null;
        }
      }
      else {
        _dataServices.createLogTransaction("GET USER DATA", false, '', 'No User data found!');
        return null;
      }
    }catch (e) {
      _dataServices.createLogTransaction("LOGIN_USER", false, '', e.toString());
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}

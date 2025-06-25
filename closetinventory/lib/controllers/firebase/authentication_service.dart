import 'package:closetinventory/controllers/firebase/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDataServices _dataServices = FirebaseDataServices();

  FirebaseAuth getAuth() {
    return _auth;
  }

  FirebaseDataServices getDataServices() {
    return _dataServices;
  }

  bool isUserLoggedIn() {
    User? user = _auth.currentUser;
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }
}

import 'dart:async';

import 'package:closetinventory/controllers/firebase/authentication_service.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseAuthServices _firebaseAuth = FirebaseAuthServices();

  @override
  void initState() {
    MyPreferences.init();
    _isPreferenceExist();
    Timer(const Duration(seconds: 5), () {
      _isSignedIn();
    });
    super.initState();
  }

  void _isSignedIn() async {
    if (_firebaseAuth.isUserLoggedIn()) {
      if (MyPreferences.getHasOnboarded()) {  
        context.goNamed(CONSTANTS.homePage);
      } else {
        context.goNamed(CONSTANTS.onboardingPage);
      }
    } else {
      context.goNamed(CONSTANTS.loginPage);
    }
  }

  void _isPreferenceExist() async{
    final userId = MyPreferences.getString('prefUserKey');
    if(userId.isNotEmpty){
      _firebaseAuth.getCurrentUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    double pageHeight = MediaQuery.sizeOf(context).height;
    double pageWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Container(
        height: pageHeight,
        width: pageWidth,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(CONSTANTS.appName),
            Image.asset(
              CONSTANTS.appLogo,
              fit: BoxFit.fill),
          ],
        ),
      ),
    );
  }
}

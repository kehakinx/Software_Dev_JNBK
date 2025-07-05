import 'dart:async';

import 'package:closetinventory/controllers/firebase/authentication_service.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/models/user_dataobj.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseAuthServices _firebaseAuth = FirebaseAuthServices();
  late USER _user;

  @override
  void initState() {
    MyPreferences.init();

    Timer(const Duration(seconds: 5), () {
      _isSignedIn();
    });
    super.initState();
  }

  void _isSignedIn() async {
    /*if (_firebaseAuth.isUserLoggedIn()) {
      if (MyPreferences.getHasOnboarded()) {
        */
    _user = CONSTANTS.mockUsers.firstWhere((user) => user.userId == 'user789');
    MyPreferences.setString('prefUserKey', _user.userId);
       
    context.goNamed(CONSTANTS.homePage);
    /* } else {
        context.goNamed(CONSTANTS.onboardingPage);
      }
    } else {
      context.goNamed(CONSTANTS.loginPage);
    }*/
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
            Text(CONSTANTS.appName),
            //Image.asset("assets/logo/${Constants.APP_LOGO}", scale: 5,),
          ],
        ),
      ),
    );
  }
}

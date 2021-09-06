// @dart=2.9
import 'package:driver/assets/AppColors.dart';
import 'package:driver/pages/MainPage.dart';
import 'package:driver/pages/Splash.dart';
import 'package:driver/pages/account/FirstPage.dart';
import 'package:driver/pages/account/InputPhoneNumberPage.dart';
import 'package:driver/pages/account/PhoneOTPPage.dart';
import 'package:driver/pages/account/RegisterUserDetailPage.dart';
import 'package:driver/pages/account/SubmitDriverLicensePage.dart';
import 'package:driver/pages/account/VerificationStatusPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.green
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new SplashPage(),
      routes:  <String, WidgetBuilder> {
        '/SplashPage' : (BuildContext context) => new SplashPage(),
        '/FirstPage' : (BuildContext context) => new FirstPage(),
        '/InputPhoneNumberPage' : (BuildContext context) => new InputPhoneNumberPage(),
        '/PhoneOTPPage' : (BuildContext context) => new PhoneOTPPage(),
        '/RegisterUserDetailPage' : (BuildContext context) => new RegisterUserDetailPage(''),
        '/MainPage' : (BuildContext context) => MainPage(),
        '/VerificationStatusPage' : (BuildContext context) => VerificationStatusPage(),
        '/SubmitDriverLicensePage' : (BuildContext context) => SubmitDriverLicensePage(),
      },
    );
  }
}
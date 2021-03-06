// @dart=2.9
import 'package:driver/assets/AppColors.dart';
import 'package:driver/pages/Job/MyJobPage.dart';
import 'package:driver/pages/temp/SignaturePanel.dart';
import 'package:driver/pages/MainPage.dart';
import 'package:driver/pages/Splash.dart';
import 'package:driver/pages/account/PhoneOTPPage.dart';
import 'package:driver/pages/account/RegisterUserDetailPage.dart';
import 'package:driver/pages/account/SubmitDriverLicensePage.dart';
import 'package:driver/pages/account/SubmitSealinkCardPage.dart';
import 'package:driver/pages/account/SubmitTwicCardPage.dart';
import 'package:driver/service/FCMService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.darkBlue
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
    FCMService().init();
  }

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      theme: ThemeData(fontFamily: 'RobotoCondensed'),
      debugShowCheckedModeBanner: false,
      home: new SplashPage(),
      routes:  <String, WidgetBuilder> {
        '/PhoneOTPPage' : (BuildContext context) => new PhoneOTPPage(),
        '/RegisterUserDetailPage' : (BuildContext context) => new RegisterUserDetailPage(''),
        '/MainPage' : (BuildContext context) => MainPage(),
        '/SubmitDriverLicensePage' : (BuildContext context) => SubmitDriverLicensePage(),
        '/SubmitTwicCardPage' : (BuildContext context) => SubmitTwicCardPage(),
        '/SubmitSealinkCardPage' : (BuildContext context) => SubmitSealinkCardPage(),
        '/SignaturePanel' : (BuildContext context) => SignaturePanel(),
      },
    );
  }
}
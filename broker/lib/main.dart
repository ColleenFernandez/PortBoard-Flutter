// @dart=2.9
import 'dart:async';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/API.dart';
import 'package:driver/pages/MainPage.dart';
import 'package:driver/pages/Splash.dart';
import 'package:driver/pages/TempPage.dart';
import 'package:driver/pages/account/FirstPage.dart';
import 'package:driver/pages/account/InputPhoneNumberPage.dart';
import 'package:driver/pages/account/PhoneOTPPage.dart';
import 'package:driver/pages/account/RegisterUserDetailPage.dart';
import 'package:driver/pages/post_job/FirstStepPage.dart';
import 'package:driver/pages/post_job/SelectContainerTypePage.dart';
import 'package:driver/pages/post_job/SelectGoodsPage.dart';
import 'package:driver/pages/post_job/SelectLoadDescriptionPage.dart';
import 'package:driver/pages/post_job/SelectPortLoadingPage.dart';
import 'package:driver/pages/post_job/SelectPortTerminalPage.dart';
import 'package:driver/pages/post_job/SelectStreamShipLinePage.dart';
import 'package:driver/pages/post_job/SelectVesselPage.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/Common.dart';

void main() {
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
    await Firebase.initializeApp().then((value) {
      LogUtils.log('Firebase Init Succeed');
    });
  }

  @override
  void initState() {
    super.initState();
    initFirebase();

    Common.api = new API();
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      theme: ThemeData(fontFamily: 'RobotoCondensed'),
      debugShowCheckedModeBanner: false,
      home:  SplashPage(),
      routes:  <String, WidgetBuilder> {
        '/SplashPage' : (BuildContext context) => new SplashPage(),
        '/FirstPage' : (BuildContext context) => new FirstPage(),
        '/InputPhoneNumberPage' : (BuildContext context) => new InputPhoneNumberPage(),
        '/PhoneOTPPage' : (BuildContext context) => new PhoneOTPPage(),
        '/RegisterUserDetailPage' : (BuildContext context) => new RegisterUserDetailPage(''),
        '/MainPage' : (BuildContext context) => MainPage(),
        '/SelectPortTerminalPage' : (BuildContext context) => SelectPortTerminalPage(),
        '/FirstStepPage' : (BuildContext context) => FirstStepPage(),
        '/SelectContainerTypePage' : (BuildContext context) => SelectContainerTypePage(),
        '/SelectSteamShipLinePage' : (BuildContext context) => SelectSteamShipLinePage(),
        '/SelectPortLoadingPage' : (BuildContext context) => SelectPortLoadingPage(),
        '/SelectVesselPage' : (BuildContext context) => SelectVesselPage(),
        '/SelectGoodsPage' : (BuildContext context) => SelectGoodsPage(),
        '/SelectLoadDescriptionPage' : (BuildContext context) => SelectLoadDescriptionPage(),
      },
    );
  }
}
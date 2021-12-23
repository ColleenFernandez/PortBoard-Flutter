import 'package:driver/adapter/JobAdapter.dart';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/common/FirebaseAPI.dart';
import 'package:driver/model/UserModel.dart';
import 'package:driver/pages/Job/JobRequestPage.dart';
import 'package:driver/pages/account/FirstPage.dart';
import 'package:driver/pages/Job/MyJobPage.dart';
import 'package:driver/service/FCMService.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';

class SplashPage extends StatefulWidget{

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool loading = false;

  String phone = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 5000), () {
      readSession();
    });
  }

  void readSession() async {
    phone = await Prefs.restore(Constants.PHONE);
    if (phone != null){
      login();
    }else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()));
    }
  }

  void login(){
    showProgress();
    Common.api.login(phone).then((value) {
      closeProgress();
      if (value != APIConst.SUCCESS){
        showToast(value);
        Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()));
      }else {
        if (Utils.isUserReadyToWork(Common.userModel)){
          FirebaseAPI.registerUser(Common.userModel);
        }
        startApp();
      }
    });
  }

  void startApp(){
    if (Common.jobRequest.id > 0){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => JobRequestPage(Common.jobRequest)), (route) => false);
    }else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage()), ModalRoute.withName('/MainPage'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      body: Image(image: Assets.IMG_SPLASH_BG, fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,),
    );
  }

  void showProgress() {
    setState(() {
      loading = true;
    });
  }

  void closeProgress(){
    setState(() {
      loading = false;
    });
  }
}
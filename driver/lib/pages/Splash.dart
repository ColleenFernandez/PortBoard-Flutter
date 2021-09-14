import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/UserModel.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'MainPage.dart';

class SplashPage extends StatefulWidget{

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  late final ProgressDialog progressDialog;

  final api = API();
  String phone = '';

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.green)));

    Future.delayed(const Duration(milliseconds: 5000), () {
      readSession();
    });
  }

  void readSession() async {
    phone = await Prefs.restore(Constants.PHONE);
    if (phone != null){
      login();
    }else {
      Navigator.pushNamed(context, '/FirstPage');
    }
  }

  void login(){
    progressDialog.show();
    api.login(phone).then((value) {
      progressDialog.hide();
      if (value is String){
        showToast(value);
        Navigator.pushNamed(context, '/FirstPage');
      }else {
        Common.userModel = value;
        gotoMainPage();
      }
    });
  }

  void gotoMainPage(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage()), ModalRoute.withName('/MainPage'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image(image: Assets.IMG_SPLASH_BG),
    );
  }
}
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
    readSession();
  }

  void readSession() async {
    phone = await Prefs.restore(Constants.PHONE);
    if (phone != null){
      login();
    }else {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushNamed(context, '/FirstPage');
      });
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
      body: Column(
        children: [
          SizedBox(height: 150),
          Center(child: Image(image: Assets.IMG_LOGO, width: 90, height: 150)),
          SizedBox(height: 20,),
          Text('Port Board', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
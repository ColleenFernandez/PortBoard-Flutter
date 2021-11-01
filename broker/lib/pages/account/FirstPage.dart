import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/pages/MainPage.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  late final ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.lightBlue)));
  }

  void tempLoginProcess(){
    showProgress();
    Common.api.login('+11234567891').then((value) {
      if (value is String){
        showToast(value);
      }else{
        Common.userModel = value;
        gotoMainPage();
      }
    }).onError((error, stackTrace) {
      showToast(error.toString());
    });
  }

  void gotoMainPage(){
    Prefs.save(Constants.PHONE, '+11234567891');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage()), ModalRoute.withName('/MainPage'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60,),
          Center(child: Image(image: Assets.IMG_LOGO, width: 250, height: 350)),
          SizedBox(height: 20,),
          Spacer(),
          Container(
            width: double.infinity,
            height: 48,
            margin: EdgeInsets.only(left: 30, right: 30),
            child: ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/InputPhoneNumberPage');
              //tempLoginProcess();
            }, child: Text('Login'), style: ElevatedButton.styleFrom(primary: AppColors.lightBlue),),
          ),
          Container(
            width: double.infinity,
            height: 48,
            margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 100),
            child: ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, '/InputPhoneNumberPage');
            }, child: Text('Sign Up', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(side: BorderSide(width: 1, color: AppColors.lightBlue), primary: Colors.white)),
          ),
        ],
      ),
    );
  }

  showProgress(){
    if (!progressDialog.isShowing()){
      progressDialog.show();
    }
  }

  closeProgress(){
    if (progressDialog.isShowing()){
      progressDialog.hide();
    }
  }
}
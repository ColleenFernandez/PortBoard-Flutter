import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/pages/account/InputPhoneNumberPage.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //permissionCheck();
  }

  void permissionCheck() async{
    var cameraPermission = await Permission.camera.status;
    if ( cameraPermission.isDenied){
      await Permission.camera.request().then((value) {
        if (value.isDenied){
          showSingleButtonDialog(
              context,
              Constants.PERMISSION_ALERT,
              'You have to enable the camera permission to upload some pictures',
              Constants.Okay, () {
                Navigator.pop(context);
                permissionCheck();
          });
        }
      });
    }

    var storagePermission = await Permission.storage.status;
    if (storagePermission.isDenied){
      await Permission.storage.request().then((value) {
        showSingleButtonDialog(
            context,
            Constants.PERMISSION_ALERT,
            'You have to enable storage permission to upload picture from your phone',
            Constants.Okay, () {
              Navigator.pop(context);
              permissionCheck();
        });
      });
    }

    var locationPermission = await Permission.location.status;
    if (locationPermission.isDenied){
      await Permission.location.request().then((value) {
        showSingleButtonDialog(
            context,
            Constants.PERMISSION_ALERT,
            'You have to enable location permission to tracking your location in real-time',
            Constants.Okay,() {
              Navigator.pop(context);
              permissionCheck();
        });
      });
    }
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => InputPhoneNumberPage()));
            }, child: Text('Login'), style: ElevatedButton.styleFrom(primary: AppColors.green),),
          ),
          Container(
            width: double.infinity,
            height: 48,
            margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 100),
            child: ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InputPhoneNumberPage()));
            }, child: Text('Sign Up', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(side: BorderSide(width: 1, color: AppColors.green), primary: Colors.white)),
          ),
        ],
      ),
    );
  }
}
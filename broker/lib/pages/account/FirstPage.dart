import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
}
import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/common/FirebaseAPI.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../MainPage.dart';
import 'RegisterUserDetailPage.dart';

class PhoneOTPPage extends StatefulWidget{

  PhoneOTPPage({Key? key}) : super(key: key);

  @override
  _PhoneOTPPageState createState() => _PhoneOTPPageState();

}

class _PhoneOTPPageState extends State<PhoneOTPPage> {
  bool loading = false;
  String phone = '', verificationId = '', verifyCode = '';
  bool isUserExist = true;

  @override
  void initState() {
    super.initState();
  }

  void getUserModel(){
    showProgress();
    Common.api.login(phone).then((value) {
      if (value != APIConst.SUCCESS){
        showToast(value);
        setState(() {
          isUserExist = false;
        });
      }else{
        FirebaseAPI.registerUser(Common.userModel);
        gotoMainPage();
      }
    }).onError((error, stackTrace) {
      showToast(error.toString());
    });
  }

  void sendOTP() async{
    showProgress();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          closeProgress();
        },
        verificationFailed: (FirebaseException e) {

        }, codeSent: (String verificationID, int? resendToken) {
      this.verificationId = verificationID;
      closeProgress();
      showToast('Verification Code Sent Again!');
    }, codeAutoRetrievalTimeout: (String verificationID) {
      closeProgress();
    });
  }

  void verifyPhone(String verifyCode) async {
    showProgress();
    PhoneAuthCredential credential = await PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: verifyCode);
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      if (value.user != null){
        closeProgress();
        showToast('Phone verification succeed');
        getUserModel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {

    var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    phone = args[Constants.PHONE];
    verificationId = args[Constants.VERIFICATION_ID];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: AppColors.darkBlue,
            elevation: 2,
            iconTheme: IconThemeData(color: Colors.white)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, top: 50),
              child: Row(
                children: [
                  Text('We sent SMS verification code to', style: TextStyle(fontFamily: 'RobotoCondensed')),
                  SizedBox(width: 10),
                  Text(phone, style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold))
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 30, top: 5),
              child: Text('Please input the code.', style: TextStyle(color: Colors.black87)),
            ),
            Container(
              margin: EdgeInsets.only(left: 25),
              child: TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('Wrong Number?', style: TextStyle(color: AppColors.green, fontSize: 16))),
            ),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50, top: 30),
              child: PinCodeTextField(
                appContext: context,
                keyboardType: TextInputType.number,
                textStyle: TextStyle(color: Colors.black87, fontSize: 20),
                pinTheme: PinTheme(
                  inactiveColor: Colors.grey,
                  activeColor: AppColors.green,
                  shape: PinCodeFieldShape.underline
                ),
                length: 6,
                onCompleted: (v) {
                  verifyPhone(v);
                },
                onChanged: (v) {}
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, top: 50),
              child: Row(
                children: [
                  Text('Did not you receive the code ?'),
                  SizedBox(width: 10),
                  TextButton(onPressed: () {

                  }, child: Text('Resend', style: TextStyle(color: AppColors.green, fontSize: 18))),
                  Icon(Icons.arrow_right, color: AppColors.green)
                ],
              ),
            ),
            Visibility(
                visible: !isUserExist ,
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 100),
                        child: Text('User is not registered, Please continue for Sign Up',style: TextStyle(fontSize: 17),)),
                    Container(
                      height: 48,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: AppColors.green),
                        onPressed: () {
                          gotoRegisterUserDetailPage();
                        }, child: Text('Continue with Signup'),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  // goto pages
  void gotoMainPage(){
    Prefs.save(Constants.PHONE, phone);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage()), ModalRoute.withName('/MainPage'));
  }

  void gotoRegisterUserDetailPage(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => RegisterUserDetailPage(phone)), ModalRoute.withName('/RegisterUserDetailPage'));
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
import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../MainPage.dart';
import 'RegisterUserDetailPage.dart';

class PhoneOTPPage extends StatefulWidget{

  PhoneOTPPage({Key? key}) : super(key: key);

  @override
  _PhoneOTPPageState createState() => _PhoneOTPPageState();

}

class _PhoneOTPPageState extends State<PhoneOTPPage> {

  final api = API();
  late final ProgressDialog progressDialog;
  String phone = '', verificationId = '', verifyCode = '';
  bool isUserExist = true;

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.green)));
  }

  void getUserModel() async{
    progressDialog.show();
    api.login(phone).then((value) {
      progressDialog.hide();

      if (value is String){
        showToast(value);
        setState(() {
          isUserExist = false;
        });
      }else{
        Common.userModel = value;
        gotoMainPage();
      }
    }).onError((error, stackTrace) {
      progressDialog.hide();
      showToast(error.toString());
    });
  }

  void sendOTP() async{
    progressDialog.show();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          progressDialog.hide();
        },
        verificationFailed: (FirebaseException e) {

        }, codeSent: (String verificationID, int? resendToken) {
      this.verificationId = verificationID;
      progressDialog.hide();
      showToast('Verification Code Sent Again!');
    }, codeAutoRetrievalTimeout: (String verificationID) {
      progressDialog.hide();
    });
  }

  void verifyPhone(String verifyCode) async {
    progressDialog.show();
    PhoneAuthCredential credential = await PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: verifyCode);
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      if (value.user != null){
        progressDialog.hide();
        showToast('Phone verification succeed');
        getUserModel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    phone = args[Constants.PHONE];
    verificationId = args[Constants.VERIFICATION_ID];

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            iconTheme: IconThemeData(color: Colors.black87)),
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
}
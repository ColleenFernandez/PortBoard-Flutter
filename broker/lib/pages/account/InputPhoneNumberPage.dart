import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/main.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class InputPhoneNumberPage extends StatefulWidget {
  @override
  _InputPhoneNumberPageState createState() => _InputPhoneNumberPageState();
}

class _InputPhoneNumberPageState extends State<InputPhoneNumberPage> {

  TextEditingController edtPhone = new TextEditingController();

  late final ProgressDialog progressDialog;

  String countryCode = '+1', verificationId = '';

  void sendOTP() async{
    progressDialog.show();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode + edtPhone.text,
        verificationCompleted: (PhoneAuthCredential credential) {
          progressDialog.hide();
        },
        verificationFailed: (FirebaseException e) {
          progressDialog.hide();
          print(e);
          showToast(e.message.toString());
        }, codeSent: (String verificationID, int? resendToken) {
          this.verificationId = verificationID;
          progressDialog.hide();
          gotoPhoneOTPPage();
    }, codeAutoRetrievalTimeout: (String verificationID) {
       progressDialog.hide();
    });
  }

  void gotoPhoneOTPPage(){
    Navigator.pushNamed(context, '/PhoneOTPPage',
        arguments: {
          Constants.PHONE : countryCode + edtPhone.text,
          Constants.VERIFICATION_ID : verificationId
        });
  }

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.lightBlue)));
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: AppColors.darkBlue,
            elevation: 2,
            iconTheme: IconThemeData(color: Colors.white)),
        body: Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Select your country', style: TextStyle(fontSize: 18)),
                    CountryCodePicker(
                      onChanged: (countryCode) {
                        this.countryCode = countryCode.dialCode!;
                      },
                      initialSelection: 'US',
                      showCountryOnly: false,
                      dialogSize: Size(350, 700),
                    )
                  ],
                ),
                SizedBox(height: 50),
                Text('Input phone number'),
                SizedBox(height: 10),
                TextField(
                  controller: edtPhone,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 25),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.lightBlue, width: 2),
                    )
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 80),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(onPressed: () {
                    if (edtPhone.text.isNotEmpty){
                      sendOTP();
                    }else {
                      showToast('Please input phone number');
                    }

                  }, child: Text('Verify'), style: ElevatedButton.styleFrom(primary: AppColors.lightBlue)),
                )
              ],
            ),
          ),
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
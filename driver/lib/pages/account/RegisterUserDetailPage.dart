import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/common/FirebaseAPI.dart';
import 'package:driver/pages/MainPage.dart';
import 'package:driver/utils/Prefs.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterUserDetailPage extends StatefulWidget {

  String phone = '';
  RegisterUserDetailPage(this.phone);

  @override
  _RegisterUserDetailPageState createState() => _RegisterUserDetailPageState();
}

class _RegisterUserDetailPageState extends State<RegisterUserDetailPage> {

  bool loading = false;

  TextEditingController edtFirstName = new TextEditingController();
  TextEditingController edtLastName = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();

  bool noMiddleName = false;
  String gender = Constants.MALE;


  @override
  void initState() {
    super.initState();
  }

  bool isValid(){

    if (edtFirstName.text.isEmpty){
      showToast('Please input firstname');
      return false;
    }

    if (edtLastName.text.isEmpty){
      showToast('Please input lastname');
      return false;
    }

    if (edtEmail.text.isEmpty){
      showToast('Please input email');
      return false;
    }

    return true;
  }
  void registerUserDetail(){
    showProgress();
    Common.api.register(widget.phone, edtFirstName.text, edtLastName.text, edtEmail.text, gender, Constants.USER_TYPE).then((value) {
      closeProgress();
      if (value != APIConst.SUCCESS){
        showToast(value);
      }else {
        gotoMainPage();
      }
    }).onError((error, stackTrace) {
      closeProgress();
      LogUtils.log('error ===> ${error.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: AppColors.darkBlue,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('Register', style: TextStyle(color: Colors.black87, fontSize: 23))),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('First name'),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.green, width: 2)
                    )
                  ),
                  controller: edtFirstName,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('Last name'),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.green, width: 2)
                      )
                  ),
                  controller: edtLastName,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('Email'),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.green, width: 2)
                      )
                  ),
                  controller: edtEmail,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender = Constants.MALE;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.black12)
                      ),
                      child: Column(
                        children: [
                          Image(image: Assets.IMG_MALE, height: 80),
                          SizedBox(height: 10),
                          Visibility(
                            visible: gender == Constants.MALE,
                              child: Image(image: Assets.IC_CHECK_IN, height: 20))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  InkWell(
                    onTap: () {
                      setState(() {
                        gender = Constants.FEMALE;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.black12)
                      ),
                      child: Column(
                        children: [
                          Image(image: Assets.IMG_FEMALE, height: 80),
                          SizedBox(height: 10),
                          Visibility(
                            visible: gender == Constants.FEMALE,
                              child: Image(image: Assets.IC_CHECK_IN, height: 20))
                        ],
                      ),
                    ),
                  ),
                  Spacer()
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.green),
                  onPressed: () {
                    if (isValid()){
                      registerUserDetail();
                    }
                  },
                  child: Text('Register', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // go to page
  void gotoMainPage() {
    Prefs.save(Constants.PHONE, widget.phone);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage()), ModalRoute.withName('/MainPage'));
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
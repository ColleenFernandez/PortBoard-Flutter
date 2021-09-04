import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/pages/MainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterUserDetailPage extends StatefulWidget {
  @override
  _RegisterUserDetailPageState createState() => _RegisterUserDetailPageState();
}

class _RegisterUserDetailPageState extends State<RegisterUserDetailPage> {

  TextEditingController edtFirstName = new TextEditingController();
  TextEditingController edtLastName = new TextEditingController();
  TextEditingController edtMiddleName = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();

  bool noMiddleName = false, maleSelected = true;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87)),
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
                  controller: edtFirstName,
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
                  controller: edtFirstName,
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
                        maleSelected = true;
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
                            visible: maleSelected,
                              child: Image(image: Assets.IC_CHECK_IN, height: 20))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  InkWell(
                    onTap: () {
                      setState(() {
                        maleSelected = false;
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
                            visible: !maleSelected,
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
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage()), ModalRoute.withName('/MainPage'));
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
}
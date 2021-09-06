import 'dart:ui';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SubmitDriverLicensePage extends StatefulWidget {
  @override
  _SubmitDriverLicensePageState createState() => _SubmitDriverLicensePageState();
}

class _SubmitDriverLicensePageState extends State<SubmitDriverLicensePage> {

  TextEditingController edtDriverLicenseNumber = new TextEditingController();

  void showCalendar(){
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(9999, 12, 30), onChanged: (date) {
          print('change $date');
        }, onConfirm: (date) {
          print('confirm $date');
        }, currentTime: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Verification Status', style: TextStyle(color: Colors.black87, fontSize: 16)),
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.black87)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('Driver license number'),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.green, width: 2)
                      )
                  ),
                  controller: edtDriverLicenseNumber,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('Expiration date'),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, top: 5, right: 30),
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.green, width: 2)),
                        disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))
                      ),
                      controller: edtDriverLicenseNumber,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Positioned(
                      right: 20,
                      bottom: 0,
                      child: IconButton(onPressed: () {
                        showCalendar();
                      }, icon: Icon(Icons.calendar_today_rounded, color: AppColors.green)))
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('Driver license - front picture'),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 5),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Image(image: Assets.DEFAULT_IMG, width: double.infinity, height: 220, fit: BoxFit.cover),
                    ),
                    Positioned(right: 0, bottom: 0,
                        child: FloatingActionButton(
                            mini: true,
                            heroTag: 'btn2',
                            backgroundColor: Colors.white,
                            onPressed: () {

                            }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('Driver license - back picture'),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 5),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Image(image: Assets.DEFAULT_IMG, width: double.infinity, height: 220, fit: BoxFit.cover),
                    ),
                    Positioned(right: 0, bottom: 0,
                        child: FloatingActionButton(
                            heroTag: 'btn1',
                            backgroundColor: Colors.white,
                            mini: true,

                            onPressed: () {

                            }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(30),
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.green),
                  onPressed: () {

                  }, child: Text('Submit'),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
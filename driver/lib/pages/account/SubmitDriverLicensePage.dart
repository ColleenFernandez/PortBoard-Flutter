import 'dart:math';
import 'dart:ui';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/API.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/utils/utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SubmitDriverLicensePage extends StatefulWidget {
  @override
  _SubmitDriverLicensePageState createState() => _SubmitDriverLicensePageState();
}

class _SubmitDriverLicensePageState extends State<SubmitDriverLicensePage> {

  final api = API();

  final int IS_FRONT_PIC = 100, IS_BACK_PIC = 101;

  TextEditingController edtDriverLicenseNumber = new TextEditingController();
  TextEditingController edtExpiryDate = new TextEditingController();
  int expiryDate = 0, imgType = 0;
  late dynamic frontPic = Assets.DEFAULT_IMG, backPic = Assets.DEFAULT_IMG;

  void submitDriverLicense() async{
    final frontPicPath = await FlutterAbsolutePath.getAbsolutePath((frontPic as Asset).identifier);
    final backPicPath  = await FlutterAbsolutePath.getAbsolutePath((backPic as Asset).identifier);
    api.submitDriverLicense(frontPicPath, backPicPath, Common.userModel.state, edtDriverLicenseNumber.text, expiryDate.toString(), Common.userModel.id).then((value) {
      if (value is String){
        showToast(value);
      }else {
        showToast('Driver license submitted successfully');
      }
    });
  }

  bool isValid(){
    if (edtDriverLicenseNumber.text.isEmpty){
      showToast('Input Driver license');
      return false;
    }
    if (expiryDate == 0){
      showToast('Please input expiration date.');
      return false;
    }

    if (frontPic is AssetImage){
      showToast('Please upload front picture of driver license');
      return false;
    }

    if (backPic is AssetImage){
      showToast('Please upload back picture of driver license');
      return false;
    }

    return true;
  }

  Future<void> loadPicture(int type) async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: true,
          selectedAssets: [],
          materialOptions: MaterialOptions(
            useDetailsView: false,
            autoCloseOnSelectionLimit: true
        ));
    } on Exception catch(e) {
      showToast(e.toString());
    }

    if (!mounted) return;
    if (resultList == null) return;
    if (resultList.isEmpty) return;

    setState(() {
      if (type == IS_FRONT_PIC){
        frontPic = resultList[0];
      }else if (type == IS_BACK_PIC){
        backPic = resultList[0];
      }
    });
  }

  void showCalendar(){
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(9999, 12, 30), onChanged: (date) {
          print('change $date');
        }, onConfirm: (date) {
          print('confirm $date');
          expiryDate = date.millisecondsSinceEpoch;
          setState(() {
            edtExpiryDate.text = Utils.getDate(expiryDate);
          });
        }, currentTime: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          title: Text('Submit driver license', style: TextStyle(color: Colors.white, fontSize: 16)),
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white)),
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
                  keyboardType: TextInputType.number,
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
                      controller: edtExpiryDate,
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
                    StsImgView(image: frontPic),
                    Positioned(right: 0, bottom: 0,
                        child: FloatingActionButton(
                            mini: true,
                            heroTag: 'btn2',
                            backgroundColor: Colors.white,
                            onPressed: () {
                              loadPicture(IS_FRONT_PIC);
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
                    StsImgView(image: backPic),
                    Positioned(right: 0, bottom: 0,
                        child: FloatingActionButton(
                            heroTag: 'btn1',
                            backgroundColor: Colors.white,
                            mini: true,
                            onPressed: () {
                              loadPicture(IS_BACK_PIC);
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
                    if (isValid()){

                    }
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
import 'dart:io';
import 'dart:ui';
import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SubmitDriverLicensePage extends StatefulWidget {
  @override
  _SubmitDriverLicensePageState createState() => _SubmitDriverLicensePageState();
}

class _SubmitDriverLicensePageState extends State<SubmitDriverLicensePage> {

  final int IS_FRONT_PIC = 100, IS_BACK_PIC = 101;

  bool loading = false, isEditable = true;
  TextEditingController edtDriverLicenseNumber = new TextEditingController();
  TextEditingController edtExpiryDate = new TextEditingController();
  int expiryDate = 0, imgType = 0;
  late dynamic frontPic = Assets.DEFAULT_IMG, backPic = Assets.DEFAULT_IMG;

  @override
  void initState() {
    super.initState();

    if (Common.userModel.driverLicenseModel.driverLicense.isNotEmpty){
      loadData();
    }
  }

  void loadData(){
    if (Common.userModel.driverLicenseModel.status == Constants.PENDING || Common.userModel.driverLicenseModel.status == Constants.ACCEPT){
      isEditable = false;
    }else {
      isEditable = true;
    }

    edtDriverLicenseNumber.text = Common.userModel.driverLicenseModel.driverLicense;
    edtExpiryDate.text = Utils.getDate(Common.userModel.driverLicenseModel.expirationDate);
    frontPic = Common.userModel.driverLicenseModel.frontPic;
    backPic = Common.userModel.driverLicenseModel.backPic;
  }

  void submitDriverLicense() async{

    showProgress();

    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);

    final backPicFile = backPic as File;
    final String backPicPath = await FlutterAbsolutePath.getAbsolutePath(backPicFile.path);


    Common.api.submitDriverLicense(Common.userModel.id, edtDriverLicenseNumber.text, expiryDate.toString(), frontPicPath, backPicPath).then((value) {
      closeProgress();
      if (value == APIConst.SUCCESS) {
        showSingleButtonDialog(
            context,
            'Driver License Submitted!',
            'Your driver license submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
            Constants.Okay, () {
              Navigator.pop(context);
              Navigator.pop(context, true);
        });
      }else {
        showToast(value);
      }
    }).onError((error, stackTrace) {
      closeProgress();
      LogUtils.log('Submit Driver License API Error ====>  ${error.toString()}');
      showToast(APIConst.SERVER_ERROR);
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

    final croppedFile = await cropImage(resultList[0]);
    if (croppedFile == null) return;

    setState(() {
      if (type == IS_FRONT_PIC){
        frontPic = croppedFile; //resultList[0];
      }else if (type == IS_BACK_PIC){
        backPic = croppedFile; //resultList[0];
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
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          title: Row(
            children: [
              Text('Driver License', style: TextStyle(color: Colors.white, fontSize: 16)),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white
                  ), child: Text(Utils.getStatus(Common.userModel.driverLicenseModel.status), style: TextStyle(color: AppColors.darkBlue),))
            ],
          ),
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.white)),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: Common.userModel.driverLicenseModel.status == Constants.REJECT,
                child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black12
                    ),
                    child: Text(Common.userModel.driverLicenseModel.reason, style: TextStyle(color: Colors.red),)),
              ),
              Text('Driver license number'),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.green, width: 2)
                    )
                ),
                controller: edtDriverLicenseNumber,
                style: TextStyle(fontSize: 20),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text('Expiration date'),
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
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
                      right: 0,
                      bottom: 0,
                      child: IconButton(onPressed: () {
                        if (isEditable)
                          showCalendar();

                      }, icon: Icon(Icons.calendar_today_rounded, color: AppColors.green)))
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text('Driver license - front picture'),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Stack(
                  children: [
                    StsImgView(image: frontPic, width: MediaQuery.of(context).size.width, height: 250,),
                    Positioned(right: 0, bottom: 0,
                        child: FloatingActionButton(
                            mini: true,
                            heroTag: 'FAB-10',
                            backgroundColor: Colors.white,
                            onPressed: () {
                              if (isEditable)
                                loadPicture(IS_FRONT_PIC);

                            }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text('Driver license - back picture'),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Stack(
                  children: [
                    StsImgView(image: backPic, width: double.infinity, height: 250),
                    Positioned(right: 0, bottom: 0,
                        child: FloatingActionButton(
                            heroTag: 'FAB-11',
                            backgroundColor: Colors.white,
                            mini: true,
                            onPressed: () {
                              if (isEditable)
                                loadPicture(IS_BACK_PIC);
                            }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                  ],
                ),
              ),
              Visibility(
                visible: Common.userModel.driverLicenseModel.status != Constants.ACCEPT,
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: AppColors.green),
                    onPressed: () {
                      if (isValid()){
                        submitDriverLicense();
                      }
                    }, child: Text('Submit'),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
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


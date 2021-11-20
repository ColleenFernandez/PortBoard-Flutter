import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/pages/account/SelectStatePage.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SubmitBusinessCertificatePage extends StatefulWidget {
  @override
  State<SubmitBusinessCertificatePage> createState() => _SubmitBusinessCertificatePageState();
}

class _SubmitBusinessCertificatePageState extends State<SubmitBusinessCertificatePage> {

  TextEditingController edtIssuedDate = new TextEditingController();
  TextEditingController edtLegalName = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();
  TextEditingController edtCity = new TextEditingController();
  TextEditingController edtZipCode = new TextEditingController();
  TextEditingController edtRegisteredName = new TextEditingController();

  late final ProgressDialog progressDialog;
  late dynamic frontPic = Assets.DEFAULT_IMG;
  String state = '';
  int issuedDate = 0;

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context, isDismissible: false);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.green)));
  }

  void submitBusinessCertificate() async{
    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);

    await progressDialog.show();
    Common.api.submitBusinessCertificate(
        Common.userModel.id,
        edtLegalName.text,
        edtRegisteredName.text,
        issuedDate.toString(),
        edtAddress.text,
        edtCity.text,
        state,
        edtZipCode.text,
        frontPicPath).then((value) {
      progressDialog.hide();
      if (value == APIConst.SUCCESS) {
        showSingleButtonDialog(
            context,
            'Business Certificate Submitted!',
            'Your business certificate submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
            Constants.Okay, () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }else {
        showToast(value);
      }
    }).onError((error, stackTrace) {
      progressDialog.hide();
      LogUtils.log('Submit Driver License API Error ====>  ${error.toString()}');
      showToast(APIConst.SERVER_ERROR);
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
          issuedDate = date.millisecondsSinceEpoch;
          setState(() {
            edtIssuedDate.text =  Utils.getDate(issuedDate);
          });
        }, currentTime: DateTime.now());
  }

  Future<void> loadPicture() async {
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
      frontPic = croppedFile;
    });
  }

  bool isValid(){
    if (edtLegalName.text.isEmpty){
      showToast('Input Legal Name');
      return false;
    }

    if (edtRegisteredName.text.isEmpty){
      showToast('Input Registered Name');
      return false;
    }

    if (edtIssuedDate.text.isEmpty){
      showToast('Input Issued date');
      return false;
    }

    if (edtAddress.text.isEmpty){
      showToast('Input Address');
      return false;
    }

    if (state.isEmpty){
      showToast('Please input state');
      return false;
    }

    if (edtCity.text.isEmpty){
      showToast('Input City');
      return false;
    }

    if (edtZipCode.text.isEmpty){
      showToast('Input Zip Code');
      return false;
    }

    if (frontPic is AssetImage){
      showToast('Please upload front picture of Certificate photo');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          title: Text('Business Certificate'),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Legal Name', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  controller: edtLegalName,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.recent_actors, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Text('Registered Name', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  controller: edtRegisteredName,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Text('Issued Date', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  controller: edtIssuedDate,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          showCalendar();
                        }, icon: Icon(Icons.event_note, color: AppColors.darkBlue,),
                      )
                  ),
                ),
                SizedBox(height: 20,),
                Text('Address', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  controller: edtAddress,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.location_on, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('City', style: TextStyle(color: AppColors.darkBlue)),
                          TextField(
                            controller: edtCity,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('State', style: TextStyle(color: AppColors.darkBlue)),
                          Column(
                            children: [
                              SizedBox(height: 9,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(state),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectStatePage())).then((value) {
                                        if (value == null) return;
                                        setState(() {
                                          state = value as String;
                                        });
                                      });
                                    }, child: Icon(Icons.keyboard_arrow_down)),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                width: double.infinity, height: 1,
                                color: Colors.grey,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 4 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Zip Code', style: TextStyle(color: AppColors.darkBlue)),
                          TextField(
                            controller: edtZipCode,
                            keyboardType: TextInputType.number,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text('Certificate Photo'),
                SizedBox(height: 10,),
                Stack(
                  children: [
                    StsImgView(image: frontPic, width: MediaQuery.of(context).size.width, height: 250,),
                    Positioned(right: 0, bottom: 0,
                        child: FloatingActionButton(
                            mini: true,
                            heroTag: 'FAB-10',
                            backgroundColor: Colors.white,
                            onPressed: () {
                              loadPicture();
                            }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 30),
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: AppColors.green),
                    onPressed: () {
                      if (isValid()){
                        submitBusinessCertificate();
                      }
                    }, child: Text('SAVE'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
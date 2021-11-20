import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
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
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class BusinessEINDetailPage extends StatefulWidget {
  @override
  State<BusinessEINDetailPage> createState() => _BusinessEINDetailPageState();
}

class _BusinessEINDetailPageState extends State<BusinessEINDetailPage> {
  TextEditingController edtLegalName = new TextEditingController();
  TextEditingController edtBusinessEINNumber = new TextEditingController();
  TextEditingController edtIssuedDate = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();
  TextEditingController edtCity = new TextEditingController();
  TextEditingController edtZipCode = new TextEditingController();

  late final ProgressDialog progressDialog;
  late dynamic frontPic = Assets.DEFAULT_IMG;
  int issuedDate = 0;
  String state = '';
  bool isEditable = false;

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.BUSINESS_EIN_APPROVED, (value, callback) {
      Common.userModel.businessEINModel.status = Constants.ACCEPT;
      setState(() {});
    });

    progressDialog = ProgressDialog(context, isDismissible: false);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.green)));

    loadData();
  }

  void loadData(){
    if (Common.userModel.businessEINModel.status == Constants.PENDING || Common.userModel.businessEINModel.status == Constants.ACCEPT){
      isEditable = false;
    }else {
      isEditable = true;
    }

    edtLegalName.text = Common.userModel.businessEINModel.legalName;
    edtBusinessEINNumber.text = Common.userModel.businessEINModel.einNumber;
    edtIssuedDate.text = Utils.getDate(Common.userModel.businessEINModel.issuedDate);
    edtAddress.text = Common.userModel.businessEINModel.address;
    edtCity.text = Common.userModel.businessEINModel.city;
    state = Common.userModel.businessEINModel.state;
    edtZipCode.text = Common.userModel.businessEINModel.zipCode;
    frontPic = Constants.DOCUMENT_DIRECTORY_URL + Common.userModel.businessEINModel.frontPic;
  }

  void submitBusinessEINNumber() async{
    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);

    await progressDialog.show();

    Common.api.submitBusinessEINNumber(
        Common.userModel.id,
        edtLegalName.text,
        edtBusinessEINNumber.text,
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
            'Business EIN Number Submitted',
            'Your business EIN number submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
            Constants.Okay, () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }else {
        showToast(value);
      }
    }).onError((error, stackTrace) {
      progressDialog.hide();
      LogUtils.log('Error ====>  ${error.toString()}');
      showToast(APIConst.SERVER_ERROR);
    });;
  }

  bool isValid(){
    if (edtLegalName.text.isEmpty){
      showToast('Input Legal name');
      return false;
    }

    if (edtBusinessEINNumber.text.isEmpty){
      showToast('Input Business EIN number');
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

    if (edtCity.text.isEmpty){
      showToast('Input Address');
      return false;
    }

    if (state.isEmpty){
      showToast('Input State');
      return false;
    }

    if (edtZipCode.text.isEmpty){
      showToast('Input Zip code');
      return false;
    }

    if (frontPic is AssetImage){
      showToast('Please upload front picture of Certificate photo');
      return false;
    }

    return true;
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

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          title: Row(
            children: [
              Text('Business Certificate'),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white
                  ), child: Text(Utils.getStatus(Common.userModel.businessEINModel.status), style: TextStyle(color: AppColors.darkBlue),))
            ],
          ),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: Common.userModel.businessEINModel.status == Constants.REJECT,
                  child: Container(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.black12
                      ),
                      child: Text('here is the reject reason', style: TextStyle(color: Colors.red),)),
                ),
                Text('Legal Name', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  enabled: isEditable,
                  controller: edtLegalName,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.recent_actors, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Text('Business EIN Number', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  enabled: isEditable,
                  controller: edtBusinessEINNumber,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.recent_actors, color: AppColors.darkBlue,)
                  ),
                ),
                SizedBox(height: 20,),
                Text('Issued Date', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  enabled: false,
                  controller: edtIssuedDate,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (isEditable){
                            showCalendar();
                          }
                        }, icon: Icon(Icons.event_note, color: AppColors.darkBlue,),
                      )
                  ),
                ),
                SizedBox(height: 20,),
                Text('Address', style: TextStyle(color: AppColors.darkBlue)),
                TextField(
                  enabled: isEditable,
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
                            enabled: isEditable,
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
                                        if (isEditable){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectStatePage())).then((value) {
                                            if (value == null) return;
                                            setState(() {
                                              state = value as String;
                                            });
                                          });
                                        }
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
                            enabled: isEditable,
                            controller: edtZipCode,
                            keyboardType: TextInputType.number,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text('Photo'),
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
                              if (isEditable){
                                loadPicture();
                              }
                            }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                  ],
                ),
                SizedBox(height: 30,),
                Visibility(
                  visible: Common.userModel.businessEINModel.status != Constants.ACCEPT,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: isEditable ? AppColors.green : Colors.black26),
                      onPressed: () {
                        if (isEditable){
                          if (isValid()){
                            submitBusinessEINNumber();
                          }
                        }
                      }, child: Text('SAVE'),
                    ),
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
import 'package:driver/widget/StsProgressHUD.dart';
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
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class BusinessCertificateDetailPage extends StatefulWidget {
  @override
  State<BusinessCertificateDetailPage> createState() => _BusinessCertificateDetailPageState();
}

class _BusinessCertificateDetailPageState extends State<BusinessCertificateDetailPage> {

  bool loading = false;

  TextEditingController edtIssuedDate = new TextEditingController();
  TextEditingController edtLegalName = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();
  TextEditingController edtCity = new TextEditingController();
  TextEditingController edtZipCode = new TextEditingController();
  TextEditingController edtRegisteredName = new TextEditingController();

  late dynamic frontPic = Assets.DEFAULT_IMG;
  String state = '';
  int issuedDate = 0;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.BUSINESS_CERTIFICATE_APPROVED, (value, callback) {
      Common.userModel.businessCertificateModel.status = Constants.ACCEPT;
      setState(() {});
    });
    loadData();
  }

  void loadData(){
    if (Common.userModel.businessCertificateModel.status == Constants.PENDING || Common.userModel.businessCertificateModel.status == Constants.ACCEPT){
      isEditable = false;
    }else {
      isEditable = true;
    }
    edtLegalName.text = Common.userModel.businessCertificateModel.legalName;
    edtRegisteredName.text = Common.userModel.businessCertificateModel.registeredName;
    edtIssuedDate.text = Utils.getDate(Common.userModel.businessCertificateModel.issuedDate);
    edtAddress.text = Common.userModel.businessCertificateModel.address;
    edtCity.text = Common.userModel.businessCertificateModel.city;
    state = Common.userModel.businessCertificateModel.state;
    edtZipCode.text = Common.userModel.businessCertificateModel.zipCode;

    frontPic = Constants.DOCUMENT_DIRECTORY_URL + Common.userModel.businessCertificateModel.frontPic;
  }

  void submitBusinessCertificate() async{
    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);

    showProgress();
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
      closeProgress();
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
      closeProgress();
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
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(context);
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
              Text('Business Certificate'),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white
                  ), child: Text(Utils.getStatus(Common.userModel.businessCertificateModel.status), style: TextStyle(color: AppColors.darkBlue),))
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
                  visible: Common.userModel.businessCertificateModel.status == Constants.REJECT,
                  child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.black12
                      ),
                      child: Text(Common.userModel.businessCertificateModel.reason, style: TextStyle(color: Colors.red),)),
                ),
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
                SizedBox(height: 30,),
                Visibility(
                  visible: Common.userModel.businessCertificateModel.status != Constants.ACCEPT,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30),
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: isEditable ? AppColors.green : Colors.black26),
                      onPressed: () {
                        if (isValid()){
                          submitBusinessCertificate();
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
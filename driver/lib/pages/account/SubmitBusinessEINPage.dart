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
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SubmitBusinessEINPage extends StatefulWidget {
  @override
  State<SubmitBusinessEINPage> createState() => _SubmitBusinessEINPageState();
}

class _SubmitBusinessEINPageState extends State<SubmitBusinessEINPage> {

  TextEditingController edtLegalName = new TextEditingController();
  TextEditingController edtBusinessEINNumber = new TextEditingController();
  TextEditingController edtIssuedDate = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();
  TextEditingController edtCity = new TextEditingController();
  TextEditingController edtZipCode = new TextEditingController();

  bool loading = false, isEditable = true;
  late dynamic frontPic = Assets.DEFAULT_IMG;
  int issuedDate = 0;
  String state = '';

  @override
  void initState() {
    super.initState();

    if (Common.userModel.businessEINModel.legalName.isNotEmpty){
      loadData();
    }
  }

  void loadData(){
    edtLegalName.text = Common.userModel.businessEINModel.legalName;
    edtBusinessEINNumber.text = Common.userModel.businessEINModel.einNumber;
    edtIssuedDate.text = Utils.getDate(Common.userModel.businessEINModel.issuedDate);
    edtAddress.text = Common.userModel.businessEINModel.address;
    edtCity.text = Common.userModel.businessEINModel.city;
    state = Common.userModel.businessEINModel.state;
    edtZipCode.text = Common.userModel.businessEINModel.zipCode;
    frontPic = Common.userModel.businessEINModel.frontPic;
  }

  void submitBusinessEINNumber() async{
    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);

    showProgress();

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

      closeProgress();
      if (value == APIConst.SUCCESS) {
        showSingleButtonDialog(
            context,
            'Business EIN Number Submitted',
            'Your business EIN number submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
            Constants.Okay, () {
          Navigator.pop(context);
          Navigator.pop(context, true);
        });
      }else {
        showToast(value);
      }
    }).onError((error, stackTrace) {
      closeProgress();
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
          title: Text('Business EIN'),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 50),
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
              Text('Business EIN Number', style: TextStyle(color: AppColors.darkBlue)),
              TextField(
                controller: edtBusinessEINNumber,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.recent_actors, color: AppColors.darkBlue,)
                ),
              ),
              SizedBox(height: 20,),
              Text('Issued Date', style: TextStyle(color: AppColors.darkBlue)),
              TextField(
                controller: edtIssuedDate,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (isEditable)
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
                            if (isEditable)
                              loadPicture();
                          }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                ],
              ),
              Visibility(
                visible: Common.userModel.businessEINModel.status != Constants.ACCEPT,
                child: Container(
                  margin: EdgeInsets.only(top: 30, bottom: 30),
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: AppColors.green),
                    onPressed: () {
                      if (isValid()){
                        submitBusinessEINNumber();
                      }
                    }, child: Text('SAVE'),
                  ),
                ),
              )
            ],
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
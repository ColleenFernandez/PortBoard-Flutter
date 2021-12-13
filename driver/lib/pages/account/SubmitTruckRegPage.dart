import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/pages/account/SelectStatePage.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SubmitTruckRegPage extends StatefulWidget {
  @override
  State<SubmitTruckRegPage> createState() => _SubmitTruckRegPageState();
}

class _SubmitTruckRegPageState extends State<SubmitTruckRegPage> {

  TextEditingController edtCompanyName = new TextEditingController();
  TextEditingController edtAccountNumber = new TextEditingController();
  TextEditingController edtPlateNumber = new TextEditingController();
  TextEditingController edtUsdotNumber = new TextEditingController();
  TextEditingController edtExpiryDate = new TextEditingController();
  TextEditingController edtAddress = new TextEditingController();
  TextEditingController edtCity = new TextEditingController();
  TextEditingController edtZipCode = new TextEditingController();

  bool isEditable = true, loading = false;
  int expiryDate = 0;
  String state = '';
  late dynamic frontPic = Assets.DEFAULT_IMG;

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.NOTI_DOCUMENT_VERIFY_STATUS, (value, callback) {
      refreshUserDetail();
    });

    if (Common.userModel.truckRegistrationModel.companyName.isNotEmpty){
      loadData();
    }
  }

  void refreshUserDetail(){
    showProgress();
    Common.api.login(Common.userModel.phone).then((value) {
      closeProgress();
      if (value == APIConst.SUCCESS){
        loadData();
        setState(() {});
      }
    }).onError((error, stackTrace) {
      closeProgress();
      showToast(APIConst.SERVER_ERROR);

      LogUtils.log('error ===> ${error.toString()}');
    });
  }

  void callLoginAPI(){
    showProgress();
    Common.api.login(Common.userModel.phone).then((value) {
      closeProgress();
      if (value == APIConst.SUCCESS){
        setState(() {});
      }else {
        showToast(APIConst.SERVER_ERROR);
      }
    }).onError((error, stackTrace) {
      LogUtils.log('error ===> ${error.toString()}');
      closeProgress();
      showToast(APIConst.SERVER_ERROR);
    });
  }

  void loadData(){
    if (Common.userModel.truckRegistrationModel.status == Constants.PENDING || Common.userModel.truckRegistrationModel.status == Constants.ACCEPT){
      isEditable = false;
    }else {
      isEditable = true;
    }

    edtCompanyName.text = Common.userModel.truckRegistrationModel.companyName;
    edtAccountNumber.text = Common.userModel.truckRegistrationModel.accountNumber;
    edtPlateNumber.text = Common.userModel.truckRegistrationModel.plateNumber;
    edtUsdotNumber.text = Common.userModel.truckRegistrationModel.usdotNumber;
    edtExpiryDate.text = Utils.getDate(Common.userModel.truckRegistrationModel.expirationDate);
    edtAddress.text = Common.userModel.truckRegistrationModel.address;
    edtCity.text = Common.userModel.truckRegistrationModel.city;
    state = Common.userModel.truckRegistrationModel.state;
    edtZipCode.text = Common.userModel.truckRegistrationModel.zipCode;
    frontPic = Common.userModel.truckRegistrationModel.frontPic;
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
    if (edtCompanyName.text.isEmpty){
      showToast('Please input company name');
      return false;
    }

    if (edtAccountNumber.text.isEmpty){
      showToast('Please input account number');
      return false;
    }

    if (edtPlateNumber.text.isEmpty){
      showToast('Please input plate number');
      return false;
    }

    if (edtUsdotNumber.text.isEmpty){
      showToast('Please input USDOT number');
      return false;
    }

    if (edtExpiryDate.text.isEmpty){
      showToast('Please input Expiration date');
      return false;
    }

    if (edtAddress.text.isEmpty){
      showToast('Please input Address');
      return false;
    }

    if (edtCity.text.isEmpty){
      showToast('Please input City');
    }

    if (state.isEmpty){
      showToast('Please input state');
    }

    if (edtZipCode.text.isEmpty){
      showToast('Please input Zipcode');
    }

    if (frontPic is AssetImage){
      showToast('Please upload front picture of your truck');
      return false;
    }

    return true;
  }

  void submitTruckReg() async{
    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);

    showProgress();
    Common.api.submitTruckReg(Common.userModel.id,
        edtCompanyName.text,
        edtAccountNumber.text,
        edtPlateNumber.text,
        edtUsdotNumber.text,
        expiryDate.toString(),
        edtAddress.text,
        edtCity.text, state,
        edtZipCode.text, frontPicPath).then((value) {
          closeProgress();

          if (value == APIConst.SUCCESS) {
            showSingleButtonDialog(
                context,
                'Truck Registration Detail Submitted!',
                'Your truck registration detail submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
                Constants.Okay, () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            });
          }else {
            showToast(value);
          }
    }).onError((error, stackTrace) {
      closeProgress();
      LogUtils.log('submitTruckReg API Error ====>  ${error.toString()}');
      showToast(APIConst.SERVER_ERROR);
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
          title: Row(
            children: [
              Text('Truck Registration'),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white
                  ), child: Text(Utils.getStatus(Common.userModel.truckRegistrationModel.status), style: TextStyle(color: AppColors.darkBlue),))
            ],
          ),
          backgroundColor: AppColors.darkBlue,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
          child: Column(
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: Common.userModel.truckRegistrationModel.status == Constants.REJECT,
                child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black12
                    ),
                    child: Text(Common.userModel.truckRegistrationModel.reason, style: TextStyle(color: Colors.red),)),
              ),
              Text('Company Name'),
              TextField(controller: edtCompanyName,),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    child: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text('Account number'),
                        TextField(controller: edtAccountNumber,),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    child: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text('Plate number'),
                        TextField(controller: edtPlateNumber,),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    child: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text('USDOT number'),
                        TextField(controller: edtUsdotNumber,),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expiration date'),
                        Stack(
                          children: [
                            Container(
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.green, width: 2)),
                                    disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))
                                ),
                                controller: edtExpiryDate,
                              ),
                            ),
                            Positioned(
                                right: 0,
                                bottom: 0,
                                child: IconButton(onPressed: () {
                                  if (isEditable) {
                                    showCalendar();
                                  }
                                }, icon: Icon(Icons.calendar_today_rounded, color: AppColors.green)))
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Text('Address'),
              TextField(controller: edtAddress,),
              SizedBox(height: 30,),
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
              Text('Front Photo'),
              SizedBox(height: 10,),
              Stack(
                children: [
                  StsImgView(image: frontPic, width: MediaQuery.of(context).size.width, height: 250,),
                  Positioned(right: 0, bottom: 0,
                      child: FloatingActionButton(
                          mini: true,
                          heroTag: 'SubmitTruckRegPage-FAB-1',
                          backgroundColor: Colors.white,
                          onPressed: () {
                            loadPicture();
                          }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                ],
              ),
              Visibility(
                visible: Common.userModel.truckRegistrationModel.status != Constants.ACCEPT,
                child: Container(
                  width: double.infinity, height: 45,
                  margin: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: isEditable ? AppColors.green : Colors.black26),
                    onPressed: () {
                      if (isEditable){
                        if (isValid()){
                          submitTruckReg();
                        }
                      }
                  }, child: Text('SAVE'), ),
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
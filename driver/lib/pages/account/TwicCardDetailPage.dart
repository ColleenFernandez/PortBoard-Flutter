import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class TwicCardDetailPage extends StatefulWidget{
  @override
  State<TwicCardDetailPage> createState() => _TwicCardDetailPageState();
}

class _TwicCardDetailPageState extends State<TwicCardDetailPage> {

  final int IS_FRONT_PIC = 100, IS_BACK_PIC = 101;
  bool loading = false;

  TextEditingController edtCardNumber =  new TextEditingController();
  TextEditingController edtExpiryDate = new TextEditingController();
  bool isEditable = false;

  int expiryDate = 0, imgType = 0;
  late dynamic frontPic = Assets.DEFAULT_IMG, backPic = Assets.DEFAULT_IMG;

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.TWIC_CARD_APPROVED, (value, callback) {
      Common.userModel.twicCardModel.status = Constants.ACCEPT;
      setState(() {});
    });

    loadData();
  }

  void loadData(){

    if (Common.userModel.twicCardModel.status == Constants.PENDING || Common.userModel.twicCardModel.status == Constants.ACCEPT){
      isEditable = false;
    }else {
      isEditable = true;
    }

    edtCardNumber.text = Common.userModel.twicCardModel.cardNumber;
    edtExpiryDate.text = Utils.getDate(Common.userModel.twicCardModel.expirationDate);
    frontPic = Constants.DOCUMENT_DIRECTORY_URL + Common.userModel.twicCardModel.frontPic;
    backPic = Constants.DOCUMENT_DIRECTORY_URL + Common.userModel.twicCardModel.backPic;
  }

  void submitTwicCard() async{
    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);

    final backPicFile = backPic as File;
    final String backPicPath = await FlutterAbsolutePath.getAbsolutePath(backPicFile.path);

    showProgress();
    Common.api.submitTwicCard(Common.userModel.id, edtCardNumber.text, expiryDate.toString(), frontPicPath, backPicPath).then((value) {
      closeProgress();
      if (value == APIConst.SUCCESS) {
        showSingleButtonDialog(
            context,
            'Twic Card Submitted!',
            'Your Twic card submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
            Constants.Okay, () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }else {
        showToast(value);
      }
    }).onError((error, stackTrace) {
      closeProgress();
      LogUtils.log('error ====>  ${error.toString()}');
      showToast(APIConst.SERVER_ERROR);
    });
  }

  bool isValid(){

    if (edtCardNumber.text.isEmpty){
      showToast('Input Twic card number');
      return false;
    }

    if (edtExpiryDate.text.isEmpty){
      showToast('Input expiration date');
      return false;
    }

    if (frontPic is AssetImage){
      showToast('Please upload front  picture of Twic card');
      return false;
    }

    if (backPic is AssetImage){
      showToast('Please upload back picture of Twic card');
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
          expiryDate = date.millisecondsSinceEpoch;
          setState(() {
            edtExpiryDate.text = Utils.getDate(expiryDate);
          });
        }, currentTime: DateTime.now());
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
        frontPic = croppedFile;
      }else if (type == IS_BACK_PIC){
        backPic = croppedFile;
      }
    });
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
          elevation: 1,
          backgroundColor: AppColors.darkBlue,
          title: Row(
            children: [
              Text('Submit twic card'),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white
                  ), child: Text(Utils.getStatus(Common.userModel.twicCardModel.status), style: TextStyle(color: AppColors.darkBlue),))
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: Common.userModel.twicCardModel.status == Constants.REJECT,
                child: Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black12
                    ),
                    child: Text(Common.userModel.twicCardModel.reason, style: TextStyle(color: Colors.red),)),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('Twic card number'),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 5, right: 30),
                child: TextField(
                  enabled: isEditable,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.green, width: 2)
                      )
                  ),
                  controller: edtCardNumber,
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
                        if (isEditable){
                          showCalendar();
                        }
                      }, icon: Icon(Icons.calendar_today_rounded, color: AppColors.green)))
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('Twic card - front picture'),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 5),
                child: Stack(
                  children: [
                    StsImgView(image: frontPic, width: double.infinity, height: 250),
                    Positioned(right: 0, bottom: 0,
                        child: FloatingActionButton(
                            mini: true,
                            heroTag: 'FAB-12',
                            backgroundColor: Colors.white,
                            onPressed: () {
                              if (isEditable){
                                loadPicture(IS_FRONT_PIC);
                              }
                            }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 20),
                child: Text('Twic card - back picture'),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 30),
                child: Stack(
                  children: [
                    StsImgView(image: backPic, width: double.infinity, height: 250),
                    Positioned(right: 0, bottom: 0,
                        child: FloatingActionButton(
                            heroTag: 'FAB-13',
                            backgroundColor: Colors.white,
                            mini: true,
                            onPressed: () {
                              if (isEditable){
                                loadPicture(IS_BACK_PIC);
                              }
                            }, child: Icon(Icons.camera_alt, color: AppColors.green)))
                  ],
                ),
              ),
              Visibility(
                visible: Common.userModel.twicCardModel.status != Constants.ACCEPT,
                child: Container(
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: isEditable ? AppColors.green : Colors.black26),
                    onPressed: () {
                      if (isEditable){
                        if (isValid()){
                          submitTwicCard();
                        }
                      }
                    }, child: Text('Submit'),
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
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
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SubmitEmitionInspectPage extends StatefulWidget {
  @override
  State<SubmitEmitionInspectPage> createState() => _SubmitEmitionInspectPageState();
}

class _SubmitEmitionInspectPageState extends State<SubmitEmitionInspectPage> {

  TextEditingController edtInspectionNumber = new TextEditingController();
  TextEditingController edtExpiryDate = new TextEditingController();
  String state = '';
  bool isEditable = true, loading = false;
  int expiryDate = 0;
  late dynamic frontPic = Assets.DEFAULT_IMG;

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.NOTI_DOCUMENT_VERIFY_STATUS, (value, callback) {
      refreshUserDetail();
    });

    if (Common.userModel.emitionInspectionModel.ispectionNumber.isNotEmpty){
      loadData();
    }
    loadData();
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

  void loadData(){
    if (Common.userModel.emitionInspectionModel.status == Constants.PENDING || Common.userModel.emitionInspectionModel.status == Constants.ACCEPT) {
      isEditable = false;
    }else {
      isEditable = true;
    }
    edtInspectionNumber.text = Common.userModel.emitionInspectionModel.ispectionNumber;
    state = Common.userModel.emitionInspectionModel.state;
    edtExpiryDate.text = Utils.getDate(Common.userModel.emitionInspectionModel.expirationDate);
    frontPic = Common.userModel.emitionInspectionModel.frontPic;
  }

  void submitEmitionInspection() async{
    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);

    showProgress();
    Common.api.submitEmitionInspection(
        Common.userModel.id,
        edtInspectionNumber.text,
        state,
        expiryDate.toString(),
        frontPicPath).then((value) {
          closeProgress();
          if (value == APIConst.SUCCESS) {
            showSingleButtonDialog(
                context,
                'Emition Inspection Submitted!',
                'Your Emition Inspection detail submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
                Constants.Okay, () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            });
          }else {
            showToast(value);
          }
    }).onError((error, stackTrace) {
      closeProgress();
      LogUtils.log('error ===> ${error.toString()}');
      showToast(APIConst.SERVER_ERROR);
    });
  }

  bool isValid(){
    if (edtInspectionNumber.text.isEmpty) {
      showToast('Please input Emition Inspection Number');
      return false;
    }

    if (state.isEmpty){
      showToast('Please input State');
      return false;
    }

    if (edtExpiryDate.text.isEmpty){
      showToast('Please input expiration date');
      return false;
    }

    if (frontPic is AssetImage){
      showToast('Please upload front picture of your truck');
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
          title: Row(
            children: [
              Text('Emition Inspection'),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white
                  ), child: Text(Utils.getStatus(Common.userModel.emitionInspectionModel.status), style: TextStyle(color: AppColors.darkBlue),))
            ],
          ),
          backgroundColor: AppColors.darkBlue,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: Common.userModel.emitionInspectionModel.status == Constants.REJECT,
                child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black12
                    ),
                    child: Text(Common.userModel.emitionInspectionModel.reason, style: TextStyle(color: Colors.red),)),
              ),
              Text('Emition Inspection Number'),
              TextField(controller: edtInspectionNumber,),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 - 30,
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
                visible: Common.userModel.emitionInspectionModel.status != Constants.ACCEPT,
                child: Container(
                  width: double.infinity, height: 45,
                  margin: EdgeInsets.only(top: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: isEditable ? AppColors.green : Colors.black26),
                    onPressed: () {
                      if (isEditable){
                        if (isValid()){
                          submitEmitionInspection();
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
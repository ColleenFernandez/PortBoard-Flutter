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
import 'package:multi_image_picker/multi_image_picker.dart';

class DriverPhotoPage extends StatefulWidget {
  @override
  State<DriverPhotoPage> createState() => _DriverPhotoPageState();
}

class _DriverPhotoPageState extends State<DriverPhotoPage> {
  late dynamic frontPic = Assets.DEFAULT_IMG;
  bool isChecked = false;
  bool loading = false;

  bool isEditable = false;

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.DRIVER_PHOTO_APPROVED, (value, callback) {
      Common.userModel.driverPhotoModel.status = Constants.ACCEPT;
      setState(() {});
    });
    loadData();
  }

  void loadData(){
    if (Common.userModel.driverPhotoModel.status == Constants.PENDING || Common.userModel.driverPhotoModel.status == Constants.ACCEPT){
      isEditable = false;
    }else {
      isEditable = true;
    }

    frontPic = Constants.DOCUMENT_DIRECTORY_URL + Common.userModel.driverPhotoModel.photo;
  }

  void submitDriverPhoto() async{
    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);
    showProgress();
    Common.api.submitDriverPhoto(Common.userModel.id, frontPicPath).then((value) {
      closeProgress();
      if (value == APIConst.SUCCESS) {
        showSingleButtonDialog(
            context,
            'Driver photo Submitted!',
            'Your photo submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
            Constants.Okay, () {
          Navigator.pop(context);
          Navigator.pop(context);
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
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
  }


  @override
  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Row(
          children: [
            Text('Driver Photo'),
            Spacer(),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white
                ), child: Text(Utils.getStatus(Common.userModel.driverPhotoModel.status), style: TextStyle(color: AppColors.darkBlue),))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: Common.userModel.paymentDetailModel.status == Constants.REJECT,
                child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.black12
                    ),
                    child: Text(Common.userModel.driverPhotoModel.reason, style: TextStyle(color: Colors.red),)),
              ),
              Text('Photo',style:  TextStyle(fontSize: 20)),
              SizedBox(height: 10,),
              Stack(
                children: [
                  StsImgView(image: frontPic, width: double.infinity, height: 220),
                  Positioned(right: 0, bottom: 0,
                      child: FloatingActionButton(
                          mini: true,
                          heroTag: 'FAB-12',
                          backgroundColor: Colors.white,
                          onPressed: () {
                            if (isEditable){
                              loadPicture();
                            }
                          }, child: Icon(Icons.camera_alt, color: AppColors.green))),
                ],
              ),
              SizedBox(height: 20),
              Text('Requirements:', style: TextStyle(fontSize: 18, color: AppColors.darkBlue),),
              SizedBox(height: 5),
              Text(' - No hats, sunglasses, or bluetooth headsets', style: TextStyle(fontSize: 16, color: AppColors.darkBlue)),
              SizedBox(height: 5),
              Text(' - Keep entire head and both shoulders in frame', style: TextStyle(fontSize: 16, color: AppColors.darkBlue)),
              SizedBox(height: 5),
              Text(' - No blurriness', style: TextStyle(fontSize: 16, color: AppColors.darkBlue)),
              SizedBox(height: 5),
              Text(' - Good lighting and a solid background', style: TextStyle(fontSize: 16, color: AppColors.darkBlue)),
              SizedBox(height: 5),
              Text(' - Photo should be oriented horizontally like in this example', style: TextStyle(fontSize: 16, color: AppColors.darkBlue)),
              SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(value: isChecked, onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  }, checkColor: Colors.white, fillColor: MaterialStateProperty.resolveWith(getColor)),
                  Text('I have read the requirements', style: TextStyle(fontSize: 16, color: AppColors.darkBlue))
                ],
              ),
              SizedBox(height: 25),
              Visibility(
                visible: Common.userModel.driverPhotoModel.status != Constants.ACCEPT,
                child: Container(
                  width: double.infinity, height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: isEditable ? AppColors.green : Colors.black26),
                    onPressed: () {
                      if (frontPic is AssetImage){
                        showToast('Please upload front  picture of Alcohol Drug');
                        return;
                      }
                      submitDriverPhoto();
                    }, child: Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.darkBlue;
    }
    return AppColors.darkBlue;
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
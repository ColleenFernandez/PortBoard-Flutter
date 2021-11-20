import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AlcoholDrugTestDetailPage extends StatefulWidget {
  @override
  State<AlcoholDrugTestDetailPage> createState() => _AlcoholDrugTestDetailPageState();
}

class _AlcoholDrugTestDetailPageState extends State<AlcoholDrugTestDetailPage> {
  late final ProgressDialog progressDialog;
  late dynamic frontPic = Assets.DEFAULT_IMG;

  bool isEditable = false;

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.ALCOHOL_DRUG_TEST_APPROVED, (value, callback) {
      Common.userModel.alcoholDrugTestModel.status = Constants.ACCEPT;
      setState(() {});
    });

    progressDialog = ProgressDialog(context, isDismissible: false);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.green)));

    loadData();
  }

  void loadData(){
    if (Common.userModel.alcoholDrugTestModel.status == Constants.PENDING || Common.userModel.alcoholDrugTestModel.status == Constants.ACCEPT){
      isEditable = false;
    }else {
      isEditable = true;
    }

    frontPic = Constants.DOCUMENT_DIRECTORY_URL + Common.userModel.alcoholDrugTestModel.frontPic;
  }

  void submitAlcoholDrugTest() async{
    final frontPicFile = frontPic as File;
    final String frontPicPath = await FlutterAbsolutePath.getAbsolutePath(frontPicFile.path);
    await progressDialog.show();
    Common.api.submitAlcoholDrugTest(Common.userModel.id, frontPicPath).then((value) {
      progressDialog.hide();
      if (value == APIConst.SUCCESS) {
        showSingleButtonDialog(
            context,
            'Alcohol Drug Test Submitted!',
            'Your alcohol drug test submitted successfully!\nAdministrator will check it and reply you as soon as possible.',
            Constants.Okay, () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }else {
        showToast(value);
      }
    }).onError((error, stackTrace) {
      progressDialog.hide();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Row(
          children: [
            Text('Alcohol Drug Test'),
            Spacer(),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white
                ), child: Text(Utils.getStatus(Common.userModel.alcoholDrugTestModel.status), style: TextStyle(color: AppColors.darkBlue),))
          ],
        ),
      ),
      body: Column(
        children: [
          Visibility(
            visible: Common.userModel.paymentDetailModel.status == Constants.REJECT,
            child: Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12
                ),
                child: Text('here is the reject reason', style: TextStyle(color: Colors.red),)),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, top: 20),
            child: Text('Photo',style:  TextStyle(fontSize: 20)),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 30),
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
                            loadPicture();
                          }
                        }, child: Icon(Icons.camera_alt, color: AppColors.green))),
              ],),),
          Visibility(
            visible: Common.userModel.alcoholDrugTestModel.status != Constants.ACCEPT,
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: double.infinity, height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: isEditable ? AppColors.green : Colors.black26),
                onPressed: (){
                  if (frontPic is AssetImage){
                    showToast('Please upload front  picture of Alcohol Drug');
                    return;
                  }
                  submitAlcoholDrugTest();
                }, child: Text('SAVE', style: TextStyle(fontSize: 18),),
              ),
            ),
          )
        ],
      ),
    );
  }
}
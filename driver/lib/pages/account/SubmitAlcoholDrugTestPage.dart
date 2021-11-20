import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SubmitAlcoholDrugTestPage extends StatefulWidget{
  @override
  State<SubmitAlcoholDrugTestPage> createState() => _SubmitAlcoholDrugTestPageState();
}

class _SubmitAlcoholDrugTestPageState extends State<SubmitAlcoholDrugTestPage> {

  late final ProgressDialog progressDialog;
  late dynamic frontPic = Assets.DEFAULT_IMG;

  @override
  void initState() {
    super.initState();
    progressDialog = ProgressDialog(context, isDismissible: false);
    progressDialog.style(progressWidget: Container(padding: EdgeInsets.all(13), child: CircularProgressIndicator(color: AppColors.green)));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Text('Alcohol Drug Test'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, top: 20),
            child: Text('Photo',style:  TextStyle(fontSize: 20)),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 5),
            child: Stack(
              children: [
                StsImgView(image: frontPic, width: double.infinity, height: 250),
                Positioned(right: 0, bottom: 0,
                    child: FloatingActionButton(
                        mini: true,
                        heroTag: 'FAB-12',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          loadPicture();
                        }, child: Icon(Icons.camera_alt, color: AppColors.green))),
              ],),),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            width: double.infinity, height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
              onPressed: (){
                if (frontPic is AssetImage){
                  showToast('Please upload front  picture of Alcohol Drug');
                  return;
                }
                submitAlcoholDrugTest();
              }, child: Text('SAVE', style: TextStyle(fontSize: 18),),
            ),
          )
        ],
      ),
    );
  }
}
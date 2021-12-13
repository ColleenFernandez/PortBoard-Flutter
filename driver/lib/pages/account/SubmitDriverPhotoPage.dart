import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:driver/utils/utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class SubmitDriverPhotoPage extends StatefulWidget {
  @override
  State<SubmitDriverPhotoPage> createState() => _SubmitDriverPhotoPageState();
}

class _SubmitDriverPhotoPageState extends State<SubmitDriverPhotoPage> {

  late dynamic frontPic = Assets.DEFAULT_IMG;
  bool isChecked = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 1,
        title: Text('Driver Photo'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          loadPicture();
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
            Container(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: AppColors.darkBlue),
                onPressed: () {
                  if (frontPic is AssetImage){
                    showToast('Please upload front  picture of Alcohol Drug');
                    return;
                  }
                  
                  if (!isChecked){
                    showToast('Please read the requirements');
                    return;
                  }
                  submitDriverPhoto();
                }, child: Text('SAVE', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
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
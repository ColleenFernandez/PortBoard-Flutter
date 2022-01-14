import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/assets/Assets.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/utils/Utils.dart';
import 'package:driver/widget/StsImgView.dart';
import 'package:driver/widget/StsProgressHUD.dart';
import 'package:fdottedline/fdottedline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class UploadJobPicPage extends StatefulWidget {

  int imgType; // 2 chassis image
  String title;
  JobModel model;

  UploadJobPicPage(this.title, this.model, this.imgType);

  @override
  State<UploadJobPicPage> createState() => _UploadJobPicPageState();
}

class _UploadJobPicPageState extends State<UploadJobPicPage> {

  bool loading = false;
  dynamic containerPic = Assets.DEFAULT_IMG, chassisPic = Assets.DEFAULT_IMG, tirInGatePic = Assets.DEFAULT_IMG;
  dynamic tirOutGatePic = Assets.DEFAULT_IMG, sealNumberPic = Assets.DEFAULT_IMG, deliveryOrderPic = Assets.DEFAULT_IMG;

  @override
  void initState() {
    super.initState();

  }

  void uploadPic() async {
    File picFile = File('');
    if (widget.imgType == 1){
      picFile = containerPic as File;
    }
    if (widget.imgType == 2) {
      picFile = chassisPic as File;
    }
    if (widget.imgType == 3){
      picFile = tirInGatePic as File;
    }
    if (widget.imgType == 4){
      picFile = tirOutGatePic as File;
    }
    if (widget.imgType == 5){
      picFile = sealNumberPic as File;
    }
    if (widget.imgType == 6){
      picFile = deliveryOrderPic as File;
    }

    final String picFilePath = await FlutterAbsolutePath.getAbsolutePath(picFile.path);

    showProgress();
    Common.api.uploadPic(picFilePath).then((value) {
      closeProgress();

      if (value.contains('http')) {
        Navigator.pop(context, value);
      }else {
        showToast(value);
      }

    }).onError((error, stackTrace) {
      closeProgress();
      showToast('uploadPic API error');
    });
  }

  void loadPics(){
    if (widget.model.containerPic.isNotEmpty){
      containerPic = widget.model.containerPic;
    }
    if (widget.model.chassisPic.isNotEmpty){
      chassisPic = widget.model.chassisPic;
    }
    if (widget.model.tirInGatePic.isNotEmpty){
      tirInGatePic = widget.model.tirInGatePic;
    }
    if (widget.model.tirOutGatePic.isNotEmpty){
      tirOutGatePic = widget.model.tirOutGatePic;
    }
    if (widget.model.sealNumberPic.isNotEmpty){
      sealNumberPic = widget.model.sealNumberPic;
    }
    if (widget.model.deliveryOrderPic.isNotEmpty){
      deliveryOrderPic = widget.model.deliveryOrderPic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: StsProgressHUD(context, _buildWidget(context), loading));
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

    if (widget.imgType == 1){
      containerPic = croppedFile;
    }
    if (widget.imgType == 2){
      chassisPic = croppedFile;
    }
    if (widget.imgType == 3){
      tirInGatePic = croppedFile;
    }
    if (widget.imgType == 4){
      tirOutGatePic = croppedFile;
    }
    if (widget.imgType == 5) {
      sealNumberPic = croppedFile;
    }
    if (widget.imgType == 6){
      deliveryOrderPic = croppedFile;
    }

    setState(() {});
  }

  @override
  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.darkBlue,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
                children: [
                  Container(margin: EdgeInsets.only(top: 0.5), color: Colors.black12, width: double.infinity, height: 2),
                  Container(color: AppColors.green, width: 50, height: 3)]),
            Row(
              children: [
                Column(
                    children: [
                      SizedBox(height: 12),
                      Container(width: 12, height: 12,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6)), color: AppColors.darkBlue)),
                      Container(margin: EdgeInsets.only(left: 1, top: 1.5),
                          child: FDottedLine(
                              color: Colors.black38,
                              height: 42,
                              strokeWidth: 2,
                              dottedLength: 5,
                              space: 2)),
                      Container(width: 12, height: 12,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(6)),
                              color: AppColors.green))
                    ]),
                SizedBox(width: 20),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(Utils.limitStrLength(widget.model.pickupLocation, 45), style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Container(width: MediaQuery.of(context).size.width - 90, height: 1, color: Colors.black12),
                      SizedBox(height: 20),
                      Text(Utils.limitStrLength(widget.model.desLocation, 45), style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold), maxLines: 1)
                    ]),
              ],
            ),
            Divider(),
            SizedBox(height: 20,),
            Text('Container Number'),
            SizedBox(height: 5,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Row(
                children: [
                  Text('#', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  Text(Common.containerNumber),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Text('Chassis Number'),
            SizedBox(height: 5,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Row(
                children: [
                  ImageIcon(AssetImage('assets/images/bar-code.png'), size: 15,),
                  SizedBox(width: 10,),
                  Text(Common.chassisNumber),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Text('Photos of Job:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkBlue),),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        StsImgView(image: containerPic, width: MediaQuery.of(context).size.width / 3 - 20, height: 150),
                        SizedBox(height: 5,),
                        Text('Container #', style: TextStyle(fontSize: 16, color: AppColors.darkBlue),)
                      ],
                    ),
                    Positioned(
                        right: 0, bottom: 25,
                        child: FloatingActionButton.small(onPressed: () {
                          if (widget.imgType != 1){
                            Utils.checkJobPicType(widget.imgType);
                            return;
                          }
                          loadPicture();
                        }, child: Icon(Icons.photo_camera_outlined), elevation: 1,
                          backgroundColor: widget.imgType == 1 ? AppColors.green : Colors.grey,)
                    )
                  ],
                ),
                Stack(
                  children: [
                    Column(
                      children: [
                        StsImgView(image: chassisPic, width: MediaQuery.of(context).size.width / 3 - 20, height: 150),
                        SizedBox(height: 5,),
                        Text('Chassis #', style: TextStyle(fontSize: 16, color: AppColors.darkBlue),)
                      ],
                    ),
                    Positioned(
                        right: 0, bottom: 25,
                        child: FloatingActionButton.small(onPressed: () {
                          if (widget.imgType != 2){
                            Utils.checkJobPicType(widget.imgType);
                            return;
                          }
                          loadPicture();
                        }, child: Icon(Icons.photo_camera_outlined), elevation: 1,
                          backgroundColor: widget.imgType == 2 ? AppColors.green : Colors.grey,)
                    )
                  ],
                ),
                Stack(
                  children: [
                    Column(
                      children: [
                        StsImgView(image: tirInGatePic, width: MediaQuery.of(context).size.width / 3 - 20, height: 150),
                        SizedBox(height: 5,),
                        Text('TIR in gate', style: TextStyle(fontSize: 16, color: AppColors.darkBlue),)
                      ],
                    ),
                    Positioned(
                        right: 0, bottom: 25,
                        child: FloatingActionButton.small(onPressed: () {
                          if (widget.imgType != 3){
                            Utils.checkJobPicType(widget.imgType);
                            return;
                          }
                          loadPicture();
                        }, child: Icon(Icons.photo_camera_outlined), elevation: 1,
                          backgroundColor: widget.imgType == 3 ? AppColors.green : Colors.grey,)
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        StsImgView(image: tirOutGatePic, width: MediaQuery.of(context).size.width / 3 - 20, height: 150),
                        SizedBox(height: 5,),
                        Text('TIR out gate', style: TextStyle(fontSize: 16, color: AppColors.darkBlue),)
                      ],
                    ),
                    Positioned(
                        right: 0, bottom: 25,
                        child: FloatingActionButton.small(onPressed: () {
                          if (widget.imgType != 4){
                            Utils.checkJobPicType(widget.imgType);
                            return;
                          }
                          loadPicture();
                        }, child: Icon(Icons.photo_camera_outlined), elevation: 1,
                          backgroundColor: widget.imgType == 4 ? AppColors.green : Colors.grey,)
                    )
                  ],
                ),
                Stack(
                  children: [
                    Column(
                      children: [
                        StsImgView(image: sealNumberPic, width: MediaQuery.of(context).size.width / 3 - 20, height: 150),
                        SizedBox(height: 5,),
                        Text('Seal number', style: TextStyle(fontSize: 16, color: AppColors.darkBlue),)
                      ],
                    ),
                    Positioned(
                        right: 0, bottom: 25,
                        child: FloatingActionButton.small(onPressed: () {
                          if (widget.imgType != 5){
                            Utils.checkJobPicType(widget.imgType);
                            return;
                          }
                          loadPicture();
                        }, child: Icon(Icons.photo_camera_outlined), elevation: 1,
                          backgroundColor: widget.imgType == 5 ? AppColors.green : Colors.grey,)
                    )
                  ],
                ),
                Stack(
                  children: [
                    Column(
                      children: [
                        StsImgView(image: deliveryOrderPic, width: MediaQuery.of(context).size.width / 3 - 20, height: 150),
                        SizedBox(height: 5,),
                        Text('Delivery Order', style: TextStyle(fontSize: 16, color: AppColors.darkBlue),)
                      ],
                    ),
                    Positioned(
                        right: 0, bottom: 25,
                        child: FloatingActionButton.small(onPressed: () {
                          if (widget.imgType != 6){
                            Utils.checkJobPicType(widget.imgType);
                            return;
                          }
                          loadPicture();
                        }, child: Icon(Icons.photo_camera_outlined), elevation: 1,
                          backgroundColor: widget.imgType == 6 ? AppColors.green : Colors.grey,)
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 20,),
            Container(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: AppColors.green),
                onPressed: () {
                  uploadPic();
                }, child: Text('UPLOAD', style: TextStyle(fontSize: 18, color: Colors.white),),
              ),
            )
          ],
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
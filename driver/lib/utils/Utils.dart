import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Utils {

  static changeDocumentStatus(String title){

    if (title == Constants.NOTI_DRIVER_LICENSE_REJECT_TITLE) {
      Common.userModel.driverLicenseModel.status = Constants.REJECT;
      FBroadcast.instance().broadcast(Constants.DRIVER_LICENSE_REJECTED);
    }

    if (title == Constants.NOTI_ALCOHOL_DRUG_TEST_REJECT_TITLE) {
      Common.userModel.alcoholDrugTestModel.status = Constants.REJECT;
      FBroadcast.instance().broadcast(Constants.ALCOHOL_DRUG_TEST_REJECTED);
    }

    if (title == Constants.NOTI_BUSINESS_CERTIFICATION_REJECT_TITLE) {
      Common.userModel.businessCertificateModel.status = Constants.REJECT;
      FBroadcast.instance().broadcast(Constants.BUSINESS_CERTIFICATE_REJECTED);
    }

    if (title == Constants.NOTI_BUSINESS_EIN_NUMBER_REJECT_TITLE) {
      Common.userModel.businessEINModel.status = Constants.REJECT;
      FBroadcast.instance().broadcast(Constants.BUSINESS_EIN_REJECTED);
    }

    if (title == Constants.NOTI_DRIVER_PHOTO_REJECT_TITLE) {
      Common.userModel.driverPhotoModel.status = Constants.REJECT;
      FBroadcast.instance().broadcast(Constants.DRIVER_PHOTO_REJECTED);
    }

    if (title == Constants.NOTI_MEDICAL_CARD_REJECT_TITLE) {
      Common.userModel.medicalCardModel.status = Constants.REJECT;
      FBroadcast.instance().broadcast(Constants.MEDICAL_CARD_REJECTED);
    }

    if (title == Constants.NOTI_SEALINK_CARD_REJECT_TITLE) {
      Common.userModel.seaLinkCardModel.status = Constants.REJECT;
      FBroadcast.instance().broadcast(Constants.SEALINK_CARD_REJECTED);
    }

    if (title == Constants.NOTI_TWIC_CARD_REJECT_TITLE) {
      Common.userModel.twicCardModel.status = Constants.REJECT;
      FBroadcast.instance().broadcast(Constants.TWIC_CARD_REJECTED);
    }

    if (title == Constants.NOTI_PAYMENT_DETAIL_REJECT_TITLE) {
      Common.userModel.paymentDetailModel.status = Constants.REJECT;
      FBroadcast.instance().broadcast(Constants.PAYMENT_DETAIL_REJECTED);
    }

    if (title == Constants.NOTI_DRIVER_LICENSE_APPROVED_TITLE) {
      Common.userModel.driverLicenseModel.status = Constants.ACCEPT;
      FBroadcast.instance().broadcast(Constants.DRIVER_LICENSE_APPROVED);
    }

    if (title == Constants.NOTI_ALCOHOL_DRUG_TEST_APPROVED_TITLE) {
      Common.userModel.alcoholDrugTestModel.status = Constants.ACCEPT;
      FBroadcast.instance().broadcast(Constants.ALCOHOL_DRUG_TEST_APPROVED);
    }

    if (title == Constants.NOTI_BUSINESS_CERTIFICATION_APPROVED_TITLE) {
      Common.userModel.businessCertificateModel.status = Constants.ACCEPT;
      FBroadcast.instance().broadcast(Constants.BUSINESS_CERTIFICATE_APPROVED);
    }

    if (title == Constants.NOTI_BUSINESS_EIN_NUMBER_APPROVED_TITLE) {
      Common.userModel.businessEINModel.status = Constants.ACCEPT;
      FBroadcast.instance().broadcast(Constants.BUSINESS_EIN_APPROVED);
    }

    if (title == Constants.NOTI_DRIVER_PHOTO_APPROVED_TITLE) {
      Common.userModel.driverPhotoModel.status = Constants.ACCEPT;
      FBroadcast.instance().broadcast(Constants.DRIVER_PHOTO_APPROVED);
    }

    if (title == Constants.NOTI_MEDICAL_CARD_APPROVED_TITLE) {
      Common.userModel.medicalCardModel.status = Constants.ACCEPT;
      FBroadcast.instance().broadcast(Constants.MEDICAL_CARD_APPROVED);
    }

    if (title == Constants.NOTI_SEALINK_CARD_APPROVED_TITLE) {
      Common.userModel.seaLinkCardModel.status = Constants.ACCEPT;
      FBroadcast.instance().broadcast(Constants.SEALINK_CARD_APPROVED);
    }

    if (title == Constants.NOTI_TWIC_CARD_APPROVED_TITLE) {
      Common.userModel.twicCardModel.status = Constants.ACCEPT;
      FBroadcast.instance().broadcast(Constants.TWIC_CARD_APPROVED);
    }

    if (title == Constants.NOTI_PAYMENT_DETAIL_APPROVED_TITLE) {
      Common.userModel.paymentDetailModel.status = Constants.ACCEPT;
      FBroadcast.instance().broadcast(Constants.PAYMENT_DETAIL_APPROVED);
    }
  }

  static List<dynamic> sortData(dynamic allData, String sortKey){
    if (allData is List<String>){
      final List<String> temp = [];
      temp.addAll(allData);

      if (sortKey == Constants.A_TO_Z){
        temp.sort();
        return temp;
      }

      temp.sort();
      return temp.reversed.toList();
    }

    return [];
  }

  static String getStatus(int status){
    if (status == Constants.ACCEPT)
      return Constants.strAccept;

    if (status == Constants.REJECT)
      return Constants.strReject;

    if (status == Constants.PENDING)
      return Constants.strPending;

    return Constants.strNotSubmitted;
  }

  static String limitStrLength(String str, int length){
    if (str.length >  length) {
      return '${str.substring(0, length)}...';
    }
    return str;
  }

  static String dateFormat(String date){
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    var temp = date.split('-');
    return ' ${months[int.parse(temp[1])-1]} ${temp[2]}';
  }

  static Future <BitmapDescriptor> customMarker(String iconPath) async {
    ImageConfiguration configuration = ImageConfiguration();
    final bitmapImage = await BitmapDescriptor.fromAssetImage(configuration, iconPath);
    return bitmapImage;
  }

  static String getAgoFromNow(String createdAt){
    DateTime to = new DateTime.now();
    DateTime from  = DateTime.parse(createdAt);

    final diffDays = to.difference(from).inDays;

    if (diffDays > 30){
      return '${(diffDays % 30).toString()} months' ;
    }else if ( diffDays > 6){
      return '${(diffDays % 6).toString()} weeks' ;
    }

    if ( diffDays  == 0){
      return 'Today';
    }
    return '${(diffDays).toString()} days' ;
  }

  static getDate(int timeStamp){
    return DateFormat('MM/dd/yyyy').format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
  }
}

void showToast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Future<void> showSingleButtonDialog(BuildContext context, String title,  String msg, String btnTitle, Function? btnHandler()) async {

  showDialog(context: context, builder: (BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    child: Container(
      child: Column (
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Text(title, style: TextStyle(color: AppColors.darkBlue, fontSize: 18, fontWeight: FontWeight.bold),)),
          SizedBox(height: 15),
          Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Text(msg, style: TextStyle(color: AppColors.darkBlue, fontSize: 17, ))),
          Container(
            width: double.infinity, height: 0.5, color: Colors.black54, margin: EdgeInsets.only(top: 15, bottom: 5),),
          Container(
            width: double.infinity,
              child: TextButton(onPressed: btnHandler, child: Text(btnTitle, style: TextStyle(color: AppColors.green, fontSize: 20))))
        ],
      ),
    ),
  ));
}

Future<File?> cropImage(dynamic imgFile) async {

  String filePath = '';
  if (imgFile is Asset){
    final temp = imgFile as Asset;
    filePath = await FlutterAbsolutePath.getAbsolutePath((temp as Asset).identifier);
  }

  if (imgFile is XFile){
    final temp = imgFile as XFile;
    filePath = temp.path;
  }

  if (filePath.isEmpty) return null;

  try {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    return croppedFile;
  } catch (e) {
    return null;
  }
}
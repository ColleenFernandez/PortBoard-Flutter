import 'dart:io';

import 'package:driver/assets/AppColors.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/UserModel.dart';
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

  static checkJobPicType (int imgType){
    switch (imgType) {
      case 1:
        showToast('Please select Container Picture');
        break;
      case 2:
        showToast('Please select Chassis Picture');
        break;
      case 3 :
        showToast('Please select TIR in gate Picture');
        break;
      case 4:
        showToast('Please select TIR out gate Picture');
        break;
      case 5:
        showToast('Please select Seal number Picture');
        break;
      case 6:
        showToast('Please select Delivery Order Picture');
        break;
    }
  }

  static bool isAllTruckDetailVerified(UserModel userModel){

    if (userModel.truckRegistrationModel.status != Constants.ACCEPT || isExpired(userModel.truckRegistrationModel.expirationDate))
      return false;

    if (userModel.truckInsuranceModel.status != Constants.ACCEPT || isExpired(userModel.truckInsuranceModel.expirationDate))
      return false;

    if (userModel.iftaStickerModel.status != Constants.ACCEPT || isExpired(userModel.iftaStickerModel.expirationDate))
      return false;

    if (userModel.emitionInspectionModel.status != Constants.ACCEPT || isExpired(userModel.emitionInspectionModel.expirationDate))
      return false;

    /*if (userModel.truckInformationModel.status != Constants.ACCEPT || userModel.truckInformationModel.status != Constants.ACCEPT)
      return false;*/

    return true;
  }

  static bool isAllDocVerified(UserModel userModel){

    if (userModel.driverLicenseModel.status != Constants.ACCEPT || isExpired(userModel.driverLicenseModel.expirationDate))
      return false;

    if (userModel.twicCardModel.status != Constants.ACCEPT || isExpired(userModel.twicCardModel.expirationDate))
      return false;

    if (userModel.seaLinkCardModel.status != Constants.ACCEPT || isExpired(userModel.seaLinkCardModel.expirationDate))
      return false;

    if (userModel.medicalCardModel.status != Constants.ACCEPT || isExpired(userModel.medicalCardModel.expirationDate))
      return false;

    if (userModel.businessCertificateModel.status != Constants.ACCEPT || userModel.businessCertificateModel.status != Constants.ACCEPT)
      return false;

    if (userModel.businessEINModel.status != Constants.ACCEPT || userModel.businessEINModel.status != Constants.ACCEPT)
      return false;

    if (userModel.paymentDetailModel.status != Constants.ACCEPT || userModel.paymentDetailModel.status != Constants.ACCEPT)
      return false;

    if (userModel.alcoholDrugTestModel.status != Constants.ACCEPT || userModel.alcoholDrugTestModel.status != Constants.ACCEPT)
      return false;

    if (userModel.driverPhotoModel.status != Constants.ACCEPT || userModel.driverPhotoModel.status != Constants.ACCEPT)
      return false;

    return true;
  }

  static bool isUserReadyToWork(UserModel userModel) {
    return isAllDocVerified(userModel) && isAllTruckDetailVerified(userModel);
  }

  static bool isExpired(int timestamp){

    if (timestamp > DateTime.now().millisecondsSinceEpoch){
      return false;
    }
    return true;
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
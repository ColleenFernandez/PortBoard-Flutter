import 'package:driver/common/Constants.dart';
import 'package:driver/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> askLocationPermission (BuildContext context) async {

  var locationPermission = await Permission.location.status;
  if (locationPermission.isGranted){
    return true;
  }

  var pemStatus = await Permission.location.request();
  if (pemStatus.isDenied){
    showSingleButtonDialog(
        context,
        Constants.PERMISSION_ALERT,
        'You have to enable location permission to tracking your location in real-time',
        Constants.Okay, () {
          Navigator.pop(context);
          askLocationPermission(context);
    });
  } else if (pemStatus.isLimited){
    return false;
  }else if (pemStatus.isPermanentlyDenied){
    return false;
  }else if (pemStatus.isRestricted){
    return false;
  }

  return true;
}
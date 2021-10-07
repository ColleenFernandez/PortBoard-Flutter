import 'package:driver/common/APIConst.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriverLicenseModel {
  String id = '';
  String number = '';
  String state = '';
  String expiryDate = '';
  String frontPhoto = '';
  String backPhoto = '';
  String driverId = '';


  DriverLicenseModel();

  factory DriverLicenseModel.fromJSON(Map<String, dynamic> res) {
    DriverLicenseModel model = new DriverLicenseModel();
    model.id = res[APIConst.ID];
    model.number = res[APIConst.NUMBER];
    model.state = res[APIConst.STATUS];
    model.expiryDate = res[APIConst.EXPIRATION_DATE];
    model.frontPhoto = res[APIConst.PHOTO_FRONT];
    model.backPhoto = res[APIConst.PHOTO_BACK];
    model.driverId = res[APIConst.DRIVER_ID];

    return model;
  }
}
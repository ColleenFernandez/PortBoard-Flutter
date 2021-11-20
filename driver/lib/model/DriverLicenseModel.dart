import 'package:driver/common/APIConst.dart';
import 'package:flutter/material.dart';

class DriverLicenseModel {
  String driverLicense = '';
  int expirationDate = 0;
  String frontPic = '';
  String backPic = '';
  int status = 0;
  String reason = '';

  DriverLicenseModel();

  factory DriverLicenseModel.fromJSON(Map<String, dynamic> res) {
    DriverLicenseModel model = new DriverLicenseModel();
    model.driverLicense = res[APIConst.driverLicense];
    model.expirationDate = int.parse(res[APIConst.expirationDate]);
    model.frontPic = res[APIConst.frontPic];
    model.backPic = res[APIConst.backPic];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];

    return model;
  }
}
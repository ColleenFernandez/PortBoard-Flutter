import 'package:driver/common/APIConst.dart';
import 'package:flutter/cupertino.dart';

class TruckInformationModel {
  String vehiculeIDNumber = '';
  String plateNumber = '';
  String year = '';
  String make = '';
  String model = '';
  String color = '';
  String frontPic = '';
  int status = 0;
  String reason = '';

  TruckInformationModel();

  factory TruckInformationModel.fromJSON(Map<String, dynamic> res) {
    TruckInformationModel model = new TruckInformationModel();
    model.vehiculeIDNumber = res[APIConst.vehiculeIDNumber];
    model.plateNumber = res[APIConst.plateNumber];
    model.year = res[APIConst.year];
    model.make = res[APIConst.make];
    model.color = res[APIConst.color];
    model.frontPic = res[APIConst.frontPic];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];

    return model;
  }
}
import 'package:driver/common/APIConst.dart';
import 'package:flutter/material.dart';

class DriverLocationModel {
  String id = '';
  String lat = '';
  String lng = '';
  String heading = '';
  String status = '';


  DriverLocationModel();

  factory DriverLocationModel.fromJSON (Map<String, dynamic> res) {
    DriverLocationModel model = new DriverLocationModel();
    model.id = res[APIConst.id];
    model.lat = res[APIConst.lat];
    model.lng = res[APIConst.lng];
    model.heading = res[APIConst.heading];
    model.status = res[APIConst.status];

    return model;
  }
}
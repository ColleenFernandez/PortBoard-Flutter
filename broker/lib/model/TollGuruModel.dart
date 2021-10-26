import 'package:driver/common/APIConst.dart';
import 'package:flutter/material.dart';

class TollGuruModel {

  String encodedPoints = '';
  String distance = '';
  String chasisDefaultCharges = '';
  String duration = '';
  String fuelCosts = '';
  String finalPrice = '';
  String gallons = '';

  TollGuruModel();

  factory TollGuruModel.fromJSON(Map<String, dynamic> res) {

    TollGuruModel model = new TollGuruModel();
    model.encodedPoints = res[APIConst.encodedPoints];
    model.distance = res[APIConst.distance];
    model.chasisDefaultCharges = res[APIConst.chasisDefaultCharges].toString();
    model.duration = res[APIConst.duration];
    model.fuelCosts = res[APIConst.fuelCosts];
    model.finalPrice = res[APIConst.finalPrice];
    model.gallons = res[APIConst.gallons];

    return model;
  }
}
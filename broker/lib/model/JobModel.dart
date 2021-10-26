import 'package:driver/common/APIConst.dart';
import 'package:flutter/material.dart';

class JobModel {
  String id = '';
  String pickupLat = '';
  String pickupLng = '';
  String desLat = '';
  String desLng = '';
  String pickupLocation = '';
  String fromState = '';
  String desLocation = '';
  String toState = '';
  String distance = '';
  String duration = '';
  String fuelGallons = '';
  String tollsRates = '';
  String fuelSurcharge = '';
  String fuelCost = '';
  String finalPrice = '';
  String pickupDate = '';
  String dropOffDate = '';
  String pickupTime = '';
  String dropOffTime = '';
  String steamshipLine = '';
  String portLoading = '';
  String vesselName = '';
  String refNumber = '';
  String billOfLoading = '';
  String purchaseOrder = '';

  String containerNumber = '';
  String containerType = '';
  String grossWeight = '';
  String goodsType = '';
  String quantity = '';
  String loadDescription = '';
  String sealNumber = '';
  String booking = '';

  JobModel();

  factory JobModel.fromJSON(Map<String, dynamic> res){
    JobModel model = new JobModel();
    model.id = res[APIConst.id];
    model.pickupLat = res[APIConst.pickupLat];
    model.pickupLng = res[APIConst.pickupLng];
    model.desLat = res[APIConst.desLat];
    model.desLng = res[APIConst.desLng];
    model.pickupLocation = res[APIConst.pickupLocation];
    model.fromState = res[APIConst.fromState];
    model.desLocation = res[APIConst.desLocation];
    model.toState = res[APIConst.toState];
    model.distance = res[APIConst.distance];
    model.duration = res[APIConst.duration];
    model.fuelGallons = res[APIConst.fuelGallons];
    model.tollsRates = res[APIConst.tollsRates];
    model.fuelSurcharge = res[APIConst.fuelSurcharge];
    model.fuelCost = res[APIConst.fuelCost];
    model.finalPrice = res[APIConst.finalPrice];
    model.pickupDate = res[APIConst.pickupDate];
    model.dropOffDate = res[APIConst.dropOffDate];
    model.pickupTime = res[APIConst.pickupTime];
    model.dropOffTime = res[APIConst.dropOffTime];
    model.steamshipLine = res[APIConst.steamshipLine];
    model.portLoading = res[APIConst.portLoading];
    model.vesselName = res[APIConst.vesselName];
    model.refNumber = res[APIConst.refNumber];
    model.billOfLoading = res[APIConst.billOfLoading];
    model.purchaseOrder = res[APIConst.purchaseOrder];
    model.containerNumber = res[APIConst.containerNumber];
    model.containerType = res[APIConst.containerType];
    model.grossWeight = res[APIConst.grossWeight];
    model.goodsType = res[APIConst.goodsType];
    model.quantity = res[APIConst.quantity];
    model.loadDescription = res[APIConst.loadDescription];
    model.sealNumber = res[APIConst.sealNumber];
    model.booking = res[APIConst.booking];

    return model;
  }
}
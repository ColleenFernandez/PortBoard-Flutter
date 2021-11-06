import 'package:driver/common/APIConst.dart';
import 'package:flutter/rendering.dart';

class JobModel {
  int id = 0;
  int brokerId = 0;
  int shipperId = 0;
  int driverId = 0;
  int dispatcherId = 0;
  int carrierId = 0;
  double pickupLat = 0.0;
  double pickupLng = 0.0;
  double desLat = 0.0;
  double desLng = 0.0;
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
  String finalPrice = '';

  JobModel();

  factory JobModel.fromJSON(Map<String, dynamic> res) {
    JobModel model = new JobModel();
    model.id = int.parse(res[APIConst.id]);
    model.brokerId = int.parse(res[APIConst.brokerId]);
    model.shipperId = int.parse(res[APIConst.shipperId]);
    model.driverId = int.parse(res[APIConst.driverId]);
    model.dispatcherId = int.parse(res[APIConst.dispatcherId]);
    model.carrierId = int.parse(res[APIConst.carrierId]);
    model.pickupLat = double.parse(res[APIConst.pickupLat]);
    model.pickupLng = double.parse(res[APIConst.pickupLng]);
    model.desLat = double.parse(res[APIConst.desLat]);
    model.desLng = double.parse(res[APIConst.desLng]);
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
    model.pickupDate = res[APIConst.pickupDate];
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
    model.finalPrice = res[APIConst.finalPrice];

    return model;
  }
}
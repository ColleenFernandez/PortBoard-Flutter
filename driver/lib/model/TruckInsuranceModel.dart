import 'package:driver/common/APIConst.dart';
import 'package:flutter/cupertino.dart';

class TruckInsuranceModel {
  String companyName = '';
  String policyNumber = '';
  String companyPhone = '';
  int effectiveDate = 0;
  int expirationDate = 0;
  String address = '';
  String city = '';
  String state = '';
  String zipCode = '';
  int status = 0;
  String reason = '';
  String frontPic = '';

  TruckInsuranceModel();

  factory TruckInsuranceModel.fromJSON(Map<String, dynamic> res) {
    TruckInsuranceModel model = new TruckInsuranceModel();
    model.companyName = res[APIConst.companyName];
    model.policyNumber = res[APIConst.policyNumber];
    model.companyPhone = res[APIConst.companyPhone];
    model.effectiveDate = int.parse(res[APIConst.effectiveDate]);
    model.expirationDate = int.parse(res[APIConst.expirationDate]);
    model.address = res[APIConst.address];
    model.city = res[APIConst.city];
    model.state = res[APIConst.state];
    model.zipCode = res[APIConst.zipCode];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];
    model.frontPic = res[APIConst.frontPic];

    return model;
  }
}
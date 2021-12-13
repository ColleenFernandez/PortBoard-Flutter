import 'package:driver/common/APIConst.dart';
import 'package:driver/model/AlcoholDrugTestModel.dart';
import 'package:driver/model/BusinessCertificateModel.dart';
import 'package:driver/model/BusinessEINModel.dart';
import 'package:driver/model/DriverLicenseModel.dart';
import 'package:driver/model/DriverPhotoModel.dart';
import 'package:driver/model/EmitionInspectionModel.dart';
import 'package:driver/model/IFTAStickerModel.dart';
import 'package:driver/model/MedicalCardModel.dart';
import 'package:driver/model/PaymentDetailModel.dart';
import 'package:driver/model/SeaLinkCardModel.dart';
import 'package:driver/model/TruckInformationModel.dart';
import 'package:driver/model/TruckInsuranceModel.dart';
import 'package:driver/model/TruckRegistrationModel.dart';
import 'package:driver/model/TwicCardModel.dart';
import 'package:flutter/material.dart';

class UserModel {
  String id = '';
  String email = '';
  String userType = '';
  String firstName = '';
  String lastName = '';
  String gender = '';
  String phone = '';
  String status = '';
  String avatar = '';
  String lat = '';
  String lng = '';
  String heading = '';
  DriverLicenseModel driverLicenseModel = new DriverLicenseModel();
  TwicCardModel twicCardModel = new TwicCardModel();
  SeaLinkCardModel seaLinkCardModel = new SeaLinkCardModel();
  MedicalCardModel medicalCardModel = new MedicalCardModel();
  BusinessCertificateModel businessCertificateModel = new BusinessCertificateModel();
  BusinessEINModel businessEINModel = new BusinessEINModel();
  PaymentDetailModel paymentDetailModel = new PaymentDetailModel();
  AlcoholDrugTestModel alcoholDrugTestModel = new AlcoholDrugTestModel();
  DriverPhotoModel driverPhotoModel = new DriverPhotoModel();
  TruckRegistrationModel truckRegistrationModel = new TruckRegistrationModel();
  TruckInsuranceModel  truckInsuranceModel = new TruckInsuranceModel();
  IFTAStickerModel iftaStickerModel = new IFTAStickerModel();
  EmitionInspectionModel emitionInspectionModel = new EmitionInspectionModel();
  TruckInformationModel truckInformationModel = new TruckInformationModel();

  UserModel();

  factory UserModel.fromJSON (Map<String, dynamic> res) {
    UserModel model = new UserModel();
    model.id = res[APIConst.id];
    model.email = res[APIConst.email];
    model.firstName = res[APIConst.firstName];
    model.lastName = res[APIConst.lastName];
    model.gender = res[APIConst.gender];
    model.phone = res[APIConst.phone];
    model.status = res[APIConst.status];
    model.avatar = res[APIConst.avatar];
    model.userType = res[APIConst.userType];
    model.lat = res[APIConst.lat];
    model.lng = res[APIConst.lng];
    model.heading = res[APIConst.heading];

    return model;
  }

  Map<String, dynamic> toJSON() => {
    APIConst.id : id,
    APIConst.email : email,
    APIConst.userType : userType,
    APIConst.firstName : firstName,
    APIConst.lastName : lastName,
    APIConst.gender : gender,
    APIConst.phone : phone,
    APIConst.status : status,
    APIConst.avatar : avatar,
    APIConst.lat : lat,
    APIConst.lng : lng,
    APIConst.heading : heading
  };
}
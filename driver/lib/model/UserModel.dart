import 'package:driver/common/APIConst.dart';
import 'package:driver/model/DriverLicenseModel.dart';
import 'package:flutter/material.dart';

class UserModel {
  String id = '';
  String projectsIds = '';
  String email = '';
  String accountStatus = '';
  String firstName = '';
  String lastName = '';
  String gender = '';
  String title = '';
  String address = '';
  String phone = '';
  String website = '';
  String skypeId = '';
  String fb = '';
  String regDate = '';
  String typeStatus = '';
  String lastSeen = '';
  String sessionStatus = '';
  String status = '';
  String note = '';
  String city = '';
  String state = '';
  String zip = '';
  String userLanguage = '';
  String country = '';
  String usdotNumber = '';
  String mcmxNumber = '';
  String carrierId = '';
  DriverLicenseModel licenseModel = new DriverLicenseModel();

  UserModel();

  factory UserModel.fromJSON (Map<String, dynamic> res) {
    UserModel model = new UserModel();
    model.id = res[APIConst.ID];
    model.projectsIds = res[APIConst.PROJECTS_IDS];
    model.email = res[APIConst.EMAIL];
    model.accountStatus = res[APIConst.ACCOUNT_STATUS];
    model.firstName = res[APIConst.FIRST_NAME];
    model.lastName = res[APIConst.LAST_NAME];
    model.gender = res[APIConst.GENDER];
    model.title = res[APIConst.TITLE];
    model.address = res[APIConst.ADDRESS];
    model.phone = res[APIConst.PHONE];
    model.website = res[APIConst.WEBSITE];
    model.skypeId = res[APIConst.SKYPE_ID];
    model.fb = res[APIConst.FB];
    model.regDate = res[APIConst.REG_DATE];
    model.typeStatus = res[APIConst.TYPE_STATUS];
    model.lastSeen = res[APIConst.LAST_SEEN];
    model.sessionStatus = res[APIConst.SESSION_STATUS];
    model.status = res[APIConst.STATUS];
    model.note = res[APIConst.NOTE];
    model.city = res[APIConst.CITY];
    model.state = res[APIConst.STATE];
    model.zip = res[APIConst.ZIP];
    model.userLanguage = res[APIConst.USER_LANGUAGE];
    model.country = res[APIConst.COUNTRY];
    model.usdotNumber = res[APIConst.USDOT_NUMBER];
    model.mcmxNumber = res[APIConst.MCMX_NUMBER];
    model.carrierId = res[APIConst.CARRIER_ID];
    return model;
  }
}
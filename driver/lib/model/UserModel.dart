import 'package:driver/common/APIConst.dart';
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
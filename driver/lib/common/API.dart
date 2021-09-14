
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/DriverLicenseModel.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/model/TwicCardModel.dart';
import 'package:driver/model/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';


//var cookieJar=CookieJar();
//var APIManager = API.init();

class API {

  var dio = Dio();

  String baseURL = 'https://portboard.app/app_backend_api/DriverApi/';
  final header = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Future<dynamic> getAllProjects() async {
    final url = baseURL + '/getAllProjects';
    final res = await dio.post(url);
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS) {
      return msg;
    }

    final data = res.data[APIConst.jobList] as List;

    List<JobModel> allData = [];
    data.forEach((element) {
      allData.add(JobModel.fromJSON(element));
    });

    return allData;
  }

  Future<dynamic> submitTwicCard(String frontPicPath, String backPicPath, String cardNumber, String expireDate, String driverId) async {
    final url = baseURL + '/submitTwicCard';
    final params = FormData.fromMap({
      APIConst.FRONT_PICTURE : await MultipartFile.fromFile(frontPicPath),
      APIConst.BACK_PICTURE : await MultipartFile.fromFile(backPicPath),
      APIConst.CARD_NUMBER : cardNumber,
      APIConst.EXPIRATION_DATE : expireDate,
      APIConst.DRIVER_ID : driverId
    });

    final res = await dio.post(url, data: params);
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return TwicCardModel.fromJSON(res.data[APIConst.TWIC_CARD_MODEL]);
  }

  Future<dynamic> submitDriverLicense(String frontPicPath, String backPicPath, String state, String licenseNumber, String expireDate, String driverId) async {
    final url = baseURL + '/submitDriverLicense';
    final params = FormData.fromMap({
      APIConst.FRONT_PICTURE : await MultipartFile.fromFile(frontPicPath),
      APIConst.BACK_PICTURE : await MultipartFile.fromFile(backPicPath),
      APIConst.STATE : state,
      APIConst.LICENSE_NUMBER : licenseNumber,
      APIConst.EXPIRATION_DATE : expireDate,
      APIConst.DRIVER_ID : driverId
    });

    final res = await dio.post(url, data: params);
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return DriverLicenseModel.fromJSON(res.data[APIConst.LICENSE_MODEL]);
  }

  Future<dynamic> login(String phone) async{

    final url = baseURL + '/login';
    final Map<String, dynamic> params = {
      APIConst.PHONE: phone
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return UserModel.fromJSON(res.data[APIConst.USER]);
  }

  Future<dynamic> register(String phone, String firstName, String lastName, String email, String gender, String accountStatus) async {
    final url = baseURL + '/registerUserDetail';
    final params = {
      APIConst.PHONE : phone,
      APIConst.FIRST_NAME : firstName,
      APIConst.LAST_NAME : lastName,
      APIConst.EMAIL : email,
      APIConst.GENDER : gender,
      APIConst.ACCOUNT_STATUS : accountStatus,
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return UserModel.fromJSON(res.data[APIConst.USER]);
  }
}
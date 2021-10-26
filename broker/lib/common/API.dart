
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/GoodsTypeModel.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/model/LoadDescriptionModel.dart';
import 'package:driver/model/PortLoadingModel.dart';
import 'package:driver/model/TollGuruModel.dart';
import 'package:driver/model/PortModel.dart';
import 'package:driver/model/SteamshipLineModel.dart';
import 'package:driver/model/UserModel.dart';
import 'package:driver/model/VesselModel.dart';
import 'package:driver/pages/MainPage.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:flutter/material.dart';

class API {

  var dio = Dio();

  String baseURL = 'https://admin.portboard.app/index.php/BrokerApi/';
  final header = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Future<String> postJob(JobModel model) async {

    final url = baseURL + '/postJob';
    final Map<String, dynamic> params = {
      APIConst.pickupLat : model.pickupLat,
      APIConst.pickupLng : model.pickupLng,
      APIConst.desLat : model.desLat,
      APIConst.desLng : model.desLng,
      APIConst.pickupLocation : model.pickupLocation,
      APIConst.fromState : model.fromState,
      APIConst.desLocation : model.desLocation,
      APIConst.toState : model.toState,
      APIConst.distance : model.distance,
      APIConst.duration : model.duration,
      APIConst.fuelGallons : model.fuelGallons,
      APIConst.tollsRates : model.tollsRates,
      APIConst.fuelSurcharge : model.fuelSurcharge,
      APIConst.fuelCost : model.fuelCost,
      APIConst.finalPrice : model.finalPrice,
      APIConst.pickupDate : model.pickupDate,
      APIConst.dropOffDate : model.dropOffDate,
      APIConst.pickupTime : model.pickupTime,
      APIConst.dropOffTime : model.dropOffTime,
      APIConst.steamshipLine : model.steamshipLine,
      APIConst.portLoading : model.portLoading,
      APIConst.vesselName : model.vesselName,
      APIConst.refNumber : model.refNumber,
      APIConst.billOfLoading : model.billOfLoading,
      APIConst.purchaseOrder : model.purchaseOrder,
      APIConst.containerNumber :  model.containerNumber,
      APIConst.containerType : model.containerType,
      APIConst.grossWeight : model.grossWeight,
      APIConst.goodsType : model.goodsType,
      APIConst.quantity : model.quantity,
      APIConst.loadDescription : model.loadDescription,
      APIConst.sealNumber : model.sealNumber,
      APIConst.booking : model.booking
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.NETWORK_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return APIConst.SUCCESS;
  }

  Future<dynamic> callTollGuruAPI(String from, String stateFrom, String to, String zipcode) async {

    final url = baseURL + '/callTollGuruAPI';

    final Map<String, dynamic> params = {
      APIConst.from : from,
      APIConst.stateFrom : stateFrom,
      APIConst.to : to,
      APIConst.zipcode : zipcode,
      APIConst.terminalType : 'drayage'
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.NETWORK_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return  TollGuruModel.fromJSON(res.data[APIConst.result] as Map<String, dynamic>);
  }

  Future<String> getRouteAPI(double pickupLat, double pickupLng, double desLat, double desLng) async {
    String directionUrl = 'https://maps.googleapis.com/maps/api/directions/json?origin=${pickupLat},${pickupLng}&destination=${desLat},${desLng}&key=${Constants.googleAPIKey}';
    final result = await dio.get(directionUrl);

    final String encodedPoint = result.data[APIConst.routes][0][APIConst.overview_polyline][APIConst.points];
    return  encodedPoint;
  }

  Future<dynamic> getDetailForTollGuru(String id, String stateCode, String lat, String lng) async {
    final url = baseURL + '/getDetailForTollGuru';
    final Map<String, dynamic> params = {
      APIConst.id : id,
      APIConst.stateCode : stateCode,
      APIConst.lat : lat,
      APIConst.lng : lng
    };
    final res = await dio.post(url, data: params , options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.NETWORK_ERROR;
    }

    return {
      APIConst.fuelPrice : res.data[APIConst.fuelPrice],
      APIConst.mpg : res.data[APIConst.mpg],
      APIConst.state : res.data[APIConst.state],
      APIConst.address : res.data[APIConst.address],
      APIConst.zipcode : res.data[APIConst.zipcode]
    };
  }

  Future<dynamic> mainPageAPI() async {
    final url = baseURL + '/mainPageAPI';

    final res = await dio.post(url, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.NETWORK_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return  {
      APIConst.steamshipLineList : SteamShipLineModel().getSteamshipList(res.data[APIConst.steamshipLineList]  as List),
      APIConst.portList : PortModel().getPortList(res.data[APIConst.portList] as List),
      APIConst.portLoadings : PortLoadingModel().getList(res.data[APIConst.portLoadings] as List),
      APIConst.vesselList : VesselModel().getList(res.data[APIConst.vesselList] as List),
      APIConst.goodsList : GoodsTypeModel().getList(res.data[APIConst.goodsList] as List),
      APIConst.loadDescriptionList : LoadDescriptionModel().getList(res.data[APIConst.loadDescriptionList] as List)
    };
  }
  Future<dynamic> getPortList() async {
    final url = baseURL + '/getPortList';

    final res = await dio.post(url, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.NETWORK_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return PortModel().getPortList(res.data[APIConst.portList] as List);
  }

  Future<dynamic> login(String phone) async{

    final url = baseURL + '/login';
    final Map<String, dynamic> params = {
      APIConst.phone: phone
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.NETWORK_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return UserModel.fromJSON(res.data[APIConst.user]);
  }

  Future<dynamic> register(String phone, String firstName, String lastName, String email, String gender, String userType) async {
    final url = baseURL + '/registerUserDetail';
    final params = {
      APIConst.phone : phone,
      APIConst.firstName : firstName,
      APIConst.lastName : lastName,
      APIConst.email : email,
      APIConst.gender : gender,
      APIConst.userType : userType,
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.NETWORK_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return UserModel.fromJSON(res.data[APIConst.user]);
  }
}
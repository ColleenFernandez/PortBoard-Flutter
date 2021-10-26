import 'dart:async';

import 'package:driver/common/API.dart';
import 'package:driver/model/GoodsTypeModel.dart';
import 'package:driver/model/LoadDescriptionModel.dart';
import 'package:driver/model/PortLoadingModel.dart';
import 'package:driver/model/PortModel.dart';
import 'package:driver/model/SteamshipLineModel.dart';
import 'package:driver/model/UserModel.dart';
import 'package:driver/model/VesselModel.dart';

class Common {
  static API api = new API();
  static UserModel userModel = new UserModel();
  static double myLat = 0.0;
  static double myLng = 0.0;

  static List<SteamShipLineModel> steamshipLine = [];
  static List<PortModel> portList = [];
  static List<PortLoadingModel> portLoadings = [];
  static List<VesselModel> vesselList = [];
  static List<GoodsTypeModel> goodsList = [];
  static List<LoadDescriptionModel> loadDescriptionList = [];
}
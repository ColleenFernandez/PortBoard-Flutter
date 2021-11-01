import 'package:driver/common/APIConst.dart';
import 'package:flutter/cupertino.dart';

class SteamShipLineModel {
  String id = '';
  String name = '';
  String detail = '';

  SteamShipLineModel();

  factory SteamShipLineModel.fromJSON (Map<String, dynamic> res) {
    SteamShipLineModel model = new SteamShipLineModel();
    model.id = res[APIConst.id];
    model.name = res[APIConst.name];
    model.detail = res[APIConst.detail];

    return model;
  }

  List<SteamShipLineModel> getSteamshipList(List<dynamic> res) {
    List<SteamShipLineModel> allData = [];
    res.forEach((element) {
      allData.add(SteamShipLineModel.fromJSON(element));
    });

    return allData;
  }
}
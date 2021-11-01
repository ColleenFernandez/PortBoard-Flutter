import 'dart:io';

import 'package:driver/common/APIConst.dart';

class PortModel {
  String id = '';
  String name = '';
  String address = '';
  String state = '';
  String phone = '';
  String lng = '';
  String lat = '';
  String email = '';
  String website = '';
  String instagram = '';
  String facebook = '';
  String twitter = '';
  String about = '';
  String photo1 = '';
  String photo2 = '';
  String photo3 = '';
  String photo4 = '';
  String zipCode = '';
  bool isSelected = false;


  PortModel();

  factory PortModel.fromJSON(Map<String, dynamic> res){
    PortModel model = new PortModel();
    model.id = res[APIConst.id];
    model.name = res[APIConst.name];
    model.address = res[APIConst.address];
    model.state = res[APIConst.state];
    model.phone = res[APIConst.phone];
    model.lat = res[APIConst.lat];
    model.lng = res[APIConst.lng];
    model.email = res[APIConst.email];
    model.website = res[APIConst.website];
    model.instagram = res[APIConst.instagram];
    model.facebook = res[APIConst.facebook];
    model.twitter = res[APIConst.twitter];
    model.about = res[APIConst.about];
    model.photo1 = res[APIConst.photo1];
    model.photo2 = res[APIConst.photo2];
    model.photo3 = res[APIConst.photo3];
    model.photo4 = res[APIConst.photo4];
    model.zipCode = res[APIConst.zipcode];

    return model;
  }

  List<PortModel> getPortList(List<dynamic> res){
    List<PortModel> allData = [];
    res.forEach((element) {
      PortModel model = new PortModel.fromJSON(element);
      allData.add(model);
    });

    return allData;
  }
}
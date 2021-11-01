import 'package:driver/assets/Assets.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/GoodsTypeModel.dart';
import 'package:driver/model/LoadDescriptionModel.dart';
import 'package:driver/model/PortLoadingModel.dart';
import 'package:driver/model/PortModel.dart';
import 'package:driver/model/SteamshipLineModel.dart';
import 'package:driver/model/VesselModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Utils {

  static List<String> grossWeightList() {
    List<String> result = [];
    for (int i = 1; i < 51; i++){
      result.add('${i}K');
    }
    return result;
  }

  static List<dynamic> sortData (dynamic allData, String sortKey) {

    if (allData is List<LoadDescriptionModel>) {
      if (sortKey == Constants.A_TO_Z){
        allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
        return allData;
      }

      allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      final temp = allData.reversed.toList();
      return temp;
    }

    if (allData is List<GoodsTypeModel>) {
      if (sortKey == Constants.A_TO_Z){
        allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
        return allData;
      }

      allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      final temp = allData.reversed.toList();
      return temp;
    }

    if (allData is List<VesselModel>) {
      if (sortKey == Constants.A_TO_Z){
        allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
        return allData;
      }

      allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      final temp = allData.reversed.toList();
      return temp;
    }

    if (allData is List<PortLoadingModel>) {
      if (sortKey == Constants.A_TO_Z){
        allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
        return allData;
      }

      allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      final temp = allData.reversed.toList();
      return temp;
    }

    if (allData is List<SteamShipLineModel>) {
      if (sortKey == Constants.A_TO_Z){
        allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
        return allData;
      }

      allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      final temp = allData.reversed.toList();
      return temp;
    }

    if (allData is List<PortModel>){
      if (sortKey == Constants.A_TO_Z){
        allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
        return allData;
      }

      allData.sort((a, b) => a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()));
      final temp = allData.reversed.toList();
      return temp;
    }

    if (allData is List<String>){
      final List<String> temp = [];
      temp.addAll(allData);

      if (sortKey == Constants.A_TO_Z){
        temp.sort();
        return temp;
      }

      temp.sort();
      return temp.reversed.toList();
    }

    return [];
  }

  static String adjustedString30(String str) {
    if (str.length > 30) {
      return '${str.substring(0, 30)}...';
    }
    return str;
  }
  static String adjustedString17(String str) {
    if (str.length > 17) {
      return '${str.substring(0, 17)}...';
    }
    return str;
  }

  static Future <BitmapDescriptor> myLocationMarkerIcon() async {
    ImageConfiguration configuration = ImageConfiguration();
    final bitmapImage = await BitmapDescriptor.fromAssetImage(configuration, Assets.MY_LOCATION_MARKER_PATH);
    return bitmapImage;
  }

  static Future <BitmapDescriptor> customMarker(String iconPath) async {
    ImageConfiguration configuration = ImageConfiguration();
    final bitmapImage = await BitmapDescriptor.fromAssetImage(configuration, iconPath);
    return bitmapImage;
  }
}

void showToast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Future<void> showAlertDialog(BuildContext context, String msg) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('AlertDialog'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(msg),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay', style: TextStyle(color: Colors.black87),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
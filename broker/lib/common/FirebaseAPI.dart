import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/DriverLocationModel.dart';
import 'package:driver/model/UserModel.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:fbroadcast/fbroadcast.dart';

const String TB_DRIVER = 'tb_driver';
CollectionReference fbDriver = FirebaseFirestore.instance.collection(TB_DRIVER);

class FirebaseAPI {
  static Future<List<DriverLocationModel>> getOnlineDriverList() async{

    List<DriverLocationModel> allData = [];

    await fbDriver.where(APIConst.status, isEqualTo: '1').get().then((value) {
      if (value.docs.isNotEmpty){
        value.docs.forEach((element) {
          DriverLocationModel model = new DriverLocationModel.fromJSON(element.data() as Map<String, dynamic>);
          allData.add(model);
        });
      }
    });

    return allData;
  }
}
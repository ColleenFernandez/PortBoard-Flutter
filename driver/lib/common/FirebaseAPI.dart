
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/model/UserModel.dart';

const String TB_DRIVER = 'tb_driver';
CollectionReference fbUser = FirebaseFirestore.instance.collection(TB_DRIVER);

class FirebaseAPI {

  static Future<bool> registerUser(UserModel model) async {
    bool result = false;
    final data = {
      APIConst.id : model.id,
      APIConst.status : model.status,
      APIConst.lat : model.lat,
      APIConst.lng : model.lng,
      APIConst.heading : model.heading
    };
    await fbUser.doc(model.id).set(data).then((value) {
      result = true;
    }).catchError((error) {
      result = false;
    });
    return result;
  }

  static Future<bool> changeUserStatus(String userId, bool status) async {
    bool result = false;

    Map<String, dynamic> update = {
      APIConst.status : status
    };
    await fbUser.doc(userId).update(update).then((value) => {
      result = true
    }).catchError((error) => {
      result = false
    });

    return result;
  }

  static Future<bool> updateLocation(String userId, String lat, String lng, String heading) async {
    bool result = false;

    Map<String, dynamic> update = {
      APIConst.lat : lat,
      APIConst.lng : lng,
      APIConst.heading : heading
    };

    await fbUser.doc(userId).update(update).then((value) => {
      result = true
    }).catchError((error) => {
      result = false
    });

    return result;
  }
}
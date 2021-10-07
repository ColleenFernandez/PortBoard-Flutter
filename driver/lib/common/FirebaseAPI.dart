
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/model/UserModel.dart';

const String TB_DRIVER = 'tb_driver';
CollectionReference fbUser = FirebaseFirestore.instance.collection(TB_DRIVER);

class FirebaseAPI {

  static Future<bool> registerUser(UserModel model) async {
    bool result = false;
    await fbUser.doc(model.id).set(model.toJSON()).then((value) {
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

  static Future<bool> updateLocation(String userId, double lat, double lng) async {
    bool result = false;

    Map<String, dynamic> update = {
      APIConst.lat : lat,
      APIConst.lng : lng
    };
    await fbUser.doc(userId).update(update).then((value) => {
      result = true
    }).catchError((error) => {
      result = false
    });

    return result;
  }
}
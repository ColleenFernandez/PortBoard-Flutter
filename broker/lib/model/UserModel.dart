import 'package:driver/common/APIConst.dart';

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

  UserModel();

  factory UserModel.fromJSON (Map<String, dynamic> res) {
    UserModel model = new UserModel();
    model.id = res[APIConst.id];
    model.email = res[APIConst.email];
    model.userType = res[APIConst.userType];
    model.firstName = res[APIConst.firstName];
    model.lastName = res[APIConst.lastName];
    model.gender = res[APIConst.gender];
    model.phone = res[APIConst.phone];
    model.status = res[APIConst.status];
    model.avatar = res[APIConst.avatar];
    model.lat = res[APIConst.lat];
    model.lng = res[APIConst.lng];

    return model;
  }
}
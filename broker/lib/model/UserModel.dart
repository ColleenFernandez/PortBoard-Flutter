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

  UserModel();

  factory UserModel.fromJSON (Map<String, dynamic> res) {
    UserModel model = new UserModel();
    model.id = res[APIConst.ID];
    model.email = res[APIConst.EMAIL];
    model.userType = res[APIConst.ACCOUNT_STATUS];
    model.firstName = res[APIConst.FIRST_NAME];
    model.lastName = res[APIConst.LAST_NAME];
    model.gender = res[APIConst.GENDER];
    model.phone = res[APIConst.PHONE];
    model.status = res[APIConst.STATUS];
    return model;
  }
}
import 'package:driver/common/APIConst.dart';

class TruckRegistrationModel{
  String companyName = '';
  String accountNumber = '';
  String plateNumber = '';
  String usdotNumber = '';
  int expirationDate = 0;
  String address = '';
  String city = '';
  String state = '';
  String zipCode = '';
  String frontPic = '';
  int status = 0;
  String reason = '';

  TruckRegistrationModel();

  factory TruckRegistrationModel.fromJSON(Map<String, dynamic> res) {
    TruckRegistrationModel model = new TruckRegistrationModel();
    model.companyName = res[APIConst.companyName];
    model.accountNumber = res[APIConst.accountNumber];
    model.plateNumber = res[APIConst.plateNumber];
    model.usdotNumber = res[APIConst.usdotNumber];
    model.expirationDate = int.parse(res[APIConst.expirationDate]);
    model.address = res[APIConst.address];
    model.city = res[APIConst.city];
    model.state = res[APIConst.state];
    model.zipCode = res[APIConst.zipCode];
    model.frontPic = res[APIConst.frontPic];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];

    return model;
  }
}
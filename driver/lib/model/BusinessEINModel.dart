import 'package:driver/common/APIConst.dart';

class BusinessEINModel {
  String legalName = '';
  String einNumber = '';
  int issuedDate = 0;
  String address = '';
  String city = '';
  String state = '';
  String zipCode = '';
  String frontPic = '';
  String reason = '';
  int status = 0;

  BusinessEINModel();

  factory BusinessEINModel.fromJSON(Map<String, dynamic> res) {
    BusinessEINModel model = new BusinessEINModel();
    model.legalName = res[APIConst.legalName];
    model.einNumber = res[APIConst.businessEINNumber];
    model.issuedDate = int.parse(res[APIConst.issuedDate]);
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
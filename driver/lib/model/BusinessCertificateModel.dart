import 'package:driver/common/APIConst.dart';

class BusinessCertificateModel {
  String legalName = '';
  String registeredName = '';
  int issuedDate = 0;
  String address = '';
  String city = '';
  String state = '';
  String zipCode = '';
  String frontPic = '';
  int status = 0;
  String reason = '';

  BusinessCertificateModel();

  factory BusinessCertificateModel.fromJSON(Map<String, dynamic> res) {
    BusinessCertificateModel model = new BusinessCertificateModel();
    model.legalName = res[APIConst.legalName];
    model.registeredName = res[APIConst.registeredName];
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
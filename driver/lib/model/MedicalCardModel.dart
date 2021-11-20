import 'package:driver/common/APIConst.dart';

class MedicalCardModel {
  int issuedDate = 0;
  int expirationDate = 0;
  String frontPic = '';
  String backPic = '';
  int status = 0;
  String reason = '';

  MedicalCardModel();

  factory MedicalCardModel.fromJSON(Map<String, dynamic> res) {
    MedicalCardModel model = new MedicalCardModel();
    model.expirationDate = int.parse(res[APIConst.expirationDate]);
    model.issuedDate = int.parse(res[APIConst.issuedDate]);
    model.frontPic = res[APIConst.frontPic];
    model.backPic = res[APIConst.backPic];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];
    return model;
  }
}
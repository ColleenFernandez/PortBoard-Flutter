import 'package:driver/common/APIConst.dart';

class AlcoholDrugTestModel {
  String frontPic = '';
  int status = 0;
  String reason = '';

  AlcoholDrugTestModel();

  factory AlcoholDrugTestModel.fromJSON(Map<String, dynamic> res) {
    AlcoholDrugTestModel model = new AlcoholDrugTestModel();
    model.frontPic = res[APIConst.frontPic];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];
    return model;
  }
}
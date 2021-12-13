import 'package:driver/common/APIConst.dart';

class EmitionInspectionModel {
  String ispectionNumber = '';
  String state = '';
  int expirationDate = 0;
  String frontPic = '';
  int status = 0;
  String reason = '';

  EmitionInspectionModel();

  factory EmitionInspectionModel.fromJSON(Map<String, dynamic> res) {
    EmitionInspectionModel model = new EmitionInspectionModel();
    model.ispectionNumber = res[APIConst.inspectionNumber];
    model.state = res[APIConst.state];
    model.expirationDate = int.parse(res[APIConst.expirationDate]);
    model.frontPic = res[APIConst.frontPic];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];

    return model;
  }
}
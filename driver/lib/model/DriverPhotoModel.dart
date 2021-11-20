import 'package:driver/common/APIConst.dart';

class DriverPhotoModel {
  String photo = '';
  int status = 0;
  String reason = '';

  DriverPhotoModel();

  factory DriverPhotoModel.fromJSON(Map<String, dynamic> res) {
    DriverPhotoModel model = new DriverPhotoModel();
    model.photo = res[APIConst.photo];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];

    return model;
  }
}
import 'package:driver/common/APIConst.dart';

class TwicCardModel {
  String id = '';
  String number = '';
  String expiryDate = '';
  String frontPhoto = '';
  String backPhoto = '';
  String driverId = '';

  TwicCardModel();

  factory TwicCardModel.fromJSON(Map<String, dynamic> res){
    TwicCardModel model = new TwicCardModel();
    model.id = res[APIConst.ID];
    model.number = res[APIConst.NUMBER];
    model.expiryDate = res[APIConst.EXPIRATION_DATE];
    model.frontPhoto = res[APIConst.PHOTO_FRONT];
    model.backPhoto = res[APIConst.PHOTO_BACK];
    model.driverId = res[APIConst.DRIVER_ID];

    return model;
  }
}
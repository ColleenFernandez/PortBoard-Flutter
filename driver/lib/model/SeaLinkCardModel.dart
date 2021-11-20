import 'package:driver/common/APIConst.dart';

class SeaLinkCardModel {
  String cardNumber = '';
  int expirationDate = 0;
  String frontPic = '';
  String backPic = '';
  int status = 0;
  String reason = '';

  SeaLinkCardModel();

  factory SeaLinkCardModel.fromJSON(Map<String, dynamic> res) {
    SeaLinkCardModel model = new SeaLinkCardModel();
    model.cardNumber = res[APIConst.cardNumber];
    model.expirationDate = int.parse(res[APIConst.expirationDate]);
    model.frontPic = res[APIConst.frontPic];
    model.backPic = res[APIConst.backPic];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];
    return model;
  }
}
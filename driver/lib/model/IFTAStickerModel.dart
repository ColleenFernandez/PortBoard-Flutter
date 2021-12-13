import 'package:driver/common/APIConst.dart';

class IFTAStickerModel {
  String iftaStickerNumber = '';
  String state = '';
  int expirationDate = 0;
  String frontPic = '';
  int status = 0;
  String reason = '';

  IFTAStickerModel();

  factory IFTAStickerModel.fromJSON(Map<String, dynamic> res){
    IFTAStickerModel model = new IFTAStickerModel();
    model.iftaStickerNumber = res[APIConst.iftaStickerNumber];
    model.state = res[APIConst.state];
    model.expirationDate = int.parse(res[APIConst.expirationDate]);
    model.frontPic = res[APIConst.frontPic];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];


    return model;
  }
}
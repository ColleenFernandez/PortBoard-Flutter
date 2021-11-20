import 'package:driver/common/APIConst.dart';

class PaymentDetailModel {
  String bankName = '';
  String accountNumber =  '';
  String routing = '';
  String phone = '';
  String address = '';
  String city = '';
  String state = '';
  String zipCode = '';
  int status = 0;
  String reason = '';

  PaymentDetailModel();

  factory PaymentDetailModel.fromJSON(Map<String, dynamic> res) {
    PaymentDetailModel model = new PaymentDetailModel();
    model.bankName = res[APIConst.bankName];
    model.accountNumber = res[APIConst.accountNumber];
    model.routing = res[APIConst.routing];
    model.phone = res[APIConst.phone];
    model.address = res[APIConst.address];
    model.city = res[APIConst.city];
    model.state = res[APIConst.state];
    model.zipCode = res[APIConst.zipCode];
    model.status = int.parse(res[APIConst.status]);
    model.reason = res[APIConst.reason];

    return model;
  }
}
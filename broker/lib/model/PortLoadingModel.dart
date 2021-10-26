import 'package:driver/common/APIConst.dart';

class PortLoadingModel {
  String id = '';
  String name = '';
  String detail = '';

  PortLoadingModel();

  factory PortLoadingModel.fromJSON(Map<String, dynamic> res) {
    PortLoadingModel model = new PortLoadingModel();
    model.id = res[APIConst.id];
    model.name = res[APIConst.name];
    model.detail = res[APIConst.detail];
    return model;
  }

  List<PortLoadingModel> getList(List<dynamic> res) {
    List<PortLoadingModel> allData = [];
    res.forEach((element) {
      PortLoadingModel model = PortLoadingModel.fromJSON(element as Map<String, dynamic>);
      allData.add(model);
    });
    return allData;
  }
}
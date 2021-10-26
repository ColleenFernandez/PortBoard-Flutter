import 'package:driver/common/APIConst.dart';

class GoodsTypeModel {
  String id = '';
  String name = '';

  GoodsTypeModel();

  factory GoodsTypeModel.fromJSON(Map<String, dynamic> res) {
    GoodsTypeModel model = new GoodsTypeModel();
    model.id = res[APIConst.id];
    model.name = res[APIConst.name];

    return model;
  }

  List<GoodsTypeModel> getList(List<dynamic> res) {
    List<GoodsTypeModel> allData = [];

    res.forEach((element) {
      allData.add(new GoodsTypeModel.fromJSON(element as Map<String , dynamic>));
    });
    return allData;
  }
}
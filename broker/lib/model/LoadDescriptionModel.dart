import 'package:driver/common/APIConst.dart';

class LoadDescriptionModel {
  String id = '';
  String name = '';

  LoadDescriptionModel();

  factory LoadDescriptionModel.fromJSON(Map<String, dynamic> res) {
    LoadDescriptionModel model = new LoadDescriptionModel();
    model.id = res[APIConst.id];
    model.name = res[APIConst.name];

    return model;
  }

  List<LoadDescriptionModel> getList(List<dynamic> res) {
    List<LoadDescriptionModel> allData = [];
    res.forEach((element) {
      allData.add(new LoadDescriptionModel.fromJSON(element as Map<String, dynamic>));
    });
    return allData;
  }
}
import 'package:driver/common/APIConst.dart';

class VesselModel {
  String id = '';
  String name = '';

  VesselModel();

  factory VesselModel.fromJSON(Map<String, dynamic> res){
    VesselModel model = new VesselModel();
    model.id = res[APIConst.id];
    model.name = res[APIConst.name];
    return model;
  }

  List<VesselModel> getList(List<dynamic> res) {
    List<VesselModel> allData = [];
    res.forEach((element) {
      VesselModel model = VesselModel.fromJSON(element as Map<String, dynamic>);
      allData.add(model);
    });
    return allData;
  }
}
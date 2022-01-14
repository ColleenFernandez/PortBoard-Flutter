class ChassisTypeModel {
  int id = 0;
  String type = "";

  ChassisTypeModel();

  factory ChassisTypeModel.fromJSON(Map<String, dynamic> res) {
    ChassisTypeModel model = ChassisTypeModel();
    model.id = int.parse(res['id']);
    model.type = res['type'];
    return model;
  }

  List<ChassisTypeModel> getList(List<dynamic> res) {

    List<ChassisTypeModel> allData = [];

    res.forEach((element) {
      allData.add(new ChassisTypeModel.fromJSON(element as Map<String, dynamic>));
    });

    return allData;
  }
}
class CompanyChassisModel {
  int id = 0;
  String companyChassis = '';

  CompanyChassisModel();

  factory CompanyChassisModel.fromJSON(Map<String, dynamic> res) {
    CompanyChassisModel  model = CompanyChassisModel();
    model.id = int.parse(res['id']);
    model.companyChassis = res['companyChassis'];
    return model;
  }

  List<CompanyChassisModel> getList(List<dynamic> res) {
    List<CompanyChassisModel> allData = [];
    res.forEach((element) {
      allData.add(new CompanyChassisModel.fromJSON(element as Map<String, dynamic>));
    });
    return allData;
  }
}
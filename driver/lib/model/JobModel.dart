import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Constants.dart';

class JobModel {
  String p_id = '';
  String c_id = '';
  String s_ids = '';
  String project_title = '';
  String project_desc = '';
  String budget = '';
  String status = '';
  String archive = '';
  String trash = '';
  String start_time = '';
  String end_time = '';
  String pickup_address = '';
  String dropoff_address = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String distance_goin = '';
  String distance_return = '';
  String estimated_time_goin = '';
  String estimated_time_return = '';
  String fuel_gallons_goin = '';
  String fuel_gallons_return = '';
  String fuel_costs_goin = '';
  String fuel_costs_return = '';
  String tolls_rates_goin = '';
  String tolls_rates_return = '';
  String estimated_price = '';
  String estimated_price_driver = '';
  String percent_platform = '';
  String state_from = '';
  String state_to = '';
  String steamship_line = '';
  String port_terminal = '';
  String pickup_date = '';
  String dropoff_date = '';
  String pickup_time = '';
  String dropoff_time = '';
  String port_loading = '';
  String reference_number = '';
  String vessel_name = '';
  String purchase_order = '';
  String container_number = '';
  String container_type = '';
  String chasis_number = '';
  String chasis_company = '';
  String load_type = '';
  String gross_weight = '';
  String goods_type = '';
  String container_quantity = '';
  String load_description = '';
  String seal_number = '';
  String bill_of_lading_number = '';
  String booking = '';
  String sender_name = '';
  String sender_email = '';
  String sender_phone = '';
  String sender_cell_phone = '';
  String receiver_name = '';
  String receiver_email = '';
  String receiver_phone = '';
  String receiver_cell_phone = '';
  String assigned_dispatchers = '';
  String driver = '';
  String shipper = '';
  String broker = '';
  String photo_1 = '';
  String photo_2 = '';
  String photo_3 = '';
  String photo_4 = '';
  String photo_5 = '';
  String photo_6 = '';
  String photo_7 = '';
  String photo_8 = '';
  String photo_9 = '';
  String photo_10 = '';
  String photo_11 = '';
  String photo_12 = '';
  String status_financial = '';
  String status_factoring = '';
  String percent_fuel = '';
  String city_congestion_fee = '';
  String city_congestion_fee_zipcode = '';
  String terminal_type = '';
  String job_type = '';
  String status_dry_ref = '';
  String reefer_jense = '';
  String reefer_temp_terminal = '';
  String reefer_temp_yard = '';
  String reefer_temp_delivered = '';
  String states_over_weight_permit = '';
  String scale_empty = '';
  String scale_load = '';
  String created_by = '';
  String created_at = '';
  String last_updated_by = '';
  String last_updated_at = '';
  String last_updated_financial_by = '';
  String last_updated_financial_at = '';
  bool isSelected = false;


  JobModel();

  factory JobModel.fromJSON(Map<String, dynamic> res) {
    JobModel model = new JobModel();

    model.p_id = res[APIConst.p_id];

    String strLat = res[APIConst.latitude];
    if (strLat.isNotEmpty){
      model.latitude = double.parse(res[APIConst.latitude]);
    }else {
      model.latitude = 0.0;
    }

    String strLng = res[APIConst.longitude];
    if (strLng.isNotEmpty) {
      model.longitude = double.parse(res[APIConst.longitude]);
    }else {
      model.longitude = 0.0;
    }

    String price = res[APIConst.estimated_price_driver];
    if (!price.contains('.')){
      price += '.00';
    }

    model.estimated_price_driver = price;

    model.state_from = res[APIConst.state_from];
    model.created_at = res[APIConst.created_at];

    return model;
  }

  List<JobModel> getList(List<dynamic> data) {
    List<JobModel> allData = [];
    data.forEach((element) {
      allData.add(JobModel.fromJSON(element));
    });
    return allData;
  }
}

import 'package:driver/common/API.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/model/UserModel.dart';
import 'package:driver/service/BackgroundLocationService.dart';

class Common {
  static UserModel userModel = new UserModel();
  static API api = new API();
  static BackgroundLocationService locationService = new BackgroundLocationService();
  static double myLat = 0.0;
  static double myLng = 0.0;
  static double heading = 0.0;
  static String fcmToken = '';
  static JobModel jobRequest = new JobModel();
  static JobModel myJob = new JobModel();
  static bool isMainPageLoaded = false;
  static String chassisNumber = '';
  static String containerNumber = '';
}
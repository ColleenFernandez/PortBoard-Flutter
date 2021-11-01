import 'package:background_location/background_location.dart';
import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:fbroadcast/fbroadcast.dart';

class BackgroundLocationService {
  void init(){
    BackgroundLocation.setAndroidNotification(
      title: "PortBoard-Driver",
      message: "You are online",
      icon: "assets/images/logo.png",
    );

    BackgroundLocation.setAndroidConfiguration(5000);
  }

  void start(){
    BackgroundLocation.startLocationService();

    BackgroundLocation.getLocationUpdates((p0) {
      Common.myLat = p0.latitude!;
      Common.myLng = p0.longitude!;
      FBroadcast.instance().broadcast(Constants.LOCATION_UPDATE, value: p0);
    });
  }

  void stop(){
    BackgroundLocation.stopLocationService();
  }
}
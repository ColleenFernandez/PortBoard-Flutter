import 'dart:async';

import 'package:driver/common/Constants.dart';
import 'package:driver/utils/log_utils.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {

  static StreamSubscription<Position>? positionStreamSubscription;
  static GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  static start() async {
    final positionStream = _geolocatorPlatform.getPositionStream();
    positionStreamSubscription = positionStream.handleError((error) {
      positionStreamSubscription?.cancel();
      positionStreamSubscription = null;
    }).listen((position) {
      FBroadcast.instance().broadcast(Constants.UPDATE_MAP_CAMERA_POSITION, value: position);
    });
  }

  static pause() {

    if (positionStreamSubscription?.isPaused == false){
      positionStreamSubscription?.pause();
    }

  }

  static resume(){
    if (positionStreamSubscription?.isPaused == true){
      positionStreamSubscription?.resume();
    }
  }
}
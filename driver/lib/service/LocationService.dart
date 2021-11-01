import 'dart:async';

import 'package:driver/common/Common.dart';
import 'package:driver/common/Constants.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {

  static StreamSubscription<Position>? positionStreamSubscription;
  static GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  static start() async {

    final positionStream = _geolocatorPlatform.getPositionStream(desiredAccuracy: LocationAccuracy.high, distanceFilter: 1);

    positionStreamSubscription = positionStream.handleError((error) {
      positionStreamSubscription?.cancel();
      positionStreamSubscription = null;
    }).listen((position) {
      Common.myLat = position.latitude;
      Common.myLng = position.longitude;
      Common.heading = position.heading;
      FBroadcast.instance().broadcast(Constants.LOCATION_UPDATE, value: position);
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
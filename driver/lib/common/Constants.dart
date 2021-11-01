import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static const String PHONE = 'phone';
  static const String VERIFICATION_ID = '';
  static const String APPROVED = 'Approved';
  static const String REJECTED = 'Rejected';
  static const String NOT_SUBMITTED = 'Not Submitted';
  static const String MALE = 'male';
  static const String FEMALE = 'female';
  static const String DRIVER = 'driver';
  static const String BROKER = 'broker';
  static const String LICENSE_PIC_BASE_URL = 'https://portboard.app/siteadmin/uploads/drivers-documents/';
  static const String DRIVER_LICENSE = 'Driver License';
  static const String TWIC_CARD = 'Twic Card';
  static const LatLng initMapPosition = const LatLng(0.0, 0.0);

  // broadcast constant
  static const String LOCATION_UPDATE = 'updateMapCameraPosition';
}
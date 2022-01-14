import 'package:driver/common/API.dart';
import 'package:driver/pages/account/SubmitTwicCardPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static const String PHONE = 'phone';
  static const String VERIFICATION_ID = '';
  static const String MALE = 'male';
  static const String FEMALE = 'female';
  static const String DRIVER = 'driver';
  static const String BROKER = 'broker';

  static const LatLng initMapPosition = const LatLng(0.0, 0.0);
  static const double SOUND_VOL = 0.8;

  // google map const
  static const String GOOGLE_MAP_KEY = 'AIzaSyBOOl2m6uh4H6INt4wWUI5PJXXBE8-QfmM';

  // mapbox const
  static const String MAP_PUBLIC_KEY = 'pk.eyJ1IjoiYnVsZGllcjIxIiwiYSI6ImNrd2F3bnp3bDd1cXYydW8wZm16NTRxeDEifQ.79VqSwRmDwRrQhqgZ9rz9g';
  static const String MAP_SECRET_KEY = 'sk.eyJ1IjoiYnVsZGllcjIxIiwiYSI6ImNrd2t6bzFxcjF3d3gydnVzZ3AwNXg5ejUifQ.4SSHDTuc9zNhOZinTz4mLg';
  static const String MAP_STYLE = 'https://api.mapbox.com/styles/v1/buldier21/ckwkmyidk5mc317qv3b22hx8i/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYnVsZGllcjIxIiwiYSI6ImNrd2F3bnp3bDd1cXYydW8wZm16NTRxeDEifQ.79VqSwRmDwRrQhqgZ9rz9g';
  static const String TILESET_ID = 'mapbox.mapbox-streets-v8';

  // on-offline constants
  static const String ONLINE = '1';
  static const String OFFLINE = '0';

  // sort key
  static const String A_TO_Z = 'A->Z';
  static const String Z_TO_A = 'Z->A';

  // user id and truck document type
  static const String DRIVER_LICENSE = 'Driver License';
  static const String TWIC_CARD = 'Twic Card';
  static const String SEALINK_CARD = 'Sealink Card';
  static const String MEDICAL_CARD = 'Medical Card';
  static const String BUSINESS_CERTIFICATE = 'Business Certificate';
  static const String BUSINESS_EIN_NUMBER = 'Business EIN Number';
  static const String PAYMENT_DETAILS = 'Payment Details';
  static const String ALCOHOL_DRUG_TEST = 'Alcohol Drug Test';
  static const String DRIVER_PHOTO = 'Driver Photo';
  static const String TRUCK_REGISTRATION = 'Truck Registration';
  static const String TRUCK_INSURANCE = 'Truck Insurance';
  static const String IFTA_STICKERS = 'IFTA Stickers';
  static const String EMITION_INSPECTION = 'Emition Inspection';
  static const String TRUCK_INFORMATION = 'Truck Information';

  // button titles
  static const String Okay = 'Okay';
  static const String Cancel = 'Cancel';
  static const String Yes = 'Yes';
  static const String No = 'No';

  // permission title
  static const String PERMISSION_ALERT = 'Permission Alert';

  // user type constants
  static const String USER_TYPE = '5';

  // status constants
  static const int NOT_SUBMITTED = 0; static const String strNotSubmitted = 'Not submitted';
  static const int  ACCEPT = 1; static const String strAccept = 'Accepted';
  static const int REJECT = 2; static const String strReject = 'Rejected';
  static const int PENDING = 3; static const String strPending = 'Pending';

  // notification constants
  static const String NOTI_DOCUMENT_VERIFY_STATUS = 'noti_101';
  static const String NOTI_NEW_JOB_REQUEST_TITLE = 'New Job Request';

  // broadcast constant
  static const String LOCATION_UPDATE = 'updateMapCameraPosition';
  static const String JOB_REQUEST = 'jobRequest';
  static const String SHOW_MY_POSITION = 'showMyPosition';

  // state list in US
  static const List<String> stateList = [
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
    'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH',
    'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
  ];
}
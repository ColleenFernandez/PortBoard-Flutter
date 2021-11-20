import 'package:driver/pages/account/SubmitTwicCardPage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Constants {
  static const String PHONE = 'phone';
  static const String VERIFICATION_ID = '';
  static const String MALE = 'male';
  static const String FEMALE = 'female';
  static const String DRIVER = 'driver';
  static const String BROKER = 'broker';
  static const String DOCUMENT_DIRECTORY_URL = 'https://portboard.app/siteadmin/uploads/drivers-documents/';

  static const LatLng initMapPosition = const LatLng(0.0, 0.0);
  static const double SOUND_VOL = 0.8;

  // on-offline constants
  static const String ONLINE = '1';
  static const String OFFLINE = '0';

  // sort key
  static const String A_TO_Z = 'A->Z';
  static const String Z_TO_A = 'Z->A';

  // document type
  static const String DRIVER_LICENSE = 'Driver License';
  static const String TWIC_CARD = 'Twic Card';
  static const String SEALINK_CARD = 'Sealink Card';
  static const String MEDICAL_CARD = 'Medical Card';
  static const String BUSINESS_CERTIFICATE = 'Business Certificate';
  static const String BUSINESS_EIN_NUMBER = 'Business EIN Number';
  static const String PAYMENT_DETAILS = 'Payment Details';
  static const String ALCOHOL_DRUG_TEST = 'Alcohol Drug Test';
  static const String DRIVER_PHOTO = 'Driver Photo';

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
  static const String NOTI_NEW_JOB_REQUEST_TITLE = 'New Job Request';
  static const String NOTI_DRIVER_LICENSE_APPROVED_TITLE = 'Driver License Approved';
  static const String NOTI_ALCOHOL_DRUG_TEST_APPROVED_TITLE = 'Alcohol Drug Test Approved';
  static const String NOTI_BUSINESS_CERTIFICATION_APPROVED_TITLE = 'Business Certification Approved';
  static const String NOTI_BUSINESS_EIN_NUMBER_APPROVED_TITLE = 'Business EIN Number Approved';
  static const String NOTI_DRIVER_PHOTO_APPROVED_TITLE = 'Driver photo Approved';
  static const String NOTI_MEDICAL_CARD_APPROVED_TITLE = 'Medical Card Approved';
  static const String NOTI_SEALINK_CARD_APPROVED_TITLE = 'Sealink Card Approved';
  static const String NOTI_TWIC_CARD_APPROVED_TITLE = 'Twic Card Approved';
  static const String NOTI_PAYMENT_DETAIL_APPROVED_TITLE = 'Payment Detail Approved';

  // broadcast constant
  static const String LOCATION_UPDATE = 'updateMapCameraPosition';
  static const String JOB_REQUEST = 'jobRequest';
  static const String SHOW_MY_POSITION = 'showMyPosition';
  static const String DRIVER_LICENSE_APPROVED = 'driverLicenseApproved';
  static const String ALCOHOL_DRUG_TEST_APPROVED = 'alcoholDrugTestApproved';
  static const String BUSINESS_CERTIFICATE_APPROVED = 'businessCertificateApproved';
  static const String BUSINESS_EIN_APPROVED = 'businessEINApproved';
  static const String DRIVER_PHOTO_APPROVED = 'driverPhotoApproved';
  static const String MEDICAL_CARD_APPROVED = 'medicalCardApproved';
  static const String SEALINK_CARD_APPROVED = 'sealinkCardApproved';
  static const String TWIC_CARD_APPROVED = 'twicCardApproved';
  static const String PAYMENT_DETAIL_APPROVED = 'paymentDetailApproved';

  // state list in US
  static const List<String> stateList = [
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY',
    'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH',
    'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY'
  ];
}
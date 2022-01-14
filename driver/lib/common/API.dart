
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/AlcoholDrugTestModel.dart';
import 'package:driver/model/BusinessCertificateModel.dart';
import 'package:driver/model/BusinessEINModel.dart';
import 'package:driver/model/ChassisTypeModel.dart';
import 'package:driver/model/CompanyChassisModel.dart';
import 'package:driver/model/DriverLicenseModel.dart';
import 'package:driver/model/DriverPhotoModel.dart';
import 'package:driver/model/EmitionInspectionModel.dart';
import 'package:driver/model/IFTAStickerModel.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/model/MedicalCardModel.dart';
import 'package:driver/model/PaymentDetailModel.dart';
import 'package:driver/model/SeaLinkCardModel.dart';
import 'package:driver/model/TruckInformationModel.dart';
import 'package:driver/model/TruckInsuranceModel.dart';
import 'package:driver/model/TruckRegistrationModel.dart';
import 'package:driver/model/TwicCardModel.dart';
import 'package:driver/model/UserModel.dart';

import 'Common.dart';

class API {

  var dio = Dio();

  //String baseURL = 'https://admin.portboard.app/index.php/DriverApi/';
  static String baseURL = 'http://192.168.0.58:2000/index.php/DriverApi/';
  final header = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Future<String> saveChassisInfo(String jobId, String chassisType, String companyChassis, String chassisNumber, String chassisPic) async{
    final url = baseURL + 'saveChassisInfo';
    final Map<String, dynamic> params = {
      'id' : jobId,
      'chassisType' : chassisType,
      'companyChassis' : companyChassis,
      'chassisNumber' : chassisNumber,
      'chassisPic' : chassisPic
    };

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }
    return APIConst.SUCCESS;
  }

  Future<String> uploadPic(String frontPic) async {
    final url = baseURL + 'uploadPic';
    final params = FormData.fromMap({
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : ''
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return res.data['picURL'];
  }

  Future<dynamic> getChassisType() async{
    final url = baseURL + 'getChassisType';

    final res = await dio.post(url, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return {
      'chassisList' : ChassisTypeModel().getList(res.data['chassisList']),
      'companyChassisList' : CompanyChassisModel().getList(res.data['companyChassisList'])
    };
  }

  Future<String> getRoute(double pickupLat, double pickupLng, double desLat, double desLng) async {
    String directionUrl = 'https://maps.googleapis.com/maps/api/directions/json?origin=${pickupLat},${pickupLng}&destination=${desLat},${desLng}&key=${Constants.GOOGLE_MAP_KEY}';
    final result = await dio.get(directionUrl);

    final String encodedPoint = result.data['routes'][0]['overview_polyline']['points'];
    return  encodedPoint;
  }

  Future<String> submitTruckInfo(String userId,
      String vehiculeIDNumber,
      String plateNumber,
      String year,
      String make,
      String model,
      String color,
      String frontPic) async {

    final url = baseURL + 'submitTruckInfo';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.vehiculeIDNumber : vehiculeIDNumber,
      APIConst.plateNumber: plateNumber,
      APIConst.year : year,
      APIConst.make : make,
      APIConst.model : model,
      APIConst.color : color,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : ''
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final truckInfomationModel = TruckInformationModel.fromJSON(res.data[APIConst.truckInformationDetail]);
    Common.userModel.truckInformationModel = truckInfomationModel;

    return APIConst.SUCCESS;
  }

  Future<String> submitEmitionInspection(String userId,
      String inspectionNumber,
      String state,
      String expirationDate,
      String frontPic) async {

    final url = baseURL + 'submitEmitionInspection';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.inspectionNumber : inspectionNumber,
      APIConst.state: state,
      APIConst.expirationDate : expirationDate,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : ''
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final emitionInspection = EmitionInspectionModel.fromJSON(res.data[APIConst.emitionInspectionDetail]);
    Common.userModel.emitionInspectionModel = emitionInspection;

    return APIConst.SUCCESS;
  }

  Future<String> submitIFTASticker(String userId,
      String iftaStickerNumber,
      String state,
      String expirationDate,
      String frontPic) async {

    final url = baseURL + 'submitIFTASticker';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.iftaStickerNumber : iftaStickerNumber,
      APIConst.state: state,
      APIConst.expirationDate : expirationDate,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : ''
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final iftaStickerModel = IFTAStickerModel.fromJSON(res.data[APIConst.iftaStickerDetail]);
    Common.userModel.iftaStickerModel = iftaStickerModel;

    return APIConst.SUCCESS;
  }

  Future<String> submitTruckInsurance(String userId,
      String companyName,
      String policyNumber,
      String companyPhone,
      String effectiveDate,
      String expirationDate,
      String address, String city, String state, String zipCode , String frontPic) async {

    final url = baseURL + 'submitTruckInsurance';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.companyName : companyName,
      APIConst.policyNumber: policyNumber,
      APIConst.companyPhone: companyPhone,
      APIConst.effectiveDate : effectiveDate,
      APIConst.expirationDate : expirationDate,
      APIConst.address : address,
      APIConst.city : city,
      APIConst.state : state,
      APIConst.zipCode : zipCode,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : ''
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final truckInsuranceDetail = TruckInsuranceModel.fromJSON(res.data[APIConst.truckInsuranceDetail]);
    Common.userModel.truckInsuranceModel = truckInsuranceDetail;

    return APIConst.SUCCESS;
  }

  Future<String> submitTruckReg(String userId,
      String companyName,
      String accountNumber,
      String plateNumber,
      String usdotNumber,
      String expirationDate,
      String address, String city, String state, String zipCode , String frontPic) async {

    final url = baseURL + 'submitTruckReg';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.companyName : companyName,
      APIConst.accountNumber: accountNumber,
      APIConst.plateNumber: plateNumber,
      APIConst.usdotNumber : usdotNumber,
      APIConst.expirationDate : expirationDate,
      APIConst.address : address,
      APIConst.city : city,
      APIConst.state : state,
      APIConst.zipCode : zipCode,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : ''
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final truckRegistrationModel = TruckRegistrationModel.fromJSON(res.data[APIConst.truckRegistrationDetail]);
    Common.userModel.truckRegistrationModel = truckRegistrationModel;

    return APIConst.SUCCESS;
  }

  Future<String> changeOnOffline(String userId, String status) async {
    final url = baseURL + 'changeOnOffline';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.on_offline : status
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }
    return APIConst.SUCCESS;
  }

  Future<String> submitDriverPhoto(String userId, String frontPic) async {
    final url = baseURL + 'submitDriverPhoto';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.photo : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : '',
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final driverPhoto = DriverPhotoModel.fromJSON(res.data[APIConst.driverPhotoDetail]);
    Common.userModel.driverPhotoModel = driverPhoto;

    return APIConst.SUCCESS;
  }

  Future<String> submitAlcoholDrugTest(String userId, String frontPic) async {
    final url = baseURL + 'submitAlcoholDrugTest';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : '',
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final alcoholDrugTest = AlcoholDrugTestModel.fromJSON(res.data[APIConst.alcoholDrugTestDetail]);
    Common.userModel.alcoholDrugTestModel = alcoholDrugTest;

    return APIConst.SUCCESS;
  }

  Future<String> submitPaymentDetails(String userId, String bankName, String accountNumber,
      String routing, String phone, String address, String city, String state, String zipCode) async {
    final url = baseURL + 'submitPaymentDetails';

    final Map<String, dynamic> params = {
      APIConst.userId : userId,
      APIConst.bankName : bankName,
      APIConst.accountNumber : accountNumber,
      APIConst.routing : routing,
      APIConst.phone : phone,
      APIConst.address : address,
      APIConst.city : city,
      APIConst.state : state,
      APIConst.zipCode : zipCode
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final paymentDetail = PaymentDetailModel.fromJSON(res.data[APIConst.paymentDetail]);
    Common.userModel.paymentDetailModel = paymentDetail;

    return APIConst.SUCCESS;
  }

  Future<String> submitBusinessEINNumber(String userId, String legalName, String businessEINNumber,
      String issuedDate, String address, String city, String state, String zipCode, String frontPic) async {
    final url = baseURL + 'submitBusinessEINNumber';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.legalName: legalName,
      APIConst.businessEINNumber: businessEINNumber,
      APIConst.issuedDate : issuedDate,
      APIConst.address : address,
      APIConst.city : city,
      APIConst.state : state,
      APIConst.zipCode : zipCode,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : '',
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final businessEINModel = BusinessEINModel.fromJSON(res.data[APIConst.businessEINDetail]);
    Common.userModel.businessEINModel = businessEINModel;

    return APIConst.SUCCESS;
  }

  Future<String> submitBusinessCertificate(String userId, String legalName, String registeredName,
      String issuedDate, String address, String city, String state, String zipCode, String frontPic) async {
    final url = baseURL + 'submitBusinessCertificate';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.legalName: legalName,
      APIConst.registeredName: registeredName,
      APIConst.issuedDate : issuedDate,
      APIConst.address : address,
      APIConst.city : city,
      APIConst.state : state,
      APIConst.zipCode : zipCode,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : '',
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final businessCard = BusinessCertificateModel.fromJSON(res.data[APIConst.businessCertificateDetail]);
    Common.userModel.businessCertificateModel = businessCard;

    return APIConst.SUCCESS;
  }

  Future<String> submitMedicalDard(String userId, String expiryDate, String issuedDate, String frontPic, String backPic) async {
    final url = baseURL + 'submitMedicalDard';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.expirationDate: expiryDate,
      APIConst.issuedDate: issuedDate,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : '',
      APIConst.backPic : backPic.isNotEmpty ? await MultipartFile.fromFile(backPic) : '',
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final medicalCard = MedicalCardModel.fromJSON(res.data[APIConst.medicalCardDetail]);
    Common.userModel.medicalCardModel = medicalCard;

    return APIConst.SUCCESS;
  }

  Future<String> submitSealinkCard(String userId, String cardNumber, String expiryDate, String frontPic, String backPic) async {
    final url = baseURL + 'submitSealinkCard';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.cardNumber: cardNumber,
      APIConst.expirationDate: expiryDate,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : '',
      APIConst.backPic : backPic.isNotEmpty ? await MultipartFile.fromFile(backPic) : '',
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final seaLinkCard = SeaLinkCardModel.fromJSON(res.data[APIConst.seaLinkCardDetail]);
    Common.userModel.seaLinkCardModel = seaLinkCard;

    return APIConst.SUCCESS;
  }

  Future<String> submitTwicCard(String userId, String cardNumber, String expiryDate, String frontPic, String backPic) async {
    final url = baseURL + 'submitTwicCard';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.cardNumber: cardNumber,
      APIConst.expirationDate: expiryDate,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : '',
      APIConst.backPic : backPic.isNotEmpty ? await MultipartFile.fromFile(backPic) : '',
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final twicCardModel = TwicCardModel.fromJSON(res.data[APIConst.twicCardDetail]);
    Common.userModel.twicCardModel = twicCardModel;

    return APIConst.SUCCESS;
  }

  Future<String> submitDriverLicense(String userId, String driverLicense, String expiryDate, String frontPic, String backPic) async {
    final url = baseURL + 'submitDriverLicense';
    final params = FormData.fromMap({
      APIConst.userId : userId,
      APIConst.driverLicense: driverLicense,
      APIConst.expirationDate: expiryDate,
      APIConst.frontPic : frontPic.isNotEmpty ? await MultipartFile.fromFile(frontPic) : '',
      APIConst.backPic : backPic.isNotEmpty ? await MultipartFile.fromFile(backPic) : '',
    });

    final res = await dio.post(url, data:  params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final driverLicenseModel = DriverLicenseModel.fromJSON(res.data[APIConst.driverLicense]);
    Common.userModel.driverLicenseModel = driverLicenseModel;

    return APIConst.SUCCESS;
  }

  Future<String> skipDriver(String driverId, String jobId) async {
    final url = baseURL + '/skipDriver';
    final Map<String, dynamic> params = {
      APIConst.driverId : driverId,
      APIConst.jobId : jobId
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return APIConst.SUCCESS;
  }

  Future<String> acceptJob(String driverId, String jobId) async {
    final url = baseURL + '/acceptJob';
    final Map<String, dynamic> params = {
      APIConst.driverId : driverId,
      APIConst.jobId : jobId
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return APIConst.SUCCESS;
  }

  Future<dynamic> getJobRequest(String driverId) async{
    final url = baseURL + '/getJobRequest';
    final Map<String, dynamic> params = {
      APIConst.driverId : driverId
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return JobModel.fromJSON(res.data[APIConst.jobDetail]);
  }

  Future<String> rejectJob(String driverId, String jobId) async {
    final url = baseURL + '/rejectJob';
    final Map<String, dynamic> params = {
      APIConst.driverId : driverId,
      APIConst.jobId : jobId
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return APIConst.SUCCESS;
  }

  Future<String> updateToken(String userId, String token) async {
    final url = baseURL + '/updateToken';
    final Map<String, dynamic> params = {
      APIConst.id : userId,
      APIConst.fcmToken : token
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return APIConst.SUCCESS;
  }

  Future<bool> changeUserStatus(String userId, bool status) async{

    final url = baseURL + '/changeUserStatus';
    final Map<String, dynamic> params = {
      APIConst.id : userId,
      APIConst.status: status
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return false;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return false;
    }

    return true;
  }

  Future<String> login(String phone) async{

    final url = baseURL + '/login';
    final Map<String, dynamic> params = {
      APIConst.phone: phone
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    final Map<String, dynamic> resData = res.data;

    final userModel = UserModel.fromJSON(resData[APIConst.user]);
    Common.userModel = userModel;

    if (resData.containsKey(APIConst.jobRequest)){
      Common.jobRequest = JobModel.fromJSON(res.data[APIConst.jobRequest]);
    }

    if (resData.containsKey(APIConst.myJob)) {
      Common.myJob = JobModel.fromJSON(res.data[APIConst.myJob]);
    }

    if (resData.containsKey(APIConst.driverLicense)) {
      final driverLicense = DriverLicenseModel.fromJSON(resData[APIConst.driverLicense]);
      Common.userModel.driverLicenseModel = driverLicense;
    }

    if (resData.containsKey(APIConst.twicCardDetail)){
      final twicCard = TwicCardModel.fromJSON(resData[APIConst.twicCardDetail]);
      Common.userModel.twicCardModel = twicCard;
    }

    if (resData.containsKey(APIConst.seaLinkCardDetail)){
      final seaLinkCard = SeaLinkCardModel.fromJSON(resData[APIConst.seaLinkCardDetail]);
      Common.userModel.seaLinkCardModel = seaLinkCard;
    }

    if (resData.containsKey(APIConst.medicalCardDetail)) {
      final medicalCard = MedicalCardModel.fromJSON(resData[APIConst.medicalCardDetail]);
      Common.userModel.medicalCardModel = medicalCard;
    }

    if (resData.containsKey(APIConst.businessCertificateDetail)) {
      final businessCertificate = BusinessCertificateModel.fromJSON(resData[APIConst.businessCertificateDetail]);
      Common.userModel.businessCertificateModel = businessCertificate;
    }

    if (resData.containsKey(APIConst.businessEINDetail)) {
      final businessEIN = BusinessEINModel.fromJSON(resData[APIConst.businessEINDetail]);
      Common.userModel.businessEINModel = businessEIN;
    }

    if (resData.containsKey(APIConst.paymentDetail)) {
      final paymentDetail = PaymentDetailModel.fromJSON(resData[APIConst.paymentDetail]);
      Common.userModel.paymentDetailModel = paymentDetail;
    }

    if (resData.containsKey(APIConst.alcoholDrugTestDetail)){
      final alcoholDrugTest = AlcoholDrugTestModel.fromJSON(resData[APIConst.alcoholDrugTestDetail]);
      Common.userModel.alcoholDrugTestModel = alcoholDrugTest;
    }

    if(resData.containsKey(APIConst.driverPhotoDetail)) {
      final driverPhoto = DriverPhotoModel.fromJSON(resData[APIConst.driverPhotoDetail]);
      Common.userModel.driverPhotoModel = driverPhoto;
    }

    if(resData.containsKey(APIConst.truckRegistrationDetail)) {
      final data = TruckRegistrationModel.fromJSON(resData[APIConst.truckRegistrationDetail]);
      Common.userModel.truckRegistrationModel = data;
    }

    if(resData.containsKey(APIConst.truckInsuranceDetail)) {
      final data = TruckInsuranceModel.fromJSON(resData[APIConst.truckInsuranceDetail]);
      Common.userModel.truckInsuranceModel = data;
    }

    if(resData.containsKey(APIConst.iftaStickerDetail)) {
      final data = IFTAStickerModel.fromJSON(resData[APIConst.iftaStickerDetail]);
      Common.userModel.iftaStickerModel = data;
    }

    if(resData.containsKey(APIConst.emitionInspectionDetail)) {
      final data = EmitionInspectionModel.fromJSON(resData[APIConst.emitionInspectionDetail]);
      Common.userModel.emitionInspectionModel = data;
    }

    if(resData.containsKey(APIConst.truckInformationDetail)) {
      final data = TruckInformationModel.fromJSON(resData[APIConst.truckInformationDetail]);
      Common.userModel.truckInformationModel = data;
    }

    return APIConst.SUCCESS;
  }

  Future<String> register(String phone, String firstName, String lastName, String email, String gender, String userType) async {
    final url = baseURL + '/register';
    final params = {
      APIConst.phone : phone,
      APIConst.firstName : firstName,
      APIConst.lastName : lastName,
      APIConst.email : email,
      APIConst.gender : gender,
      APIConst.userType : userType,
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    Common.userModel = UserModel.fromJSON(res.data[APIConst.user]);

    return APIConst.SUCCESS;
  }
}
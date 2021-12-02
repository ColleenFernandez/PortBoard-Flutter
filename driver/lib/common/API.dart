
import 'package:dio/dio.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/common/Constants.dart';
import 'package:driver/model/AlcoholDrugTestModel.dart';
import 'package:driver/model/BusinessCertificateModel.dart';
import 'package:driver/model/BusinessEINModel.dart';
import 'package:driver/model/DriverLicenseModel.dart';
import 'package:driver/model/DriverPhotoModel.dart';
import 'package:driver/model/JobModel.dart';
import 'package:driver/model/MedicalCardModel.dart';
import 'package:driver/model/PaymentDetailModel.dart';
import 'package:driver/model/SeaLinkCardModel.dart';
import 'package:driver/model/TwicCardModel.dart';
import 'package:driver/model/UserModel.dart';

import 'Common.dart';

class API {

  var dio = Dio();

  String baseURL = 'https://admin.portboard.app/index.php/DriverApi/';
  //String baseURL = 'http://192.168.101.58:2000/index.php/DriverApi/';
  final header = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

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

    return APIConst.SUCCESS;
  }

  Future<dynamic> register(String phone, String firstName, String lastName, String email, String gender, String userType) async {
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

    return UserModel.fromJSON(res.data[APIConst.user]);
  }
}
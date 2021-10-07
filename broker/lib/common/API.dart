
import 'package:dio/dio.dart';
import 'package:driver/common/APIConst.dart';
import 'package:driver/model/UserModel.dart';

class API {

  var dio = Dio();

  String baseURL = 'https://admin.portboard.app/index.php/DriverApi/';
  final header = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };


  Future<dynamic> login(String phone) async{

    final url = baseURL + '/login';
    final Map<String, dynamic> params = {
      APIConst.PHONE: phone
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));

    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return UserModel.fromJSON(res.data[APIConst.USER]);
  }

  Future<dynamic> register(String phone, String firstName, String lastName, String email, String gender, String accountStatus) async {
    final url = baseURL + '/registerUserDetail';
    final params = {
      APIConst.PHONE : phone,
      APIConst.FIRST_NAME : firstName,
      APIConst.LAST_NAME : lastName,
      APIConst.EMAIL : email,
      APIConst.GENDER : gender,
      APIConst.ACCOUNT_STATUS : accountStatus,
    };

    final res = await dio.post(url, data: params, options: Options(headers: header));
    if (res.statusCode != 200){
      return APIConst.SERVER_ERROR;
    }

    final msg = res.data[APIConst.MSG];
    if (msg != APIConst.SUCCESS){
      return msg;
    }

    return UserModel.fromJSON(res.data[APIConst.USER]);
  }
}
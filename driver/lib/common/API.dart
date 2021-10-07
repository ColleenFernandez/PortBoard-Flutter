
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

    return UserModel.fromJSON(res.data[APIConst.user]);
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
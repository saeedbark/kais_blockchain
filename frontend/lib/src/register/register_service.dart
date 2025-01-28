import 'package:frontend/network/api_path.dart';
import 'package:frontend/network/dio_client.dart';
import 'package:frontend/src/login/login_model.dart';

class RegisterService {
     Future<User> register(String username, String password) async {
    try {
      final response = await DioHelper().post(ApiPath.register,data:  {
        'username': username,
        'password': password,
      });

      if (response?.statusCode == 200) {
        return response?.data; 
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw e;
    }
  }
}
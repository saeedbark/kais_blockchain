import 'package:frontend/network/dio_client.dart';

class OtpService {
  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final response = await DioHelper().post(
      'https://chinguisoft.com/api/sms/validation/3i5Gmec1uxCrsRDU',
      data: {
        'phone': phoneNumber,
        'lang': 'fr',
      },
      // headers: {
      //   'Validation-token': 'XFcKDVEzjkqiD1JTA2fnHDKn3Y5wzWib',
      //   'Content-Type': 'application/json',
      // }
    );

    if (response == null) return {};

    return response.data;
  }
}

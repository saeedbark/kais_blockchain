import 'package:frontend/network/dio_client.dart';

class OtpService {
  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final response = await DioHelper().post(
        'https://chinguisoft.com/api/sms/validation/FPWjewqQNiyvvuoa',
        data: {
          'phone': phoneNumber,
          'lang': 'fr',
        },
        headers: {
          'Validation-token': 'QfxQar9S57kTyj2H4CAhdUrrsD6niH0M',
          'Content-Type': 'application/json',
        });

    if (response == null) return {};

    return response.data;
  }
}

import 'package:dio/dio.dart';
import 'package:frontend/network/api_path.dart';
import 'package:frontend/network/dio_client.dart';

class DepositService {
  Future<dynamic> deposit({
    required String sender,
    required String recipient,
    required double amount,
  }) async {
    final response = await DioHelper().post(
      ApiPath.deposit,
      data: {
        'sender': sender,
        'recipient': recipient,
        'amount': amount,
      },
    );
    return response;
  }
}

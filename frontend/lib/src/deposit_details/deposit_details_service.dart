import 'package:frontend/network/api_path.dart';
import 'package:frontend/network/dio_client.dart';

class DepositDetailsService {
    Future<Map<String ,dynamic>> getTransactions(String address)async {
    final response = await DioHelper().get('${ApiPath.transactions}/$address');

    if(response == null) return {};
    

    
    return response.data;
}
}
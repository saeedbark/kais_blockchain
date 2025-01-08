import 'package:frontend/network/api_path.dart';
import 'package:frontend/network/dio_client.dart';


class DashboardService {
  Future<Map<String ,dynamic>> getAccounts()async {
    final response = await DioHelper().get(ApiPath.accounts);

    if(response == null) return {};
    

    
    return response.data;
}
  
}


import 'package:flutter/material.dart';
import 'package:frontend/src/login/login_model.dart';
import 'package:frontend/src/login/login_view.dart';
import 'package:frontend/src/register/register_service.dart';

class RegisterController extends ChangeNotifier{
      bool _isLoading = false;
    bool get isLoading => _isLoading;



    Future<User?> register( BuildContext context,String username, String password) async {

   _isLoading = true;
    notifyListeners();
    
      final response = await RegisterService().register(username, password);

      if (response.ethAddress.isNotEmpty) {
 
     Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginView()));
     _isLoading = false;
     notifyListeners();
     return response;
      }
    
      _isLoading = false;
     notifyListeners();
    return null;
  }
}
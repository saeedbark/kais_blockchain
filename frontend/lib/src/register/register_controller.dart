import 'package:flutter/material.dart';
import 'package:frontend/src/login/login_model.dart';
import 'package:frontend/src/register/register_service.dart';

class RegisterController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<User?> register(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();
    try {
      final response = await RegisterService().register(username, password);

      if (response.ethAddress.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return response;
      }
    } catch (e) {
      _errorMessage = e.toString();

      _isLoading = false;
      notifyListeners();
      return null;
    }
    _isLoading = false;
    notifyListeners();
    return null;
  }
}

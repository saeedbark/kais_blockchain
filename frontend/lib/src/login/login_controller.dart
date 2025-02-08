// lib/providers/login_controller.dart

import 'package:flutter/material.dart';
import '../../shared_pref/shared_preferences.dart';
import '../login/login_model.dart';
import '../login/login_service.dart';

class LoginController extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<User?> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _loginService.login(username, password);

      if (response.ethAddress.isNotEmpty) {
        await SharedPreferencesHelper.setString('token', response.token);
        await SharedPreferencesHelper.setString('address', response.ethAddress);
        _isLoading = false;
        notifyListeners();
        return response;
      } else {
        _errorMessage = 'Invalid ETH Address';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }
}

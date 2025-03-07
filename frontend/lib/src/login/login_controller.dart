import 'package:flutter/material.dart';
import 'package:frontend/src/dashboard/dashboard_view.dart';
import 'package:frontend/src/otp/otp_view.dart';
import 'package:frontend/src/register/register_view.dart';
import '../../shared_pref/shared_preferences.dart';
import '../login/login_service.dart';

class LoginController extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _usernameError;
  String? _passwordError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get usernameError => _usernameError;
  String? get passwordError => _passwordError;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginController() {
    usernameController.addListener(_clearUsernameError);
    passwordController.addListener(_clearPasswordError);
  }

  void _clearUsernameError() {
    if (_usernameError != null) {
      _usernameError = null;
      notifyListeners();
    }
  }

  void _clearPasswordError() {
    if (_passwordError != null) {
      _passwordError = null;
      notifyListeners();
    }
  }

  void navigateToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterView()),
    );
  }

  Future<void> login(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    _usernameError = null;
    _passwordError = null;
    notifyListeners();

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Basic validation
    if (username.isEmpty) {
      _usernameError = 'Username is required';
      _isLoading = false;
      notifyListeners();
      return;
    }

    if (password.isEmpty) {
      _passwordError = 'Password is required';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await _loginService.login(username, password);

      if (response.ethAddress.isNotEmpty) {
        await SharedPreferencesHelper.setString('token', response.token);
        await SharedPreferencesHelper.setString('address', response.ethAddress);

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtpView()),
          );
        }
      } else {
        _errorMessage = 'Invalid credentials or ETH address';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

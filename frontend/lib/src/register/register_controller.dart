import 'package:flutter/material.dart';
import 'package:frontend/src/login/login_view.dart';
import 'package:frontend/src/register/register_service.dart';
import 'package:frontend/src/otp/otp_view.dart';
import '../../shared_pref/shared_preferences.dart';

class RegisterController extends ChangeNotifier {
  final RegisterService _registerService = RegisterService();

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

  RegisterController() {
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

  Future<void> register(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    _usernameError = null;
    _passwordError = null;
    notifyListeners();

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    // Validation
    if (username.isEmpty) {
      _usernameError = 'email is required';
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
      final response = await _registerService.register(username, password);

      if (response.ethAddress.isNotEmpty) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        }
      } else {
        _errorMessage = 'Registration failed - invalid response';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

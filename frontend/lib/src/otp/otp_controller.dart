// otp_controller.dart
import 'package:flutter/material.dart';
import 'package:frontend/shared_pref/shared_preferences.dart';
import 'package:frontend/src/dashboard/dashboard_view.dart';
import 'package:frontend/src/otp/otp_service.dart';

class OtpController extends ChangeNotifier {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final focusNode = FocusNode();

  final phoneFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool isOtpSent = false;
  String _sentOtp = '';
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> sendOtp() async {
    if (!phoneFormKey.currentState!.validate()) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await OtpService().sendOtp(phoneController.text.trim());

      if (response['code'] != null) {
        _sentOtp = response['code'].toString();
        isOtpSent = true;
      }
    } catch (e) {
      _errorMessage = _handleError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (!otpFormKey.currentState!.validate()) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (_sentOtp == otpController.text.trim()) {
        await SharedPreferencesHelper.setString('code', _sentOtp);

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardView()),
          );
        }
      } else {
        _errorMessage = 'Invalid OTP code';
      }
    } catch (e) {
      _errorMessage = _handleError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _handleError(dynamic error) {
    return error.toString().replaceAll('Exception: ', '');
  }

  void resetState() {
    isOtpSent = false;
    phoneController.clear();
    otpController.clear();
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}

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

  bool isLoading = false;
  bool isOtpSent = false;
  String sentOtp = '';

  Future<void> sendOtp() async {
    if (!phoneFormKey.currentState!.validate()) return;

    isLoading = true;

    try {
      final response = await OtpService().sendOtp(phoneController.text.trim());

      if (response['code'] != null) {
        sentOtp = response['code'].toString();
        isOtpSent = true;
        // snackbar("succes", 'Send Otp Succes',
        //     backgroundColor: Colors.green.shade300);
      }
    } catch (e) {
      print('Exception: $e, Stacktrace: ');
      // Get.snackbar("Error", 'Send otp fail',
      //     backgroundColor: Colors.red.shade300);
    } finally {
      isLoading = false;
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (!otpFormKey.currentState!.validate()) return;
    isLoading = true;

    try {
      if (sentOtp == otpController.text.trim()) {
        SharedPreferencesHelper.setString('code', sentOtp);
        // Get.snackbar("succes", 'Send Otp Succes',
        //     backgroundColor: Colors.green.shade300);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardView()),
        );
      } else {
        // Get.snackbar("Error", 'Otp not Correct',
        //     backgroundColor: Colors.red.shade200);
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;

      print('Exception: $e, Stacktrace: ');
      // Get.snackbar("Error", 'Verify otp fail',
      //     backgroundColor: Colors.red.shade300);
    }
  }
}

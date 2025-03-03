import 'package:flutter/material.dart';
import 'package:frontend/src/otp/otp_controller.dart';
import 'package:frontend/src/widget/validation.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OtpController>();

    // Themes and Styles
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'OTP Authentication',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: controller.isOtpSent
                ? _buildOtpVerification(context, controller, defaultPinTheme,
                    fillColor, focusedBorderColor)
                : _buildPhoneInput(context, controller),
          ),
        ),
      ),
    );
  }

  // Build Phone Number Input
  Widget _buildPhoneInput(BuildContext context, OtpController controller) {
    return Form(
      key: controller.phoneFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter Your Phone Number',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              prefixIcon: const Icon(Icons.phone, color: Colors.deepOrange),
              hintText: 'Phone Number',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) =>
                ValidationUtils.validateMauritaniaPhoneNumber(value ?? ''),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoading ? null : () => controller.sendOtp,
              child: controller.isLoading
                  ? Text('Sending OTP...')
                  : Text('Send OTP'),
            ),
          ),
        ],
      ),
    );
  }

  // Build OTP Verification
  Widget _buildOtpVerification(BuildContext context, OtpController controller,
      PinTheme defaultPinTheme, Color fillColor, Color focusedBorderColor) {
    return Form(
      key: controller.otpFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter OTP',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange),
          ),
          const SizedBox(height: 30),
          Pinput(
            controller: controller.otpController,
            focusNode: controller.focusNode,
            defaultPinTheme: defaultPinTheme,
            length: 6,
            separatorBuilder: (index) => const SizedBox(width: 8),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Enter the OTP';
              if (value.trim().length != 6) return 'OTP must be 6 digits';
              return null;
            },
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: (pin) => controller.verifyOtp(context),
            onSubmitted: (pin) => controller.verifyOtp(context),
            cursor: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  width: 22,
                  height: 1,
                  color: focusedBorderColor,
                ),
              ],
            ),
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: focusedBorderColor),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: fillColor,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: focusedBorderColor),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoading
                  ? null
                  : () => controller.verifyOtp(context),
              child: controller.isLoading
                  ? Text('Verifying OTP...')
                  : Text('Verify OTP'),
            ),
          ),
        ],
      ),
    );
  }
}

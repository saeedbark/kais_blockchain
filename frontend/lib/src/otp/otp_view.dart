import 'package:flutter/material.dart';
import 'package:frontend/constent/my_string.dart';
import 'package:frontend/src/otp/otp_controller.dart';
import 'package:frontend/src/widget/validation.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpController(),
      child: const _OtpScaffold(), // Use a separate widget for the scaffold
    );
  }
}

class _OtpScaffold extends StatelessWidget {
  const _OtpScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const _AppBar(),
                  const SizedBox(height: 100),
                  Consumer<OtpController>(
                    builder: (context, controller, _) {
                      final pinTheme = _buildPinTheme();
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: controller.isOtpSent
                            ? _OtpVerification(
                                controller: controller, pinTheme: pinTheme)
                            : const _PhoneInput(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PinTheme _buildPinTheme() {
    return PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const Expanded(
          child: Text(
            'OTP Verification',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _PhoneInput extends StatelessWidget {
  const _PhoneInput();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OtpController>();
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.phoneFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const Icon(Icons.phone_iphone,
                  size: 64, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'Enter Your Phone Number',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  prefixIcon:
                      const Icon(Icons.phone, color: AppColors.textSecondary),
                  hintText: 'Example: +222 41 23 45 67',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorStyle: const TextStyle(color: AppColors.error),
                ),
                validator: (value) =>
                    ValidationUtils.validateMauritaniaPhoneNumber(value ?? ''),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed:
                      controller.isLoading ? null : () => controller.sendOtp(),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : const Text(
                          'SEND OTP',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpVerification extends StatelessWidget {
  final OtpController controller;
  final PinTheme pinTheme;

  const _OtpVerification({
    required this.controller,
    required this.pinTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.otpFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const Icon(Icons.verified_user,
                  size: 64, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sent to ${controller.phoneController.text}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              Pinput(
                controller: controller.otpController,
                focusNode: controller.focusNode,
                length: 6,
                defaultPinTheme: pinTheme,
                focusedPinTheme: pinTheme.copyWith(
                  decoration: pinTheme.decoration!.copyWith(
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                ),
                errorPinTheme: pinTheme.copyWith(
                  decoration: pinTheme.decoration!.copyWith(
                    border: Border.all(color: AppColors.error),
                  ),
                ),
                validator: (value) {
                  if (value?.length != 6) return 'Please enter 6-digit code';
                  return null;
                },
                onCompleted: (pin) => controller.verifyOtp(context),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  onPressed: controller.isLoading
                      ? null
                      : () => controller.verifyOtp(context),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : const Text(
                          'VERIFY OTP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: controller.isLoading
                    ? null
                    : () {
                        controller.resetState();
                      },
                child: const Text(
                  'Change Phone Number',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

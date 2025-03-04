
class ValidationUtils {
  static bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email can't be empty";
    } else if (!isValidEmail(email)) {
      return "Enter a valid email address";
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter the OTP.";
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return "OTP must be 6 digits.";
    }
    return null;
  }

  static String? validateMauritaniaPhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegExp = RegExp(r'^\d{8}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Enter a valid Mauritanian phone number (8 digits)';
    }

    return null;
  }
}

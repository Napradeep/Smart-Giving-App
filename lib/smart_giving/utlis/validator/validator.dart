class InputValidator {
  static String? validateMobile(String mobile) {
    if (mobile.isEmpty) {
      return "Please enter mobile number";
    }
    if (mobile.length < 9) {
      return "Please enter a valid mobile number";
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Please enter password";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters long";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must include at least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must include at least one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must include at least one number";
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Password must include at least one special character";
    }
    return null;
  }
}

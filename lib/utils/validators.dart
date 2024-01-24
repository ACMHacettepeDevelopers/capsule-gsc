class Validator{
   static String? passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.trim().length < 6) {
      return "Password must be at least 6 characters long";
    } else {
      return null;
    }
  }

  static String? emailValidator(value) {
    if (value == null || value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    } else {
      return null;
    }
  }
  static String? credentialValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid data.';
    } else {
      return null;
    }
  }

}
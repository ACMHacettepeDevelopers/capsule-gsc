class Validator{
  final nameRegexp = RegExp(r'^[A-Za-z ]+$');
  final phoneRegexp = RegExp(r'^[0-9]+$');
  final emailRegexp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  final doseRegexp = RegExp(r'^[0-9]+$');

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
  String? medicationNameValidator(value) {
    if (value.isEmpty) {
      return 'Name can not be empty.';
    }
    if (!nameRegexp.hasMatch(value)) {
      return 'Please enter a valid name.';
    }
    return null;
  }
  String? medicationDoseValidator(value) {
    if (value.isEmpty) {
      return 'Dose can not be empty.';
    }
    if (!doseRegexp.hasMatch(value)) {
      return 'Please enter a valid dose.';
    }
    if (int.parse(value) > 6) {
    return 'Dose can not be greater than 6.';
  }
    return null;
  }
  String? medicationUsageValidator(value) {
    if (value.isEmpty) {
      return 'Usage can not be empty.';
    }
    if (!doseRegexp.hasMatch(value)) {
      return 'Please enter a valid dose.';
    }
    return null;
  }

}
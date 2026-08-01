
class Validator {
  static String? validatTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter title';
    }
    return null;
  }

  static String? validatDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter description';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }






  static String? validateUnitOrApt(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Unit/Apt No';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    // Only digits and minimum 9 digits
    if (!RegExp(r'^\d{9,}$').hasMatch(value.trim())) {
      return 'Please enter a valid phone number with at least 9 digits';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  static String? validatePasswordLogin(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    final hasSpecialChar = RegExp(r'[!@#\$&*~%^(),.?":{}|<>]').hasMatch(value);

    if (!hasLetter || !hasDigit || !hasSpecialChar) {
      return 'Password must include letters, numbers, and special characters';
    }

    return null;
  }




  static String? validateCPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your confirm password';
    }
    return null;
  }




  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  static String? validateMsg(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your message';
    }
    if (value.length < 3) {
      return 'Name message be at least 3 characters long';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'message can only contain letters and spaces';
    }
    return null;
  }

  static String? validateMsg1(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your message';
    }
    if (value.isEmpty) {
      return 'Message should be at least 1 character long';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s.,!?@#&()-]+$').hasMatch(value)) {
      return 'Message contains invalid characters';
    }
    return null;
  }


}


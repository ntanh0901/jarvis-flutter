class Validators {
  // Required field validation with custom message support
  static String? isRequired(String? value, {String? customMessage}) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? 'This field is required';
    }
    return null;
  }

  // Username validation
  static String? validateUsername({
    required String? value,
    int minLength = 3,
    int maxLength = 20,
    String? customMessage,
  }) {
    if (value == null || value.isEmpty) {
      return customMessage ?? 'Please enter your username';
    }

    // Check if the username is within the length limits
    if (value.length < minLength) {
      return customMessage ??
          'Username must be at least $minLength characters long';
    }

    if (value.length > maxLength) {
      return customMessage ??
          'Username cannot be more than $maxLength characters long';
    }

    // Check if the username contains only alphanumeric characters or underscores
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return customMessage ??
          'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  // General email validation
  static String? validateEmail(
      {required String? value, String? customMessage}) {
    if (value == null || value.isEmpty) {
      return customMessage ?? 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return customMessage ?? 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  static String? validatePassword({
    required String? value,
    required String? confirmPassword,
    int minLength = 8,
    String? customMessage,
  }) {
    String? validationError;

    // Check required field
    validationError = _validateRequiredPassword(value, customMessage);
    if (validationError != null) return validationError;

    // Check minimum length
    validationError =
        _validatePasswordMinLength(value, minLength, customMessage);
    if (validationError != null) return validationError;

    // Check for uppercase letter
    validationError = _validatePasswordUppercase(value, customMessage);
    if (validationError != null) return validationError;

    // Check for lowercase letter
    validationError = _validatePasswordLowercase(value, customMessage);
    if (validationError != null) return validationError;

    // Check for number
    validationError = _validatePasswordNumber(value, customMessage);
    if (validationError != null) return validationError;

    // Check for special character
    validationError = _validatePasswordSpecialChar(value, customMessage);
    if (validationError != null) return validationError;

    // Check if passwords match
    validationError =
        _validatePasswordConfirmation(value, confirmPassword, customMessage);
    if (validationError != null) return validationError;

    return null;
  }

  // Private helper methods for each validation check

  static String? _validateRequiredPassword(
      String? value, String? customMessage) {
    if (value == null || value.isEmpty) {
      return customMessage ?? 'Please enter your password';
    }
    return null;
  }

  static String? _validatePasswordMinLength(
      String? value, int minLength, String? customMessage) {
    if (value!.length < minLength) {
      return customMessage ??
          'Password must be at least $minLength characters long';
    }
    return null;
  }

  static String? _validatePasswordUppercase(
      String? value, String? customMessage) {
    if (!RegExp(r'[A-Z]').hasMatch(value!)) {
      return customMessage ??
          'Password must contain at least one uppercase letter';
    }
    return null;
  }

  static String? _validatePasswordLowercase(
      String? value, String? customMessage) {
    if (!RegExp(r'[a-z]').hasMatch(value!)) {
      return customMessage ??
          'Password must contain at least one lowercase letter';
    }
    return null;
  }

  static String? _validatePasswordNumber(String? value, String? customMessage) {
    if (!RegExp(r'[0-9]').hasMatch(value!)) {
      return customMessage ?? 'Password must contain at least one number';
    }
    return null;
  }

  static String? _validatePasswordSpecialChar(
      String? value, String? customMessage) {
    if (!RegExp(r'[\W_]').hasMatch(value!)) {
      return customMessage ??
          'Password must contain at least one special character';
    }
    return null;
  }

  static String? _validatePasswordConfirmation(
      String? value, String? confirmPassword, String? customMessage) {
    if (value != confirmPassword) {
      return customMessage ?? 'Passwords do not match';
    }
    return null;
  }
}

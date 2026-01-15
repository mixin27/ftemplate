/// Form validation helpers
class AppValidators {
  const AppValidators._();

  /// Validate required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : 'This field is required';
    }
    return null;
  }

  /// Validate email address
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate minimum length
  static String? Function(String?) minLength(int min, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value.length < min) {
        return fieldName != null
            ? '$fieldName must be at least $min characters'
            : 'Must be at least $min characters';
      }
      return null;
    };
  }

  /// Validate maximum length
  static String? Function(String?) maxLength(int max, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value.length > max) {
        return fieldName != null
            ? '$fieldName must not exceed $max characters'
            : 'Must not exceed $max characters';
      }
      return null;
    };
  }

  /// Validate phone number
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) return null;

    // Remove common formatting characters
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]+'), '');

    // Allow + at the start for international numbers
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validate URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) return null;

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  /// Validate numeric value
  static String? numeric(String? value) {
    if (value == null || value.isEmpty) return null;

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  /// Validate integer value
  static String? integer(String? value) {
    if (value == null || value.isEmpty) return null;

    if (int.tryParse(value) == null) {
      return 'Please enter a valid whole number';
    }
    return null;
  }

  /// Validate minimum value
  static String? Function(String?) minValue(num min, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid number';
      }

      if (numValue < min) {
        return fieldName != null
            ? '$fieldName must be at least $min'
            : 'Must be at least $min';
      }
      return null;
    };
  }

  /// Validate maximum value
  static String? Function(String?) maxValue(num max, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid number';
      }

      if (numValue > max) {
        return fieldName != null
            ? '$fieldName must not exceed $max'
            : 'Must not exceed $max';
      }
      return null;
    };
  }

  /// Validate value is within range
  static String? Function(String?) range(
    num min,
    num max, {
    String? fieldName,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      final numValue = num.tryParse(value);
      if (numValue == null) {
        return 'Please enter a valid number';
      }

      if (numValue < min || numValue > max) {
        return fieldName != null
            ? '$fieldName must be between $min and $max'
            : 'Must be between $min and $max';
      }
      return null;
    };
  }

  /// Validate password strength
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) return null;

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Validate password match
  static String? Function(String?) passwordMatch(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value != password) {
        return 'Passwords do not match';
      }
      return null;
    };
  }

  /// Validate date format (YYYY-MM-DD)
  static String? date(String? value) {
    if (value == null || value.isEmpty) return null;

    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value)) {
      return 'Please enter a valid date (YYYY-MM-DD)';
    }

    try {
      DateTime.parse(value);
    } on Exception catch (_) {
      return 'Please enter a valid date';
    }

    return null;
  }

  /// Validate age (must be above minimum)
  static String? Function(String?) minimumAge(int minAge) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      try {
        final birthDate = DateTime.parse(value);
        final today = DateTime.now();
        final age =
            today.year -
            birthDate.year -
            (today.month < birthDate.month ||
                    (today.month == birthDate.month &&
                        today.day < birthDate.day)
                ? 1
                : 0);

        if (age < minAge) {
          return 'Must be at least $minAge years old';
        }
      } on Exception catch (_) {
        return 'Please enter a valid date';
      }

      return null;
    };
  }

  /// Validate roll number format (alphanumeric)
  static String? rollNumber(String? value) {
    if (value == null || value.isEmpty) return null;

    final rollRegex = RegExp(r'^[A-Za-z0-9-]+$');
    if (!rollRegex.hasMatch(value)) {
      return 'Roll number can only contain letters, numbers, and hyphens';
    }

    return null;
  }

  /// Validate percentage (0-100)
  static String? percentage(String? value) {
    if (value == null || value.isEmpty) return null;

    final numValue = num.tryParse(value);
    if (numValue == null) {
      return 'Please enter a valid number';
    }

    if (numValue < 0 || numValue > 100) {
      return 'Percentage must be between 0 and 100';
    }

    return null;
  }

  /// Validate grade (A-F or A+ to F)
  static String? grade(String? value) {
    if (value == null || value.isEmpty) return null;

    final gradeRegex = RegExp(r'^[A-F][+-]?$', caseSensitive: false);
    if (!gradeRegex.hasMatch(value.toUpperCase())) {
      return 'Please enter a valid grade (A-F)';
    }

    return null;
  }

  /// Compose multiple validators
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }

  /// Custom regex validator
  static String? Function(String?) regex(RegExp pattern, String errorMessage) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (!pattern.hasMatch(value)) {
        return errorMessage;
      }
      return null;
    };
  }

  /// Validate that value matches another field
  static String? Function(String?) match(
    String otherValue, {
    String? fieldName,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value != otherValue) {
        return fieldName != null
            ? 'Must match $fieldName'
            : 'Values do not match';
      }
      return null;
    };
  }

  /// Validate alphanumeric only
  static String? alphanumeric(String? value) {
    if (value == null || value.isEmpty) return null;

    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!alphanumericRegex.hasMatch(value)) {
      return 'Only letters and numbers are allowed';
    }
    return null;
  }

  /// Validate no whitespace
  static String? noWhitespace(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.contains(' ')) {
      return 'Whitespace is not allowed';
    }
    return null;
  }

  /// Validate credit card number (Luhn algorithm)
  static String? creditCard(String? value) {
    if (value == null || value.isEmpty) return null;

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    // Check if only digits
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return 'Please enter a valid credit card number';
    }

    // Check length (13-19 digits)
    if (cleaned.length < 13 || cleaned.length > 19) {
      return 'Please enter a valid credit card number';
    }

    // Luhn algorithm
    var sum = 0;
    var alternate = false;

    for (var i = cleaned.length - 1; i >= 0; i--) {
      var digit = int.parse(cleaned[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }

      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return 'Please enter a valid credit card number';
    }

    return null;
  }

  /// Validate file extension
  static String? Function(String?) fileExtension(
    List<String> allowedExtensions,
  ) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      final extension = value.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        return 'File must be one of: ${allowedExtensions.join(", ")}';
      }
      return null;
    };
  }
}

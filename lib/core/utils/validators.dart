import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

/// Centralized form validation methods.
class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Validates email field
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errEmailRequired;
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return AppStrings.errEmailInvalid;
    }
    return null;
  }

  /// Validates password field
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.errPasswordRequired;
    }
    if (value.length < AppConstants.minPasswordLength) {
      return AppStrings.errPasswordTooShort;
    }
    return null;
  }

  /// Validates password confirmation match
  static String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return AppStrings.errPasswordRequired;
    }
    if (value != originalPassword) {
      return AppStrings.errPasswordMismatch;
    }
    return null;
  }

  /// Validates task title
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errTitleRequired;
    }
    return null;
  }

  /// Validates task description
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errDescriptionRequired;
    }
    return null;
  }
}

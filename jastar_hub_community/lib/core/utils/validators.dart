/// Form field validators for the application.
class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? email(String? value, {String? emptyMsg, String? invalidMsg}) {
    if (value == null || value.trim().isEmpty) {
      return emptyMsg ?? 'Email is required';
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return invalidMsg ?? 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value,
      {String? emptyMsg, String? shortMsg, int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return emptyMsg ?? 'Password is required';
    }
    if (value.length < minLength) {
      return shortMsg ?? 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password,
      {String? emptyMsg, String? mismatchMsg}) {
    if (value == null || value.isEmpty) {
      return emptyMsg ?? 'Confirm your password';
    }
    if (value != password) {
      return mismatchMsg ?? 'Passwords don\'t match';
    }
    return null;
  }

  static String? name(String? value, {String? emptyMsg}) {
    if (value == null || value.trim().isEmpty) {
      return emptyMsg ?? 'Name is required';
    }
    return null;
  }

  static String? notEmpty(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }
}

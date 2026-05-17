/// App-wide constants
class AppConstants {
  AppConstants._();

  // API
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userTypeKey = 'user_type';
  static const String userDataKey = 'user_data';

  // Pagination
  static const int defaultPageSize = 20;

  // Validation
  static const int minPasswordLength = 8;
  static const int phoneNumberLength = 11;
  static const int otpLength = 4;
}

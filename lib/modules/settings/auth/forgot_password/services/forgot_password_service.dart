import '../models/forgot_password_models.dart';

class ForgotPasswordService {
  Future<ForgotPasswordOtpResult> verifyOtp(
    ForgotPasswordOtpVerifyPayload payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));

    final responseJson = <String, dynamic>{
      'email': payload.email,
      'reset_token': 'fp-${DateTime.now().millisecondsSinceEpoch}',
      'verified': payload.code.length == 4,
    };

    return ForgotPasswordOtpResult.fromJson(responseJson);
  }

  Future<ForgotPasswordResendResult> resendCode(
    ForgotPasswordResendPayload payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 240));

    final responseJson = <String, dynamic>{
      'email': payload.email,
      'sent': true,
      'resend_seconds': 55,
    };

    return ForgotPasswordResendResult.fromJson(responseJson);
  }

  Future<ResetPasswordResult> resetPassword(
    ResetPasswordPayload payload,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 320));

    final responseJson = <String, dynamic>{
      'password_updated': payload.password.isNotEmpty,
    };

    return ResetPasswordResult.fromJson(responseJson);
  }
}

class EndpointPaths {
  // Auth Endpoints
  static const getGoogleRedirect = '/app/auth/google';

  static const registerCheckEmail = '/app/register/with-email/check-email';
  static const registerWithEmail = '/app/register/with-email/submit';
  static const registerVerifyEmailOtp = '/app/register/with-email/verify-otp';

  static const registerSendPhoneOtp = '/app/register/with-phone/send-otp';
  static const registerCheckPhoneOtp = '/app/register/with-phone/check-otp';
  static const registerWithPhone = '/app/register/with-phone/submit';

  static const loginWithEmail = '/app/login/with-email';
  static const loginSendPhoneOtp = '/app/login/with-phone/send-otp';
  static const loginWithPhone = '/app/login/with-phone/submit';

  static const thirdPartyLogin = '/app/third-party-login';

  static const logout = '/app/logout';
  static const logoutAll = '/app/logout-all';

  static const sendVerificationEmail = '/app/send-verification-email';

  static const forgotPassword = '/app/forgot-password';

  static const generateIdentifier = '/app/guests/generate-identifier';

  // Version Endpoints
  static const versions = '/versions';

  static translations(String languageCode) => '/app/local-translations/$languageCode';
}

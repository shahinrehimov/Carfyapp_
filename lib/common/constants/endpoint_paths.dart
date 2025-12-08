class EndpointPaths {
  static const getGoogleRedirect = '/auth/google';

  static const registerCheckEmail = '/register/with-email/check-email';
  static const registerWithEmail = '/register/with-email/submit';
  static const registerVerifyEmailOtp = '/register/with-email/verify-otp';

  static const registerSendPhoneOtp = '/register/with-phone/send-otp';
  static const registerCheckPhoneOtp = '/register/with-phone/check-otp';
  static const registerWithPhone = '/register/with-phone/submit';

  static const loginWithEmail = '/login/with-email';
  static const loginSendPhoneOtp = '/login/with-phone/send-otp';
  static const loginWithPhone = '/login/with-phone/submit';

  static const thirdPartyLogin = '/third-party-login';

  static const logout = '/logout';
  static const logoutAll = '/logout-all';

  static const sendVerificationEmail = '/send-verification-email';

  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  static const generateIdentifier = '/guests/generate-identifier';
}

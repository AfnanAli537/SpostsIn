class Endpoints {
  static const String login = "/api/Auth/login";
  static const String signUpPlayer = "/api/Auth/register/player";
  static const String signUpCoach = "/api/Auth/register/coach";
  static const String signUpScout = "/api/Auth/register/scout";
  static const String signUpClub = "/api/Auth/register/club";
  static const String signUpInstitute = "/api/Auth/register/institute";
  static const String signUpOther = "/api/Auth/register/other";
  static const String sendOtp= "/api/Auth/forgot-password";
  static const String verifyOtp  = "/api/Auth/verify-reset-code";
  static const String resetPassword  = "/api/Auth/reset-password";
  static const String googleSignUp = "/api/Auth/google-login";

  static const String sendVerifyRegisterOtp= "/api/Auth/send-gmail-code";
  static const String verifyRegisterOtp  = "/api/Auth/confirm-gmail-code";
}

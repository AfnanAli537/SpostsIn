class Endpoints {
  static const String login = "/api/Auth/login";
  static const String signUpPlayer = "/api/Auth/register/player";
  static const String signUpCoach = "/api/Auth/register/coach";
  static const String signUpScout = "/api/Auth/register/scout";
  static const String signUpClub = "/api/Auth/register/club";
  static const String signUpInstitute = "/api/Auth/register/institute";
  static const String signUpOther = "/api/Auth/register/other";
  
  static const String  sendOtp= "/api/Auth/register/sendOTP";
  static const String verifyOtp  = "/api/Auth/register/VERIFYotp";
  static const String resetPassword  = "/api/Auth/register/RESETpassword";
  static const String googleSignUp = "/auth/google";

}

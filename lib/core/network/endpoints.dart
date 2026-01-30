class Endpoints {
  static const String login = "/api/Auth/login";
  static const String signUpPlayer = "/api/Auth/register/player";
  static const String signUpCoach = "/api/Auth/register/coach";
  static const String signUpScout = "/api/Auth/register/scout";
  static const String signUpClub = "/api/Auth/register/club";
  static const String signUpInstitute = "/api/Auth/register/institute";
  static const String signUpOther = "/api/Auth/register/other";
  static const String  sendOtp= "/api/Auth/forgot-password";
  static const String verifyOtp  = "/api/Auth/verify-reset-code";
  static const String resetPassword  = "/api/Auth/reset-password";
  static const String googleSignUp = "/api/Auth/google-login";
  //post
  static const String  allPosts="/api/Posts/feed";
  static const String  postPost= "/api/Posts";
 static const String putLike = "/api/Posts/{id}/like";
 static const String putComment= "/api/Posts/{id}/comment";
 static const String getLikes= "/api/Posts/{id}/likes";
 static const String getComments= "/api/Posts/{id}/comments";
 static const String editComment="/api/Posts/comments/{commentId}";
  static const String deletComment= "/api/Posts/comments/{commentId}";

}
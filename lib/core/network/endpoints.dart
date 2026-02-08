class Endpoints {
  static const String login = "/api/Auth/login";
  static const String signUpPlayer = "/api/Auth/register/player";
  static const String signUpCoach = "/api/Auth/register/coach";
  static const String signUpScout = "/api/Auth/register/scout";
  static const String signUpClub = "/api/Auth/register/club";
  static const String signUpInstitute = "/api/Auth/register/institute";
  static const String signUpOther = "/api/Auth/register/other";
  static const String sendOtp = "/api/Auth/forgot-password";
  static const String verifyOtp = "/api/Auth/verify-reset-code";
  static const String resetPassword = "/api/Auth/reset-password";
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


  static const String sendVerifyRegisterOtp = "/api/Auth/send-gmail-code";
  static const String verifyRegisterOtp = "/api/Auth/confirm-gmail-code";

  // Profile Endpoints
  static const String getProfile = "/api/Profile/get-profile";
  static const String getMyProfile = "/api/Profile/my-profile";
  
  // Posts Endpoints
  static const String getPosts = allPosts; 
  
  static const String getOpportunities = "/api/Profile/opportunities";
  static const String getCourses = "/api/Profile/courses";
  
  // Achievements Endpoints
  static const String getAchievements = "/api/Achievements/user";
  static const String createAchievement = "/api/Achievements";
  static const String updateAchievement = "/api/Achievements";
  static const String deleteAchievement = "/api/Achievements";
  
  static const String getAnalyzedVideos = "/api/Profile/analyzed-videos";
  static const String getInterests = "/api/Profile/interests";
  static const String toggleFollow = "/api/Profile/follow";
  static const String toggleConnect = "/api/Profile/connect";
  
  //opportunities Endpoints
  static const String getOpportunity  = "/api/Opportunity";
  static const String postOpportunity = "/api/Opportunity";
  static const String opportunityDetails = "/api/Opportunity/{id}";
  static const String editOpportunity = "/api/Opportunity/{id}";
  static const String deleteOpportunity = "/api/Opportunity/{id}";
  static const String opportunityToggle  = "/api/Opportunity/{id}";
  static const String  applyOpportunity= "/api/Opportunity/{id}/apply";
  static const String getApplicants = "/api/Opportunity/{id}/applicants";
  static const String getActiveOp  = "/api/Opportunity/my-active";
  static const String getInActiveOp  = "/api/Opportunity/my-inactive";
  static const String detectAcceptOrReject = "/api/Opportunity/applications/{applicationId}/status";



}

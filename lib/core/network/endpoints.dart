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
  static const String allPosts = "/api/Posts/feed";
  static const String postPost = "/api/Posts";
  static const String putPost = '/api/Posts/{id}';
  static const String deletePost = '/api/Posts/{id}';
  static const String postToggleVisibility =
      '/api/Posts/{id}/toggle-visibility';

  static const String putLike = "/api/Posts/{id}/like";
  static const String putComment = "/api/Posts/{id}/comment";
  static const String getLikes = "/api/Posts/{id}/likes";
  static const String getComments = "/api/Posts/{id}/comments";
  static const String editComment = "/api/Posts/comments/{commentId}";
  static const String deletComment = "/api/Posts/comments/{commentId}";

  static const String sendVerifyRegisterOtp = "/api/Auth/send-gmail-code";
  static const String verifyRegisterOtp = "/api/Auth/confirm-gmail-code";

  //static const String  allPosts="/api/Posts/feed";//(get) posts, have parameter for targetUserId and also uses pagination, takes page and size

  //Profile Endpoints
  static const String getProfile =
      "/api/Profile/{userId}"; //(get) profile by userId as a parameter
  static const String updateProfile =
      "/api/Profile/Update"; //(put) update the profile take the date from the get and put it in the update body as default value the Request body is the same as the responce body from the profile get
  static const String myActiveOpportunities =
      "/api/Opportunity/my-active"; //(get) takes page and pageSize parameters and get list of my active opportunities
  static const String getCourses =
      "/api/Profile/courses"; //keep for the courses the mock data for now
  static const String sendConnectionRequest = '/api/Social/connect';
  static const String removeContact = '/api/Social/connect/{targetId}';
  static const String respondConnection = '/api/Social/respond-connection';
  static const String connectionRequests = '/api/Social/connection-requests';
  static const String contacts = '/api/Chat/contacts';
  static const String getOpportunities =
      "/api/Opportunity/{targetUserId}/Target";

  // Achievements Endpoints
  static const String getAchievements =
      "/api/Achievements/user/{userId}"; //(get) Achievements, have parameter for userId and also uses pagination, takes page and size
  static const String getAchievement =
      "/api/Achievements/{id}"; //(get) one Achievement, have parameter id for achievement details screen
  static const String createAchievement =
      "/api/Achievements"; //(post) one Achievement, the request body takes Title* (string), Description* (string), AchievementDate (string($date-time)), and MediaFile (string($binary)) takes an image
  static const String updateAchievement =
      "/api/Achievements/{id}"; //(put) one Achievement, have parameter achievement id and the request body takes Title* (string), Description* (string), AchievementDate (string($date-time)), and MediaFile (string($binary)) takes an image
  static const String deleteAchievement =
      "/api/Achievements/{id}"; //(delete) have parameter id of the achievement

  //opportunities Endpoints
  static const String getOpportunity = "/api/Opportunity";
  static const String postOpportunity = "/api/Opportunity";
  static const String opportunityDetails = "/api/Opportunity/{id}";
  static const String editOpportunity = "/api/Opportunity/{id}";
  static const String deleteOpportunity = "/api/Opportunity/{id}";
  static const String opportunityToggle = "/api/Opportunity/{id}/toggle";
  static const String applyOpportunity = "/api/Opportunity/{id}/apply";
  static const String getApplicants = "/api/Opportunity/{id}/applicants";
  static const String getActiveOp = "/api/Opportunity/my-active";
  static const String getInActiveOp = "/api/Opportunity/my-inactive";
  static const String detectAcceptOrReject =
      "/api/Opportunity/applications/{applicationId}/status";

  static const String getAnalyzedVideos =
      "/api/Profile/analyzed-videos"; //leave as mock data for now
  static const String getInterests =
      "/api/Profile/interests"; //there is no end points but I will put an actual users with there id and role in order to try to navigate to an actual different users by using the get profile endpoint to also view the follow and connect status
  static const String toggleFollow =
      "/api/Social/follow/{targetId}"; //(post) takes the targetId  as a parameter
  static const String toggleConnect =
      "/api/Social/connect"; //(post) takes the { "receiverId": "string" } in the request body and the connection now in pendding state so there is 3 states in totle (not connect, pending, connected)
  //payment
  static const String search = "/api/Search/explore";
  //payment
  static const String initiate = "/api/Payments/initiate";
  static const String showPlans = '/api/Payments/plans';
  static const String mySubscription = "/api/Payments/my-subscription";
  static const String manualActivate =
      "/api/Payments/admin/manual-activate/{orderId}";
  // Browse & Discovery
  static const String availableCourses = "/api/Courses/available";
  static const String enrolledCourses = "/api/Courses/enrolled";
  static const String createdCourses = "/api/Courses/created";

  // Course CRU
  static const String createCourse = "/api/Courses";
  static const String courseById = "/api/Courses/{id}";
  static const String updateCourse = "/api/Courses/{id}";
  static const String deleteCourse = "/api/Courses/{id}";

  // Lesson
  static const String courseLessons = "/api/Courses/{id}/lessons";
  static const String addLesson = "/api/Courses/{courseId}/lessons";
  static const String updateLesson = "/api/Courses/lessons/{lessonId}";
  static const String deleteLesson = "/api/Courses/lessons/{lessonId}";

  // Enrollment
  static const String enrollCourse = "/api/Courses/{id}/enroll";
  static const String enrolledUsers = "/api/Courses/{id}/enrolled-users";

  // Progress
  static const String lessonProgress =
      "/api/Courses/lessons/{lessonId}/progress";

  // Analytics (Provider)
  static const String revenueReport = "/api/Courses/{courseId}/revenue-report";

  static const String adsFeed = '/api/Advertisements/feed';
  static const String createAd = '/api/Advertisements';
  static const String updateAd = '/api/Advertisements/{id}';
  static const String deleteAd = '/api/Advertisements/{id}';
  static const String getAdById = '/api/Advertisements/{id}';
  static const String toggleAdStatus = '/api/Advertisements/{id}/toggle-status';
  static const String userAds = '/api/Advertisements/user-ads';
  static const String adsDashboard = '/api/Advertisements/dashboard';
  static const String logAdClick = '/api/Advertisements/{id}/click';
  static const String sendAdProgress = '/api/Advertisements/{id}/progress';
  static const String likeAd = '/api/Advertisements/{id}/like';
  static const String getAdLikers = '/api/Advertisements/{id}/likers';
  static const String addAdComment = '/api/Advertisements/{id}/comments';
  static const String getAdComments = '/api/Advertisements/{id}/comments';
  static const String editAdComment =
      '/api/Advertisements/comments/{commentId}';
  static const String deleteAdComment =
      '/api/Advertisements/comments/{commentId}';
}

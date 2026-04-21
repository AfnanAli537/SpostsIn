class Endpoints {
  static const String login = "/api/Auth/login";
  static const String signUpPlayer = "/api/Auth/register/player";
  static const String signUpCoach = "/api/Auth/register/coach";
  static const String certifications = "/api/Lookups/certifications";
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
 
static const String getPostById = '/api/Posts/{id}';
  static const String putLike = "/api/Posts/{id}/like";
  static const String putComment = "/api/Posts/{id}/comment";
  static const String getLikes = "/api/Posts/{id}/likes";
  static const String getComments = "/api/Posts/{id}/comments";
  static const String postProgress = "/api/Posts/{id}/progress";
  static const String editComment = "/api/Posts/comments/{commentId}";
  static const String deleteComment = "/api/Posts/comments/{commentId}";

  static const String sendVerifyRegisterOtp = "/api/Auth/send-gmail-code";
  static const String verifyRegisterOtp = "/api/Auth/confirm-gmail-code";

  //static const String  allPosts="/api/Posts/feed";//(get) posts, have parameter for targetUserId and also uses pagination, takes page and size

  //Profile Endpoints
  static const String getProfile =
      "/api/Profile/{userId}";
  static const String updateProfile =
      "/api/Profile/Update"; 
  static const String myActiveOpportunities =
      "/api/Opportunity/my-active";
  static const String getCourses =
      "/api/Profile/courses"; 
  static const String sendConnectionRequest = '/api/Social/connect';
  static const String removeContact = '/api/Social/connect/{targetId}';
  static const String respondConnection = '/api/Social/respond-connection';
  static const String connectionRequests = '/api/Social/connection-requests';
  static const String contacts = '/api/Chat/contacts';
  static const String userConnections = '/api/Social/{userId}/connections';
  static const String getOpportunities =
      "/api/Opportunity/{targetUserId}/Target";

  // Achievements Endpoints
  static const String getAchievements =
      "/api/Achievements/user/{userId}"; 
  static const String getAchievement =
      "/api/Achievements/{id}"; 
  static const String createAchievement =
      "/api/Achievements"; 
  static const String updateAchievement =
      "/api/Achievements/{id}"; 
  static const String deleteAchievement =
      "/api/Achievements/{id}";

  //opportunities Endpoints
  static const String getOpportunity = "/api/Opportunity";
  static const String postOpportunity = "/api/Opportunity";
  static const String opportunityDetails = "/api/Opportunity/{id}";
  static const String getOpportunityRecommendations =
     '/api/Opportunity/{id}/recommendations';
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
      "/api/Profile/interests";
  static const String toggleFollow =
      "/api/Social/follow/{targetId}"; 
  static const String toggleConnect =
      "/api/Social/connect"; 
  static const String userFollowers = '/api/Social/{userId}/followers';
  static const String userFollowing = '/api/Social/{userId}/following';
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



  static const String adsFeed            = '/api/Advertisements/feed';
static const String createAd           = '/api/Advertisements';
static const String updateAd           = '/api/Advertisements/{id}';
static const String deleteAd           = '/api/Advertisements/{id}';
static const String getAdById          = '/api/Advertisements/{id}';
static const String toggleAdStatus     = '/api/Advertisements/{id}/toggle-status';
static const String userAds            = '/api/Advertisements/user-ads';
static const String adsDashboard       = '/api/Advertisements/dashboard';
static const String logAdClick         = '/api/Advertisements/{id}/click';
static const String sendAdProgress     = '/api/Advertisements/{id}/progress';
static const String likeAd             = '/api/Advertisements/{id}/like';
static const String getAdLikers        = '/api/Advertisements/{id}/likers';
static const String addAdComment       = '/api/Advertisements/{id}/comments';
static const String getAdComments      = '/api/Advertisements/{id}/comments';
static const String editAdComment      = '/api/Advertisements/comments/{commentId}';
static const String deleteAdComment    = '/api/Advertisements/comments/{commentId}';



// ── Notification ──────────────────────────────────────────────────────────────
static const String getNotifications         = '/api/Notification';
static const String getUnreadCount           = '/api/Notification/unread-count';
static const String markNotificationAsRead   = '/api/Notification/{id}/read';
static const String markAllNotificationsAsRead = '/api/Notification/read-all';







//chat 
static const String getAllChats ="/api/Chat/list";
static const String getContacts ="/api/Chat/contacts";
static const String chatSearch ="/api/Chat/search";
static const String sendMessage ="/api/Chat/send";
static const String getAllMessages ="/api/Chat/history";
static const String createGroup ="/api/Chat/group/create";
static const String editMessage ="/api/Chat/message/edit/{id}";
static const String deleteMessage ="/api/Chat/message/delete/{id}";

// ─── Chatbot ──────────────────────────────────────────────────────────────────
static const String chatbotAsk             = '/api/Chatbot/ask';
static const String chatbotGetSessions     = '/api/Chatbot/get-sessions';
static const String chatbotGetMessages     = '/api/Chatbot/get-messages/{sessionId}';
static const String chatbotDeleteSession   = '/api/Chatbot/delete-session/{sessionId}';
static const String chatbotRenameSession   = '/api/Chatbot/rename-session/{sessionId}';


}

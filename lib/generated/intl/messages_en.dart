// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(percentage) => "${percentage}% complete";

  static String m1(count) =>
      "${Intl.plural(count, one: '${count} day ago', other: '${count} days ago')}";

  static String m2(lessonTitle) =>
      "Are you sure you want to delete \"${lessonTitle}\"? This action cannot be undone.";

  static String m3(duration) => "Duration: ${duration}";

  static String m4(price) => "Enroll for ${price}";

  static String m5(count) => "${count} enrolled";

  static String m6(field) => "Please enter your ${field}";

  static String m7(field) => "${field} is too short";

  static String m8(count) =>
      "${Intl.plural(count, one: '${count} hour ago', other: '${count} hours ago')}";

  static String m9(field) => "Invalid ${field}";

  static String m10(number) => "${number} Lesson";

  static String m11(order) => "Lesson order: ${order}";

  static String m12(order, duration) =>
      "Lesson order: ${order} • Duration: ${duration}";

  static String m13(count) => "${count} lessons";

  static String m14(completed, total) => "${completed} / ${total} Lessons";

  static String m15(count) =>
      "${Intl.plural(count, one: '${count} minute ago', other: '${count} minutes ago')}";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} month ago', other: '${count} months ago')}";

  static String m17(searchTerm) => "No courses found for \"${searchTerm}\"";

  static String m18(month) => "No data available for ${month}";

  static String m19(percentage) => "${percentage}% Complete";

  static String m20(percentage) => "${percentage}% watched";

  static String m21(count) =>
      "${Intl.plural(count, one: '${count} second ago', other: '${count} seconds ago')}";

  static String m22(field) => "Please select a ${field}";

  static String m23(count) =>
      "${Intl.plural(count, one: '${count} week ago', other: '${count} weeks ago')}";

  static String m24(count) =>
      "${Intl.plural(count, one: '${count} year ago', other: '${count} years ago')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "GetYourCode": MessageLookupByLibrary.simpleMessage("Get Your Code !"),
    "VerifyAndProceed": MessageLookupByLibrary.simpleMessage(
      "Verify and proceed",
    ),
    "aboutUs": MessageLookupByLibrary.simpleMessage("About us"),
    "accept": MessageLookupByLibrary.simpleMessage("Accept"),
    "accepted": MessageLookupByLibrary.simpleMessage("Accepted"),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "achievement": MessageLookupByLibrary.simpleMessage("Achievement"),
    "achievementDeleted": MessageLookupByLibrary.simpleMessage(
      "Achievement deleted successfully",
    ),
    "achievementUpdated": MessageLookupByLibrary.simpleMessage(
      "Achievement updated successfully",
    ),
    "achievement_added_success": MessageLookupByLibrary.simpleMessage(
      "Achievement added successfully",
    ),
    "achievement_updated_success": MessageLookupByLibrary.simpleMessage(
      "Achievement updated successfully",
    ),
    "achievements": MessageLookupByLibrary.simpleMessage("Achievements"),
    "activities": MessageLookupByLibrary.simpleMessage("Activities"),
    "addAComment": MessageLookupByLibrary.simpleMessage("Add a comment..."),
    "addAccount": MessageLookupByLibrary.simpleMessage("Add Account"),
    "addAchievement": MessageLookupByLibrary.simpleMessage(
      "Added New Achievement",
    ),
    "addLater": MessageLookupByLibrary.simpleMessage("Add Later"),
    "addLesson": MessageLookupByLibrary.simpleMessage("Add Lesson"),
    "addLessonQuestion": MessageLookupByLibrary.simpleMessage(
      "Would you like to add a lesson to this course now?",
    ),
    "addNow": MessageLookupByLibrary.simpleMessage("Add Now"),
    "add_achievement_title": MessageLookupByLibrary.simpleMessage(
      "Add Achievement",
    ),
    "age": MessageLookupByLibrary.simpleMessage("Age"),
    "agreeLabel": MessageLookupByLibrary.simpleMessage("I agree"),
    "algeria": MessageLookupByLibrary.simpleMessage("Algeria"),
    "all": MessageLookupByLibrary.simpleMessage("All"),
    "allTimeRevenue": MessageLookupByLibrary.simpleMessage("All-Time Revenue"),
    "alreadyApplied": MessageLookupByLibrary.simpleMessage("Already Applied"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "analyzeVideo": MessageLookupByLibrary.simpleMessage("Analyze Video"),
    "analyzeVideoComingSoon": MessageLookupByLibrary.simpleMessage(
      "Analyze video feature coming soon",
    ),
    "analyzedPeople": MessageLookupByLibrary.simpleMessage("Analyzed People"),
    "analyzedVideosReports": MessageLookupByLibrary.simpleMessage(
      "Analyzed Videos Reports",
    ),
    "applicants": MessageLookupByLibrary.simpleMessage("Applicants"),
    "applicationSubmittedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Application submitted successfully!",
    ),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "applyNow": MessageLookupByLibrary.simpleMessage("Apply Now"),
    "applyOpportunity": MessageLookupByLibrary.simpleMessage(
      "Apply opportunity",
    ),
    "april": MessageLookupByLibrary.simpleMessage("April"),
    "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
    "archive": MessageLookupByLibrary.simpleMessage("Archive"),
    "archiveOpportunities": MessageLookupByLibrary.simpleMessage(
      "Archive Opportunities",
    ),
    "archivePost": MessageLookupByLibrary.simpleMessage("Archive Post"),
    "archivePostConfirmation": MessageLookupByLibrary.simpleMessage(
      "this post will be archived and hidden from your profile and feed, but you can restore it later. Are you sure you want to archive this post?",
    ),
    "archivePosts": MessageLookupByLibrary.simpleMessage("Archive Posts"),
    "august": MessageLookupByLibrary.simpleMessage("August"),
    "available": MessageLookupByLibrary.simpleMessage("Available"),
    "availableCourses": MessageLookupByLibrary.simpleMessage(
      "Available Courses",
    ),
    "avgProgress": MessageLookupByLibrary.simpleMessage("Avg Progress"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "badRequest": MessageLookupByLibrary.simpleMessage("Invalid request"),
    "basketball": MessageLookupByLibrary.simpleMessage("Basketball"),
    "basketballer": MessageLookupByLibrary.simpleMessage("Basketballer"),
    "beTheFirstToCreatePost": MessageLookupByLibrary.simpleMessage(
      "Be the first to create a post!",
    ),
    "bio": MessageLookupByLibrary.simpleMessage("Description"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelEdit": MessageLookupByLibrary.simpleMessage("Cancel Edit"),
    "center": MessageLookupByLibrary.simpleMessage("Center"),
    "centerBack": MessageLookupByLibrary.simpleMessage("Center Back"),
    "changePassword": MessageLookupByLibrary.simpleMessage("Change Password"),
    "changeVideo": MessageLookupByLibrary.simpleMessage("Change Video"),
    "changesBody": MessageLookupByLibrary.simpleMessage(
      "We may update this Privacy Policy from time to time. Any significant changes will be communicated through the app.",
    ),
    "changesTitle": MessageLookupByLibrary.simpleMessage(
      "Changes to This Policy",
    ),
    "chat": MessageLookupByLibrary.simpleMessage("Chat"),
    "chats": MessageLookupByLibrary.simpleMessage("Chats"),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearFilters": MessageLookupByLibrary.simpleMessage("Clear filters"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "club": MessageLookupByLibrary.simpleMessage("Club"),
    "clubName": MessageLookupByLibrary.simpleMessage("Club name"),
    "coach": MessageLookupByLibrary.simpleMessage("Coach"),
    "commentAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Comment added successfully",
    ),
    "commentDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Comment deleted successfully",
    ),
    "commentUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Comment updated successfully",
    ),
    "comments": MessageLookupByLibrary.simpleMessage("Comments"),
    "completePercentage": m0,
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "confirmPasswordIsRequired": MessageLookupByLibrary.simpleMessage(
      "Confirm password is required",
    ),
    "conflict": MessageLookupByLibrary.simpleMessage("Data conflict occurred"),
    "connect": MessageLookupByLibrary.simpleMessage("Connect"),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "connectionError": MessageLookupByLibrary.simpleMessage(
      "Failed to connect",
    ),
    "connectionSuccess": MessageLookupByLibrary.simpleMessage(
      "Connected successfully!",
    ),
    "connectionTimedOut": MessageLookupByLibrary.simpleMessage(
      "Connection timed out. Please try again.",
    ),
    "connections": MessageLookupByLibrary.simpleMessage("Connections"),
    "contactBody": MessageLookupByLibrary.simpleMessage(
      "If you have any questions or concerns about this Privacy Policy, please contact us at: support@sportsin.app",
    ),
    "contactTitle": MessageLookupByLibrary.simpleMessage("Contact Us"),
    "contactUs": MessageLookupByLibrary.simpleMessage("Contact us"),
    "continueButton": MessageLookupByLibrary.simpleMessage("CONTINUE"),
    "continueText": MessageLookupByLibrary.simpleMessage("CONTINUE"),
    "continueWatching": MessageLookupByLibrary.simpleMessage(
      "Continue Watching",
    ),
    "continueWith": MessageLookupByLibrary.simpleMessage("or continue with"),
    "courseCreatedSuccess": MessageLookupByLibrary.simpleMessage(
      "Course created successfully",
    ),
    "courseDeleted": MessageLookupByLibrary.simpleMessage("Course deleted"),
    "courseDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Course Description",
    ),
    "courseProgress": MessageLookupByLibrary.simpleMessage("Course Progress"),
    "courseThumbnail": MessageLookupByLibrary.simpleMessage("Course Thumbnail"),
    "courseTitleHint": MessageLookupByLibrary.simpleMessage("Course Title"),
    "courses": MessageLookupByLibrary.simpleMessage("Courses"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createAchievement": MessageLookupByLibrary.simpleMessage(
      "Create Achievement",
    ),
    "createAdvertisement": MessageLookupByLibrary.simpleMessage(
      "Create Advertisement",
    ),
    "createCourse": MessageLookupByLibrary.simpleMessage("Create Course"),
    "createOpportunity": MessageLookupByLibrary.simpleMessage(
      "Create opportunity",
    ),
    "createPost": MessageLookupByLibrary.simpleMessage("Create Post"),
    "createYourAccount": MessageLookupByLibrary.simpleMessage(
      "Create your Account",
    ),
    "currentVideo": MessageLookupByLibrary.simpleMessage("Current video"),
    "currentlyInClub": MessageLookupByLibrary.simpleMessage(
      "Currently in a Club",
    ),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "date_label": MessageLookupByLibrary.simpleMessage("Date"),
    "daysAgo": m1,
    "december": MessageLookupByLibrary.simpleMessage("December"),
    "defender": MessageLookupByLibrary.simpleMessage("Defender"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteComment": MessageLookupByLibrary.simpleMessage("Delete Comment"),
    "deleteCommentConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this comment?",
    ),
    "deleteCourse": MessageLookupByLibrary.simpleMessage("Delete Course"),
    "deleteCourseConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this course?",
    ),
    "deleteLesson": MessageLookupByLibrary.simpleMessage("Delete Lesson"),
    "deleteLessonConfirmation": m2,
    "deleteOpportunity": MessageLookupByLibrary.simpleMessage(
      "Delete Opportunity",
    ),
    "deleteOpportunityConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this opportunity? This action cannot be undone.",
    ),
    "deletePost": MessageLookupByLibrary.simpleMessage("Delete Post"),
    "deletePostConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this post?",
    ),
    "deleteachievement": MessageLookupByLibrary.simpleMessage(
      "Delete Achievement",
    ),
    "deleteachievementconfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this achievement?",
    ),
    "deletingLesson": MessageLookupByLibrary.simpleMessage(
      "Deleting lesson...",
    ),
    "deletingOpportunity": MessageLookupByLibrary.simpleMessage(
      "Deleting opportunity...",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "descriptionRequired": MessageLookupByLibrary.simpleMessage(
      "Description is required",
    ),
    "description_hint": MessageLookupByLibrary.simpleMessage(
      "Explain your achievement...",
    ),
    "description_label": MessageLookupByLibrary.simpleMessage("Description"),
    "details": MessageLookupByLibrary.simpleMessage("Details"),
    "disconnectSuccess": MessageLookupByLibrary.simpleMessage(
      "Disconnected successfully!",
    ),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "duration": m3,
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editCourse": MessageLookupByLibrary.simpleMessage("Edit Course"),
    "editLesson": MessageLookupByLibrary.simpleMessage("Edit Lesson"),
    "editPrice": MessageLookupByLibrary.simpleMessage("Edit Price"),
    "editProfile": MessageLookupByLibrary.simpleMessage("Edit Profile"),
    "editProfileFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to update profile.",
    ),
    "editProfileSuccess": MessageLookupByLibrary.simpleMessage(
      "Profile updated successfully!",
    ),
    "editYourComment": MessageLookupByLibrary.simpleMessage(
      "Edit your comment...",
    ),
    "edit_achievement": MessageLookupByLibrary.simpleMessage(
      "Edit Achievement",
    ),
    "editingComment": MessageLookupByLibrary.simpleMessage("Editing comment"),
    "egp": MessageLookupByLibrary.simpleMessage("EGP"),
    "egypt": MessageLookupByLibrary.simpleMessage("Egypt"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailAlreadyExists": MessageLookupByLibrary.simpleMessage(
      "This email is already registered",
    ),
    "emailVerfiy": MessageLookupByLibrary.simpleMessage("Email Verification"),
    "emptyEmail": MessageLookupByLibrary.simpleMessage("Email is required"),
    "emptyPassword": MessageLookupByLibrary.simpleMessage(
      "Password is required",
    ),
    "endDate": MessageLookupByLibrary.simpleMessage("End Date"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enroll": MessageLookupByLibrary.simpleMessage("Enroll"),
    "enrollForPrice": m4,
    "enrollNow": MessageLookupByLibrary.simpleMessage("Enroll Now"),
    "enrolled": MessageLookupByLibrary.simpleMessage("Enrolled"),
    "enrolledCount": m5,
    "enrolledCourses": MessageLookupByLibrary.simpleMessage("Enrolled Courses"),
    "enrolledSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Enrolled successfully",
    ),
    "enrolleesWillAppear": MessageLookupByLibrary.simpleMessage(
      "Enrolled students will appear here",
    ),
    "enterAge": MessageLookupByLibrary.simpleMessage("Please enter your age"),
    "enterCourseDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Enter Course Description",
    ),
    "enterCourseTitleHint": MessageLookupByLibrary.simpleMessage(
      "Course Title",
    ),
    "enterDate": MessageLookupByLibrary.simpleMessage("Please select a date"),
    "enterDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Enter description",
    ),
    "enterEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "enterEmailAddressHere": MessageLookupByLibrary.simpleMessage(
      "Enter Email Address here",
    ),
    "enterEmailAssociated": MessageLookupByLibrary.simpleMessage(
      "Enter Email Address associated with your account",
    ),
    "enterExperience": MessageLookupByLibrary.simpleMessage(
      "Please enter your Experience years.",
    ),
    "enterField": m6,
    "enterHeight": MessageLookupByLibrary.simpleMessage(
      "Please enter your height",
    ),
    "enterLessonTitleHint": MessageLookupByLibrary.simpleMessage(
      "Enter lesson title",
    ),
    "enterNewPassword": MessageLookupByLibrary.simpleMessage(
      "Enter your new password",
    ),
    "enterPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "enterPriceHint": MessageLookupByLibrary.simpleMessage(
      "Enter price (0 for free)",
    ),
    "enterWeight": MessageLookupByLibrary.simpleMessage(
      "Please enter your weight",
    ),
    "enterYourDescription": MessageLookupByLibrary.simpleMessage(
      "Enter Your Description...",
    ),
    "enterYourRequirements": MessageLookupByLibrary.simpleMessage(
      "Enter Requirements (one per line)...",
    ),
    "enterYourTitle": MessageLookupByLibrary.simpleMessage("Enter Your Title."),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorLoadingApplicants": MessageLookupByLibrary.simpleMessage(
      "Error loading applicants",
    ),
    "error_picking_image": MessageLookupByLibrary.simpleMessage(
      "Error picking image. Please try again.",
    ),
    "error_picking_video": MessageLookupByLibrary.simpleMessage(
      "Error picking video. Please try again.",
    ),
    "extractingDuration": MessageLookupByLibrary.simpleMessage(
      "Extracting duration...",
    ),
    "failedToLoadImage": MessageLookupByLibrary.simpleMessage(
      "Failed to load image",
    ),
    "failedToLoadVideo": MessageLookupByLibrary.simpleMessage(
      "Failed to load video",
    ),
    "failedToPlayVideo": MessageLookupByLibrary.simpleMessage(
      "Failed to play video",
    ),
    "failedToSendMessage": MessageLookupByLibrary.simpleMessage(
      "Failed to send message. Please try again.",
    ),
    "failedToTranslate": MessageLookupByLibrary.simpleMessage(
      "Failed to translate",
    ),
    "failed_to_read_video_duration": MessageLookupByLibrary.simpleMessage(
      "Failed to read video duration",
    ),
    "february": MessageLookupByLibrary.simpleMessage("February"),
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "field": MessageLookupByLibrary.simpleMessage("field"),
    "fieldTooShort": m7,
    "file_size_exceeds_limit": MessageLookupByLibrary.simpleMessage(
      "File size exceeds 500MB",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("First name"),
    "follow": MessageLookupByLibrary.simpleMessage("Follow"),
    "followError": MessageLookupByLibrary.simpleMessage("Failed to follow"),
    "followSuccess": MessageLookupByLibrary.simpleMessage(
      "Following successfully!",
    ),
    "followers": MessageLookupByLibrary.simpleMessage("Followers"),
    "following": MessageLookupByLibrary.simpleMessage("Following"),
    "football": MessageLookupByLibrary.simpleMessage("Football"),
    "footballer": MessageLookupByLibrary.simpleMessage("Footballer"),
    "forYou": MessageLookupByLibrary.simpleMessage("forYou"),
    "forbidden": MessageLookupByLibrary.simpleMessage("Access forbidden"),
    "forgetPassword": MessageLookupByLibrary.simpleMessage("Forget Password"),
    "forgetYourPassword": MessageLookupByLibrary.simpleMessage(
      "Forgot your password?",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password"),
    "forward": MessageLookupByLibrary.simpleMessage("Forward"),
    "foundDate": MessageLookupByLibrary.simpleMessage("Foundation date"),
    "free": MessageLookupByLibrary.simpleMessage("FREE"),
    "freeCourse": MessageLookupByLibrary.simpleMessage("Free Course"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
    "goalkeeper": MessageLookupByLibrary.simpleMessage("Goalkeeper"),
    "guest": MessageLookupByLibrary.simpleMessage("Guest"),
    "gymnast": MessageLookupByLibrary.simpleMessage("Gymnast"),
    "gymnastics": MessageLookupByLibrary.simpleMessage("Gymnastics"),
    "handball": MessageLookupByLibrary.simpleMessage("Handball"),
    "handballPlayer": MessageLookupByLibrary.simpleMessage("Handball Player"),
    "happyToSeeYouToday": MessageLookupByLibrary.simpleMessage(
      "Happy to see you today",
    ),
    "height": MessageLookupByLibrary.simpleMessage("Height (cm)"),
    "hi": MessageLookupByLibrary.simpleMessage("Hi"),
    "hideDescription": MessageLookupByLibrary.simpleMessage("Hide Description"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "hoursAgo": m8,
    "industary": MessageLookupByLibrary.simpleMessage("Industry"),
    "informationBody": MessageLookupByLibrary.simpleMessage(
      "When you use SportsIn, we may collect the following types of information:\n\n• Personal data: your name, email, profile photo, sports skills, and interests.\n• Activity data: posts, messages, likes, and other interactions.\n• Device data: device type, operating system, and IP address.",
    ),
    "informationTitle": MessageLookupByLibrary.simpleMessage(
      "Information We Collect",
    ),
    "institute": MessageLookupByLibrary.simpleMessage("Institute"),
    "instituteName": MessageLookupByLibrary.simpleMessage("Institute name"),
    "interests": MessageLookupByLibrary.simpleMessage("Interests"),
    "introductionBody": MessageLookupByLibrary.simpleMessage(
      "SportsIn is a professional social platform for athletes, coaches, and sports clubs to connect, share experiences, and discover opportunities.",
    ),
    "introductionTitle": MessageLookupByLibrary.simpleMessage("Introduction"),
    "invalidAge": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid age (5-99)",
    ),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "invalidEmailOrPassword": MessageLookupByLibrary.simpleMessage(
      "Invalid email or password.",
    ),
    "invalidExperience": MessageLookupByLibrary.simpleMessage(
      "Please enter your Experience years.",
    ),
    "invalidField": m9,
    "invalidHeight": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid height (100–250 cm)",
    ),
    "invalidPassword": MessageLookupByLibrary.simpleMessage("Invalid password"),
    "invalidPrice": MessageLookupByLibrary.simpleMessage("Invalid price"),
    "invalidVideoDuration": MessageLookupByLibrary.simpleMessage(
      "Invalid video duration. Please select another video.",
    ),
    "invalidWeight": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid weight (30–200 kg)",
    ),
    "january": MessageLookupByLibrary.simpleMessage("January"),
    "july": MessageLookupByLibrary.simpleMessage("July"),
    "june": MessageLookupByLibrary.simpleMessage("June"),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "knowingYourGoal": MessageLookupByLibrary.simpleMessage(
      "Knowing your goal helps us tailor your experience",
    ),
    "lastName": MessageLookupByLibrary.simpleMessage("Last name"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage(
      "Last updated: 11 October 2025",
    ),
    "latestCourses": MessageLookupByLibrary.simpleMessage("Latest Courses"),
    "latestPosts": MessageLookupByLibrary.simpleMessage("Latest posts"),
    "leftBack": MessageLookupByLibrary.simpleMessage("Left Back"),
    "leftWing": MessageLookupByLibrary.simpleMessage("Left Wing"),
    "lessonNumber": m10,
    "lessonOrder": m11,
    "lessonOrderAndDuration": m12,
    "lessonOrderSaved": MessageLookupByLibrary.simpleMessage(
      "Lesson order saved",
    ),
    "lessonTitle": MessageLookupByLibrary.simpleMessage("Lesson Title"),
    "lessons": MessageLookupByLibrary.simpleMessage("Lessons"),
    "lessonsCount": m13,
    "lessonsProgress": m14,
    "libero": MessageLookupByLibrary.simpleMessage("Libero"),
    "likes": MessageLookupByLibrary.simpleMessage("Likes"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading"),
    "loadingUserData": MessageLookupByLibrary.simpleMessage(
      "Loading user data...",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Location"),
    "loginSuccess": MessageLookupByLibrary.simpleMessage(
      "Welcome back,let’s get started!",
    ),
    "loginToYourAccount": MessageLookupByLibrary.simpleMessage(
      "Login to your Account",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("LOG OUT"),
    "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to logout?",
    ),
    "lowercaseValidation": MessageLookupByLibrary.simpleMessage(
      "At least 1 lowercase letter",
    ),
    "makeVideoAnalysis": MessageLookupByLibrary.simpleMessage(
      "Make Video Analysis",
    ),
    "male": MessageLookupByLibrary.simpleMessage("Male"),
    "manageAchievement": MessageLookupByLibrary.simpleMessage(
      "Manage Achievement",
    ),
    "manageAdvertisement": MessageLookupByLibrary.simpleMessage(
      "Manage Advertisement",
    ),
    "manageCourse": MessageLookupByLibrary.simpleMessage("Manage Course"),
    "manageOpportunities": MessageLookupByLibrary.simpleMessage(
      "Manage Opportunities",
    ),
    "managePosts": MessageLookupByLibrary.simpleMessage("Manage Posts"),
    "manageSubscription": MessageLookupByLibrary.simpleMessage(
      "Manage Subscription",
    ),
    "manageVideoAnalysis": MessageLookupByLibrary.simpleMessage(
      "Manage Video Analysis People",
    ),
    "march": MessageLookupByLibrary.simpleMessage("March"),
    "maxFileSize": MessageLookupByLibrary.simpleMessage("Max 500MB"),
    "maximumFileSize": MessageLookupByLibrary.simpleMessage(
      "Maximum file size is 200 MB",
    ),
    "may": MessageLookupByLibrary.simpleMessage("May"),
    "messageSent": MessageLookupByLibrary.simpleMessage(
      "Message sent successfully",
    ),
    "middleBlocker": MessageLookupByLibrary.simpleMessage("Middle Blocker"),
    "midfielder": MessageLookupByLibrary.simpleMessage("Midfielder"),
    "minLengthValidation": MessageLookupByLibrary.simpleMessage(
      "At least 8 characters long",
    ),
    "minutesAgo": m15,
    "month": MessageLookupByLibrary.simpleMessage("Month"),
    "monthsAgo": m16,
    "moreDetails": MessageLookupByLibrary.simpleMessage("More details"),
    "morocco": MessageLookupByLibrary.simpleMessage("Morocco"),
    "myContacts": MessageLookupByLibrary.simpleMessage("My Contacts"),
    "myCourses": MessageLookupByLibrary.simpleMessage("My Courses"),
    "myOpportunities": MessageLookupByLibrary.simpleMessage("Opportunities"),
    "myPosts": MessageLookupByLibrary.simpleMessage("My Posts"),
    "name": MessageLookupByLibrary.simpleMessage("name"),
    "nationality": MessageLookupByLibrary.simpleMessage("Nationality"),
    "newConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "New Connection Requests",
    ),
    "newCourses": MessageLookupByLibrary.simpleMessage("New Courses"),
    "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "newVideoSelected": MessageLookupByLibrary.simpleMessage(
      "New video selected",
    ),
    "newVideoWillBeUploaded": MessageLookupByLibrary.simpleMessage(
      "New video will be uploaded",
    ),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "noAcceptedApplicants": MessageLookupByLibrary.simpleMessage(
      "No accepted applicants",
    ),
    "noAchievements": MessageLookupByLibrary.simpleMessage("No Achievements"),
    "noApplicantsFound": MessageLookupByLibrary.simpleMessage(
      "No applicants found",
    ),
    "noArchivedPosts": MessageLookupByLibrary.simpleMessage(
      "No archived posts",
    ),
    "noAvailableCourses": MessageLookupByLibrary.simpleMessage(
      "No Available Courses",
    ),
    "noBio": MessageLookupByLibrary.simpleMessage("No bio"),
    "noCommentsYet": MessageLookupByLibrary.simpleMessage("No comments yet"),
    "noConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "No Connection Requests",
    ),
    "noContactsYet": MessageLookupByLibrary.simpleMessage("No contacts yet"),
    "noCourses": MessageLookupByLibrary.simpleMessage("No Courses"),
    "noCoursesFound": MessageLookupByLibrary.simpleMessage("No courses found"),
    "noCoursesFoundFor": m17,
    "noDataForMonth": m18,
    "noDescriptionAvailable": MessageLookupByLibrary.simpleMessage(
      "No description available",
    ),
    "noEnrolleesYet": MessageLookupByLibrary.simpleMessage("No enrollees yet"),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "No Internet Connection",
    ),
    "noLessonsAvailable": MessageLookupByLibrary.simpleMessage(
      "No lessons available",
    ),
    "noLikesYet": MessageLookupByLibrary.simpleMessage("No likes yet"),
    "noMoreRequests": MessageLookupByLibrary.simpleMessage("No More Requests"),
    "noOpportunities": MessageLookupByLibrary.simpleMessage("No Opportunities"),
    "noOpportunitiesAvailable": MessageLookupByLibrary.simpleMessage(
      "No opportunities available",
    ),
    "noOpportunitiesFound": MessageLookupByLibrary.simpleMessage(
      "No Opportunities found",
    ),
    "noPosts": MessageLookupByLibrary.simpleMessage("No Posts"),
    "noPostsAvailable": MessageLookupByLibrary.simpleMessage(
      "No posts available",
    ),
    "noPostsYet": MessageLookupByLibrary.simpleMessage("No posts yet"),
    "noProfileData": MessageLookupByLibrary.simpleMessage(
      "No profile data available.",
    ),
    "noRejectedApplicants": MessageLookupByLibrary.simpleMessage(
      "No rejected applicants",
    ),
    "noResultsForCriteria": MessageLookupByLibrary.simpleMessage(
      "No results for your criteria",
    ),
    "noResultsFound": MessageLookupByLibrary.simpleMessage("No results found"),
    "noUserDataFound": MessageLookupByLibrary.simpleMessage(
      "No user data found",
    ),
    "notDetected": MessageLookupByLibrary.simpleMessage("Not detected"),
    "notHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notification"),
    "november": MessageLookupByLibrary.simpleMessage("November"),
    "number": MessageLookupByLibrary.simpleMessage("number"),
    "numberValidation": MessageLookupByLibrary.simpleMessage(
      "At least 1 number",
    ),
    "october": MessageLookupByLibrary.simpleMessage("October"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "onboarding1Desc": MessageLookupByLibrary.simpleMessage(
      "Find and connect with top athletes through AI-powered talent discovery. Filter by sport, skills, and achievements.",
    ),
    "onboarding1Title": MessageLookupByLibrary.simpleMessage(
      "Discover Sports Talents",
    ),
    "onboarding2Desc": MessageLookupByLibrary.simpleMessage(
      "Create and publish tryouts, competitions, or sponsorship offers to attract the right athletes.",
    ),
    "onboarding2Title": MessageLookupByLibrary.simpleMessage(
      "Post Opportunities",
    ),
    "onboarding3Desc": MessageLookupByLibrary.simpleMessage(
      "Join SportsIn and take your sports career to the next level.",
    ),
    "onboarding3Title": MessageLookupByLibrary.simpleMessage(
      "Build Your Sports Profile",
    ),
    "onboarding4Desc": MessageLookupByLibrary.simpleMessage(
      "Upload your performance videos and get instant AI-powered analysis on your skills, movements, and progress.",
    ),
    "onboarding4Title": MessageLookupByLibrary.simpleMessage(
      "AI Video Analysis",
    ),
    "onboarding5Desc": MessageLookupByLibrary.simpleMessage(
      "Chat directly with coaches, clubs, and athletes. Build your sports network and stay updated with new opportunities.",
    ),
    "onboarding5Title": MessageLookupByLibrary.simpleMessage(
      "Connect & Communicate",
    ),
    "online": MessageLookupByLibrary.simpleMessage("Online"),
    "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Oops! Something went wrong",
    ),
    "opportunities": MessageLookupByLibrary.simpleMessage("Opportunities"),
    "opportunityCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Opportunity created successfully!",
    ),
    "oppositeHitter": MessageLookupByLibrary.simpleMessage("Opposite Hitter"),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "otpHint": MessageLookupByLibrary.simpleMessage(
      "please enter 6 digits code that send to yor email address",
    ),
    "otpMsgError": MessageLookupByLibrary.simpleMessage(
      "Please enter all 6 digits to verify your email",
    ),
    "otpMsgSuccess": MessageLookupByLibrary.simpleMessage(
      "Your email has been verified successfully",
    ),
    "otpSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "OTP sent successfully! Please check your email.",
    ),
    "outsideHitter": MessageLookupByLibrary.simpleMessage("Outside Hitter"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordHintDesc": MessageLookupByLibrary.simpleMessage(
      "Your new password must be different than the previous password",
    ),
    "passwordIsRequired": MessageLookupByLibrary.simpleMessage(
      "Password is required",
    ),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 8 characters.",
    ),
    "passwordMismatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "passwordNeedsLowercase": MessageLookupByLibrary.simpleMessage(
      "Password must contain at least one lowercase letter.",
    ),
    "passwordNeedsNumber": MessageLookupByLibrary.simpleMessage(
      "Password must contain at least one number.",
    ),
    "passwordNeedsSpecialChar": MessageLookupByLibrary.simpleMessage(
      "Password must contain at least one special character (!@#\$%^&* etc).",
    ),
    "passwordNeedsUppercase": MessageLookupByLibrary.simpleMessage(
      "Password must contain at least one uppercase letter.",
    ),
    "passwordsDonotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
    "percentComplete": m19,
    "percentageWatched": m20,
    "personalInfo": MessageLookupByLibrary.simpleMessage(
      "Personal Information",
    ),
    "pickImage": MessageLookupByLibrary.simpleMessage("Pick Image"),
    "pickVideo": MessageLookupByLibrary.simpleMessage("Pick Video"),
    "pivot": MessageLookupByLibrary.simpleMessage("Pivot"),
    "player": MessageLookupByLibrary.simpleMessage("Player"),
    "playing": MessageLookupByLibrary.simpleMessage("Playing"),
    "pleaseEnterDescription": MessageLookupByLibrary.simpleMessage(
      "Please enter a description",
    ),
    "pleaseEnterPrice": MessageLookupByLibrary.simpleMessage(
      "Please enter a price",
    ),
    "pleaseEnterRequirements": MessageLookupByLibrary.simpleMessage(
      "Please enter requirements",
    ),
    "pleaseEnterTitle": MessageLookupByLibrary.simpleMessage(
      "Please enter a title",
    ),
    "pleaseEnteraStrongPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter a strong password",
    ),
    "pleaseFillAllFields": MessageLookupByLibrary.simpleMessage(
      "Please fill all fields",
    ),
    "pleaseSelectEndDate": MessageLookupByLibrary.simpleMessage(
      "Please select an end date",
    ),
    "pleaseSelectSport": MessageLookupByLibrary.simpleMessage(
      "Please select a sport",
    ),
    "pleaseSelectVideo": MessageLookupByLibrary.simpleMessage(
      "Please select a video",
    ),
    "please_select_date": MessageLookupByLibrary.simpleMessage(
      "Please select a date",
    ),
    "pointGuard": MessageLookupByLibrary.simpleMessage("Point Guard"),
    "position": MessageLookupByLibrary.simpleMessage("Position"),
    "post": MessageLookupByLibrary.simpleMessage("Post"),
    "postArchived": MessageLookupByLibrary.simpleMessage(
      "Post archived successfully!",
    ),
    "postDeleteFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to delete post. Please try again.",
    ),
    "postDeleted": MessageLookupByLibrary.simpleMessage(
      "Post deleted successfully!",
    ),
    "postDeleteed": MessageLookupByLibrary.simpleMessage(
      "Post deleted successfully",
    ),
    "postLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to load post. Please try again.",
    ),
    "postRestored": MessageLookupByLibrary.simpleMessage(
      "Post restored successfully!",
    ),
    "postTitle": MessageLookupByLibrary.simpleMessage("Post Title"),
    "postUpdateFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to update post. Please try again.",
    ),
    "postUpdated": MessageLookupByLibrary.simpleMessage(
      "Post updated successfully",
    ),
    "postUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Post uploaded successfully!",
    ),
    "posts": MessageLookupByLibrary.simpleMessage("Posts"),
    "powerForward": MessageLookupByLibrary.simpleMessage("Power Forward"),
    "price": MessageLookupByLibrary.simpleMessage("Price"),
    "priceEGP": MessageLookupByLibrary.simpleMessage("Price (EGP)"),
    "priceRequired": MessageLookupByLibrary.simpleMessage("Price is required"),
    "privacyPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Privacy & Policy",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to load profile. Please try again.",
    ),
    "progress": MessageLookupByLibrary.simpleMessage("Progress"),
    "publicOpportunities": MessageLookupByLibrary.simpleMessage(
      "Public Opportunities",
    ),
    "publicPosts": MessageLookupByLibrary.simpleMessage("Public Posts"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registeredSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Registered successfully!",
    ),
    "registrationFailed": MessageLookupByLibrary.simpleMessage(
      "Registration failed. Please try again.",
    ),
    "registrationSuccessful": MessageLookupByLibrary.simpleMessage(
      "Registration successful!",
    ),
    "reject": MessageLookupByLibrary.simpleMessage("Reject"),
    "rejected": MessageLookupByLibrary.simpleMessage("Rejected"),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "replaceVideo": MessageLookupByLibrary.simpleMessage("Replace Video"),
    "requestCancelled": MessageLookupByLibrary.simpleMessage(
      "Request was cancelled.",
    ),
    "requirements": MessageLookupByLibrary.simpleMessage("Requirements"),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "resetPasswordFailure": MessageLookupByLibrary.simpleMessage(
      "Failed to reset password. Please try again",
    ),
    "resetPasswordSuccess": MessageLookupByLibrary.simpleMessage(
      "Your password has been reset successfully",
    ),
    "resourceNotFound": MessageLookupByLibrary.simpleMessage(
      "Resource not found.",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Restore"),
    "restorePost": MessageLookupByLibrary.simpleMessage("Restore Post"),
    "restorePostConfirmation": MessageLookupByLibrary.simpleMessage(
      "this post will be restored and visible in your profile and feed. Are you sure you want to restore this post?",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "revenue": MessageLookupByLibrary.simpleMessage("Revenue"),
    "rightBack": MessageLookupByLibrary.simpleMessage("Right Back"),
    "rightWing": MessageLookupByLibrary.simpleMessage("Right Wing"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "save_achievement_button": MessageLookupByLibrary.simpleMessage(
      "Save Achievement",
    ),
    "savingChanges": MessageLookupByLibrary.simpleMessage("Saving changes..."),
    "scout": MessageLookupByLibrary.simpleMessage("Scout"),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchResults": MessageLookupByLibrary.simpleMessage("Search Result"),
    "secondsAgo": m21,
    "seeOriginal": MessageLookupByLibrary.simpleMessage("See Original"),
    "select": MessageLookupByLibrary.simpleMessage("Select"),
    "selectAtLeastOne": MessageLookupByLibrary.simpleMessage(
      "Please select at least one sport",
    ),
    "selectEndDate": MessageLookupByLibrary.simpleMessage("Select End Date"),
    "selectField": m22,
    "selectLanguage": MessageLookupByLibrary.simpleMessage("Select Language"),
    "selectSport": MessageLookupByLibrary.simpleMessage("Select Sport"),
    "selectSports": MessageLookupByLibrary.simpleMessage("Select a Sport"),
    "select_date_hint": MessageLookupByLibrary.simpleMessage("Select Date"),
    "select_sport_error": MessageLookupByLibrary.simpleMessage(
      "Please select a sport",
    ),
    "sendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Send verification code",
    ),
    "september": MessageLookupByLibrary.simpleMessage("September"),
    "serverError": MessageLookupByLibrary.simpleMessage(
      "Server error. Please try again later.",
    ),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage(
      "Service temporarily unavailable",
    ),
    "setter": MessageLookupByLibrary.simpleMessage("Setter"),
    "settings": MessageLookupByLibrary.simpleMessage("Setting"),
    "sharingInfoBody": MessageLookupByLibrary.simpleMessage(
      "We do not share your personal data with third parties except in the following cases:\n\n• To comply with legal obligations or official requests.\n• To provide services through trusted partners (e.g., analytics or notification services).",
    ),
    "sharingInfoTitle": MessageLookupByLibrary.simpleMessage(
      "Sharing Your Information",
    ),
    "shootingGuard": MessageLookupByLibrary.simpleMessage("Shooting Guard"),
    "showAll": MessageLookupByLibrary.simpleMessage("Show all"),
    "showApplicants": MessageLookupByLibrary.simpleMessage("Show Applicants"),
    "showDescription": MessageLookupByLibrary.simpleMessage("Show Description"),
    "showMore": MessageLookupByLibrary.simpleMessage("Show More"),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "signingIn": MessageLookupByLibrary.simpleMessage("Signing in..."),
    "since": MessageLookupByLibrary.simpleMessage("Since"),
    "skills": MessageLookupByLibrary.simpleMessage("Skills"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "smallForward": MessageLookupByLibrary.simpleMessage("Small Forward"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "specialCharacterValidation": MessageLookupByLibrary.simpleMessage(
      "At least 1 special character",
    ),
    "specializedSport": MessageLookupByLibrary.simpleMessage(
      "Specialized sports",
    ),
    "sport": MessageLookupByLibrary.simpleMessage("Sport"),
    "sportProfession": MessageLookupByLibrary.simpleMessage("Sport profession"),
    "startSearching": MessageLookupByLibrary.simpleMessage("Start searching"),
    "strongPassword": MessageLookupByLibrary.simpleMessage(
      "Enter Strong Password ,contain at least 8 characters , 1 uppercase, 1 lowercase, 1 digit , 1 special character ",
    ),
    "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "sudan": MessageLookupByLibrary.simpleMessage("Sudan"),
    "switchAccount": MessageLookupByLibrary.simpleMessage("Switch Account"),
    "taekwondo": MessageLookupByLibrary.simpleMessage("Taekwondo"),
    "tapToAddFirstLesson": MessageLookupByLibrary.simpleMessage(
      "Tap the + button to add your first lesson",
    ),
    "tapToChange": MessageLookupByLibrary.simpleMessage("Tap to Change"),
    "tapToSelectFromGallery": MessageLookupByLibrary.simpleMessage(
      "Tap to select from gallery",
    ),
    "teakwando": MessageLookupByLibrary.simpleMessage("Teakwando"),
    "teakwandoPlayer": MessageLookupByLibrary.simpleMessage("Teakwando Player"),
    "theme": MessageLookupByLibrary.simpleMessage("Light"),
    "timeSpent": MessageLookupByLibrary.simpleMessage("Time Spent"),
    "title": MessageLookupByLibrary.simpleMessage("Title"),
    "titleCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Title cannot be empty",
    ),
    "titleRequired": MessageLookupByLibrary.simpleMessage("Title is required"),
    "title_hint": MessageLookupByLibrary.simpleMessage(
      "e.g. National Championship",
    ),
    "title_label": MessageLookupByLibrary.simpleMessage("Title"),
    "tokenEX": MessageLookupByLibrary.simpleMessage(
      "Session expired, please login again",
    ),
    "totalEnrolled": MessageLookupByLibrary.simpleMessage("Total Enrolled"),
    "translate": MessageLookupByLibrary.simpleMessage("Translate"),
    "tryAdjustingSearch": MessageLookupByLibrary.simpleMessage(
      "Try adjusting your search or filter",
    ),
    "tryDifferentSearch": MessageLookupByLibrary.simpleMessage(
      "Try a different search",
    ),
    "tunisia": MessageLookupByLibrary.simpleMessage("Tunisia"),
    "unauthorized": MessageLookupByLibrary.simpleMessage(
      "Unauthorized. Please check your credentials.",
    ),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "Unexpected error occurred.",
    ),
    "unfollowSuccess": MessageLookupByLibrary.simpleMessage(
      "Unfollowed successfully!",
    ),
    "unknownError": MessageLookupByLibrary.simpleMessage("Unknown error"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updateLesson": MessageLookupByLibrary.simpleMessage("Update Lesson"),
    "updatePost": MessageLookupByLibrary.simpleMessage("Update Post"),
    "update_button": MessageLookupByLibrary.simpleMessage("Update"),
    "updatingLesson": MessageLookupByLibrary.simpleMessage(
      "Updating lesson...",
    ),
    "updatingPost": MessageLookupByLibrary.simpleMessage("Updating post"),
    "updatingProfile": MessageLookupByLibrary.simpleMessage("Updating profile"),
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "uploadAnImage": MessageLookupByLibrary.simpleMessage("Upload an Image"),
    "uploadContent": MessageLookupByLibrary.simpleMessage("Upload Content"),
    "uploadCourseThumbnail": MessageLookupByLibrary.simpleMessage(
      "Upload Course Thumbnail",
    ),
    "uploadImageOrVideo": MessageLookupByLibrary.simpleMessage(
      "Upload an Image or video",
    ),
    "uploadLesson": MessageLookupByLibrary.simpleMessage("Upload Lesson"),
    "uploadVideo": MessageLookupByLibrary.simpleMessage("Upload Video"),
    "uploadWillContinue": MessageLookupByLibrary.simpleMessage(
      "Upload will continue in background",
    ),
    "upload_photo_hint": MessageLookupByLibrary.simpleMessage(
      "Upload Achievement Photo",
    ),
    "uploadingInBackground": MessageLookupByLibrary.simpleMessage(
      "Uploading lesson in background...",
    ),
    "uppercaseValidation": MessageLookupByLibrary.simpleMessage(
      "At least 1 uppercase letter",
    ),
    "useInfoBody": MessageLookupByLibrary.simpleMessage(
      "We use the collected data to:\n\n• Personalize your experience within the app.\n• Improve our features and services.\n• Send you relevant notifications about activities or opportunities.\n• Ensure the security and integrity of our platform.",
    ),
    "useInfoTitle": MessageLookupByLibrary.simpleMessage(
      "How We Use Your Information",
    ),
    "userNotFound": MessageLookupByLibrary.simpleMessage("User not found"),
    "userType": MessageLookupByLibrary.simpleMessage("User Type"),
    "validEmail": MessageLookupByLibrary.simpleMessage("Enter a valid email"),
    "validationError": MessageLookupByLibrary.simpleMessage(
      "Validation error. Please check your inputs.",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("Verify"),
    "video": MessageLookupByLibrary.simpleMessage("Video"),
    "videoPlaybackError": MessageLookupByLibrary.simpleMessage(
      "Video Playback Error",
    ),
    "volleyball": MessageLookupByLibrary.simpleMessage("Volleyball"),
    "volleyballer": MessageLookupByLibrary.simpleMessage("Volleyballer"),
    "wantsToConnect": MessageLookupByLibrary.simpleMessage(
      "Wants to connect with you",
    ),
    "watched": MessageLookupByLibrary.simpleMessage("Watched"),
    "weeklyBreakdown": MessageLookupByLibrary.simpleMessage("Weekly Breakdown"),
    "weeklyDetails": MessageLookupByLibrary.simpleMessage("Weekly Details"),
    "weeksAgo": m23,
    "weight": MessageLookupByLibrary.simpleMessage("Weight (kg)"),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "whatIsYourType": MessageLookupByLibrary.simpleMessage(
      "What Is Your Type?",
    ),
    "year": MessageLookupByLibrary.simpleMessage("Year"),
    "yearsAgo": m24,
    "yearsOfExperience": MessageLookupByLibrary.simpleMessage(
      "Years of experience",
    ),
    "yearsOfExperience0to2": MessageLookupByLibrary.simpleMessage("0-2 years"),
    "yearsOfExperience10Plus": MessageLookupByLibrary.simpleMessage(
      "10+ years",
    ),
    "yearsOfExperience3to5": MessageLookupByLibrary.simpleMessage("3-5 years"),
    "yearsOfExperience5to10": MessageLookupByLibrary.simpleMessage(
      "6-10 years",
    ),
  };
}

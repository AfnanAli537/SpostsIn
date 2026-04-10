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

  static String m0(type) =>
      "Your ${type} report is ready. Find it in your profile under Video Analysis.";

  static String m1(message) => "Analysis failed: ${message}";

  static String m2(type) =>
      "Your ${type} video is being processed by our AI engine. This may take a few minutes.";

  static String m3(type) => "${type} analysis is ready! Check your profile.";

  static String m4(type) => "${type} Analysis";

  static String m5(percentage) => "${percentage}% complete";

  static String m6(count) =>
      "${Intl.plural(count, one: '${count} day ago', other: '${count} days ago')}";

  static String m7(lessonTitle) =>
      "Are you sure you want to delete \"${lessonTitle}\"? This action cannot be undone.";

  static String m8(duration) => "Duration: ${duration}";

  static String m9(price) => "Enroll for ${price}";

  static String m10(count) => "${count} enrolled";

  static String m11(field) => "Please enter your ${field}";

  static String m12(price) => "Estimated cost: ${price} EGP";

  static String m13(type) => "Example: ${type} drill";

  static String m14(field) => "${field} is too short";

  static String m15(count) =>
      "${Intl.plural(count, one: '${count} hour ago', other: '${count} hours ago')}";

  static String m16(field) => "Invalid ${field}";

  static String m17(number) => "${number} Lesson";

  static String m18(order) => "Lesson order: ${order}";

  static String m19(order, duration) =>
      "Lesson order: ${order} • Duration: ${duration}";

  static String m20(count) => "${count} lessons";

  static String m21(completed, total) => "${completed} / ${total} Lessons";

  static String m22(count) =>
      "${Intl.plural(count, one: '${count} minute ago', other: '${count} minutes ago')}";

  static String m23(count) =>
      "${Intl.plural(count, one: '${count} month ago', other: '${count} months ago')}";

  static String m24(searchTerm) => "No courses found for \"${searchTerm}\"";

  static String m25(month) => "No data available for ${month}";

  static String m26(id) => "Transaction ID: ${id}";

  static String m27(percentage) => "${percentage}% Complete";

  static String m28(value) => "${value}%";

  static String m29(percentage) => "${percentage}% watched";

  static String m30(price) => "${price} EGP";

  static String m31(price) => "(${price} EGP per day)";

  static String m32(count) =>
      "${Intl.plural(count, one: '${count} second ago', other: '${count} seconds ago')}";

  static String m33(field) => "Please select a ${field}";

  static String m34(count) => "${count} Ads / month";

  static String m35(count) => "${count} Days";

  static String m36(count) => "${count} Months";

  static String m37(count) => "${count} Videos / month";

  static String m38(error) => "Upload error: ${error}";

  static String m39(name) => "${name}\'s Analyses";

  static String m40(count) =>
      "${Intl.plural(count, one: '${count} week ago', other: '${count} weeks ago')}";

  static String m41(count) =>
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
    "actionUrlOptional": MessageLookupByLibrary.simpleMessage(
      "Action URL (optional)",
    ),
    "activate": MessageLookupByLibrary.simpleMessage("Activate"),
    "activateAd": MessageLookupByLibrary.simpleMessage("Activate Ad"),
    "activateAdMessage": MessageLookupByLibrary.simpleMessage(
      "This ad will appear in the feed again.",
    ),
    "active": MessageLookupByLibrary.simpleMessage("Active"),
    "activities": MessageLookupByLibrary.simpleMessage("Activities"),
    "adActivated": MessageLookupByLibrary.simpleMessage("Ad activated"),
    "adCreatedPendingPayment": MessageLookupByLibrary.simpleMessage(
      "Ad Created — Pending Payment",
    ),
    "adDashboard": MessageLookupByLibrary.simpleMessage("Ad Dashboard"),
    "adDeactivated": MessageLookupByLibrary.simpleMessage("Ad deactivated"),
    "adDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Ad deleted successfully",
    ),
    "adPublished": MessageLookupByLibrary.simpleMessage("Ad Published!"),
    "adPublishedDescription": MessageLookupByLibrary.simpleMessage(
      "Your advertisement is now live and will appear in the feed to your target audience.",
    ),
    "adSavedAsDraft": MessageLookupByLibrary.simpleMessage(
      "Ad saved as draft — not published",
    ),
    "adSavedCompletePayment": MessageLookupByLibrary.simpleMessage(
      "Your ad has been saved. Complete payment to activate it in the feed.",
    ),
    "adUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Advertisement updated successfully",
    ),
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
    "ads": MessageLookupByLibrary.simpleMessage("Ads"),
    "advertisement": MessageLookupByLibrary.simpleMessage("Advertisement"),
    "advertisements": MessageLookupByLibrary.simpleMessage("Advertisements"),
    "age": MessageLookupByLibrary.simpleMessage("Age"),
    "agreeLabel": MessageLookupByLibrary.simpleMessage("I agree"),
    "aiEnhancedAnalysis": MessageLookupByLibrary.simpleMessage(
      "AI Enhanced Analysis",
    ),
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
    "analysisCompleteMessage": m0,
    "analysisCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Analysis Complete!",
    ),
    "analysisDeleted": MessageLookupByLibrary.simpleMessage("Analysis deleted"),
    "analysisFailedToast": m1,
    "analysisInProgressMessage": m2,
    "analysisInProgressTitle": MessageLookupByLibrary.simpleMessage(
      "Analysis in Progress",
    ),
    "analysisNotificationHint": MessageLookupByLibrary.simpleMessage(
      "You\'ll see a notification here when the report is ready.",
    ),
    "analysisNotificationInfo": MessageLookupByLibrary.simpleMessage(
      "You\'ll see a toast notification here when your report is ready — no need to wait on this screen.",
    ),
    "analysisPendingPayment": MessageLookupByLibrary.simpleMessage(
      "Analysis Pending Payment",
    ),
    "analysisReadyToast": m3,
    "analysisSavedCompletePayment": MessageLookupByLibrary.simpleMessage(
      "Your video has been saved. Complete payment to run the AI analysis.",
    ),
    "analysisTypeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Select the category that matches your training drill.",
    ),
    "analysisTypeTitle": m4,
    "analyticsOverview": MessageLookupByLibrary.simpleMessage(
      "Analytics Overview",
    ),
    "analyzeVideo": MessageLookupByLibrary.simpleMessage("Analyze Video"),
    "analyzeVideoComingSoon": MessageLookupByLibrary.simpleMessage(
      "Analyze video feature coming soon",
    ),
    "analyzed": MessageLookupByLibrary.simpleMessage("Analyzed"),
    "analyzedPeople": MessageLookupByLibrary.simpleMessage("Analyzed People"),
    "analyzedPlayers": MessageLookupByLibrary.simpleMessage("Analyzed Players"),
    "analyzedVideo": MessageLookupByLibrary.simpleMessage("Analyzed Video"),
    "analyzedVideoLocked": MessageLookupByLibrary.simpleMessage(
      "Analyzed Video (Locked)",
    ),
    "analyzedVideoReport": MessageLookupByLibrary.simpleMessage(
      "Analyzed Video Report",
    ),
    "analyzedVideos": MessageLookupByLibrary.simpleMessage("Analyzed videos"),
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
    "average": MessageLookupByLibrary.simpleMessage("Average"),
    "averageCompletionRate": MessageLookupByLibrary.simpleMessage(
      "Avg. Completion Rate",
    ),
    "avgBallDistance": MessageLookupByLibrary.simpleMessage(
      "Avg Ball Distance",
    ),
    "avgBallSpeed": MessageLookupByLibrary.simpleMessage("Avg Ball Speed"),
    "avgKneeAngle": MessageLookupByLibrary.simpleMessage("Avg Knee Angle"),
    "avgPlayerSpeed": MessageLookupByLibrary.simpleMessage("Avg Player Speed"),
    "avgProgress": MessageLookupByLibrary.simpleMessage("Avg Progress"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backToHome": MessageLookupByLibrary.simpleMessage("Back to Home"),
    "backToHomeButton": MessageLookupByLibrary.simpleMessage("Back to Home"),
    "backwardPasses": MessageLookupByLibrary.simpleMessage("Backward\nPasses"),
    "badRequest": MessageLookupByLibrary.simpleMessage("Invalid request"),
    "ballTouches": MessageLookupByLibrary.simpleMessage("Ball Touches"),
    "basketball": MessageLookupByLibrary.simpleMessage("Basketball"),
    "basketballer": MessageLookupByLibrary.simpleMessage("Basketballer"),
    "beTheFirstToCreatePost": MessageLookupByLibrary.simpleMessage(
      "Be the first to create a post!",
    ),
    "bio": MessageLookupByLibrary.simpleMessage("Description"),
    "campaignDurationRequired": MessageLookupByLibrary.simpleMessage(
      "Campaign Duration *",
    ),
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
    "chooseAnalysisType": MessageLookupByLibrary.simpleMessage(
      "Choose Analysis Type",
    ),
    "chooseFromGallery": MessageLookupByLibrary.simpleMessage(
      "Choose from Gallery",
    ),
    "chooseMethod": MessageLookupByLibrary.simpleMessage(
      "Choose Payment Method",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearFilters": MessageLookupByLibrary.simpleMessage("Clear filters"),
    "clicks": MessageLookupByLibrary.simpleMessage("Clicks"),
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
    "completePayment": MessageLookupByLibrary.simpleMessage("Complete Payment"),
    "completePaymentToActivate": MessageLookupByLibrary.simpleMessage(
      "Complete payment to activate this ad in the feed.",
    ),
    "completePaymentToUnlock": MessageLookupByLibrary.simpleMessage(
      "Complete payment to unlock the full AI report and analyzed video.",
    ),
    "completePaymentToViewAnalyzedVideo": MessageLookupByLibrary.simpleMessage(
      "Complete payment to view\nthe analyzed video",
    ),
    "completePercentage": m5,
    "completed": MessageLookupByLibrary.simpleMessage("Completed"),
    "completion": MessageLookupByLibrary.simpleMessage("Completion"),
    "coneHits": MessageLookupByLibrary.simpleMessage("Cone Hits"),
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
    "ctaButtonTextOptional": MessageLookupByLibrary.simpleMessage(
      "CTA Button Text (optional)",
    ),
    "ctaPlaceholder": MessageLookupByLibrary.simpleMessage(
      "e.g. Learn More, Buy Now",
    ),
    "currentVideo": MessageLookupByLibrary.simpleMessage("Current video"),
    "currentlyInClub": MessageLookupByLibrary.simpleMessage(
      "Currently in a Club",
    ),
    "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "date": MessageLookupByLibrary.simpleMessage("Date"),
    "date_label": MessageLookupByLibrary.simpleMessage("Date"),
    "daysAgo": m6,
    "deactivate": MessageLookupByLibrary.simpleMessage("Deactivate"),
    "deactivateAd": MessageLookupByLibrary.simpleMessage("Deactivate Ad"),
    "deactivateAdMessage": MessageLookupByLibrary.simpleMessage(
      "This ad will no longer appear in the feed.",
    ),
    "december": MessageLookupByLibrary.simpleMessage("December"),
    "defender": MessageLookupByLibrary.simpleMessage("Defender"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteAdConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this advertisement?",
    ),
    "deleteAnalysis": MessageLookupByLibrary.simpleMessage("Delete Analysis"),
    "deleteAnalysisConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this analysis?",
    ),
    "deleteComment": MessageLookupByLibrary.simpleMessage("Delete Comment"),
    "deleteCommentConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this comment?",
    ),
    "deleteCourse": MessageLookupByLibrary.simpleMessage("Delete Course"),
    "deleteCourseConfirmation": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this course?",
    ),
    "deleteLesson": MessageLookupByLibrary.simpleMessage("Delete Lesson"),
    "deleteLessonConfirmation": m7,
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
    "distanceCovered": MessageLookupByLibrary.simpleMessage("Distance Covered"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "dribbling": MessageLookupByLibrary.simpleMessage("Dribbling"),
    "dribblingAnalysis": MessageLookupByLibrary.simpleMessage(
      "Dribbling Analysis",
    ),
    "dribblingAnalysisDescription": MessageLookupByLibrary.simpleMessage(
      "Analyze dribbling skills and control",
    ),
    "dribblingAnalysisLabel": MessageLookupByLibrary.simpleMessage("Dribbling"),
    "dribblingVideoInstructions": MessageLookupByLibrary.simpleMessage(
      "Keep the camera steady. The player should be visible from waist up.",
    ),
    "drillDuration": MessageLookupByLibrary.simpleMessage("Drill Duration"),
    "duration": m8,
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editAdvertisement": MessageLookupByLibrary.simpleMessage(
      "Edit Advertisement",
    ),
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
    "elite": MessageLookupByLibrary.simpleMessage("Elite"),
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
    "engagement": MessageLookupByLibrary.simpleMessage("Engagement"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enroll": MessageLookupByLibrary.simpleMessage("Enroll"),
    "enrollForPrice": m9,
    "enrollNow": MessageLookupByLibrary.simpleMessage("Enroll Now"),
    "enrolled": MessageLookupByLibrary.simpleMessage("Enrolled"),
    "enrolledCount": m10,
    "enrolledCourses": MessageLookupByLibrary.simpleMessage("Enrolled Courses"),
    "enrolledSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Enrolled successfully",
    ),
    "enrolleesWillAppear": MessageLookupByLibrary.simpleMessage(
      "Enrolled students will appear here",
    ),
    "enterAdDescription": MessageLookupByLibrary.simpleMessage(
      "Enter ad description",
    ),
    "enterAdTitle": MessageLookupByLibrary.simpleMessage("Enter ad title"),
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
    "enterField": m11,
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
    "estimatedCost": m12,
    "exampleDrill": m13,
    "exampleFrame": MessageLookupByLibrary.simpleMessage("Example Frame"),
    "extractingDuration": MessageLookupByLibrary.simpleMessage(
      "Extracting duration...",
    ),
    "failedToLoadImage": MessageLookupByLibrary.simpleMessage(
      "Failed to load image",
    ),
    "failedToLoadPage": MessageLookupByLibrary.simpleMessage(
      "Failed to load page",
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
    "fawry_mobile_appbar_title": MessageLookupByLibrary.simpleMessage(
      "Enter Mobile Number",
    ),
    "fawry_mobile_confirm_btn": MessageLookupByLibrary.simpleMessage(
      "Continue to Fawry",
    ),
    "fawry_mobile_hint": MessageLookupByLibrary.simpleMessage(
      "Mobile Number (e.g., 010xxxxxxxx)",
    ),
    "fawry_mobile_label": MessageLookupByLibrary.simpleMessage(
      "Enter your Fawry mobile number",
    ),
    "fawry_mobile_terms": MessageLookupByLibrary.simpleMessage(
      "By continuing you agree to our Terms",
    ),
    "fawry_mobile_validation_empty": MessageLookupByLibrary.simpleMessage(
      "Please enter your mobile number",
    ),
    "fawry_mobile_validation_invalid": MessageLookupByLibrary.simpleMessage(
      "Enter a valid Egyptian mobile number",
    ),
    "fawry_screen_appbar_title": MessageLookupByLibrary.simpleMessage(
      "Fawry Reference Code",
    ),
    "fawry_screen_copied": MessageLookupByLibrary.simpleMessage(
      "Reference code copied to clipboard",
    ),
    "fawry_screen_copied_btn": MessageLookupByLibrary.simpleMessage("Copied!"),
    "fawry_screen_copied_reminder": MessageLookupByLibrary.simpleMessage(
      "Code copied! Go to any Fawry outlet and pay using this code.",
    ),
    "fawry_screen_copy_btn": MessageLookupByLibrary.simpleMessage("Copy Code"),
    "fawry_screen_done_btn": MessageLookupByLibrary.simpleMessage("Done"),
    "fawry_screen_failed_code": MessageLookupByLibrary.simpleMessage(
      "Failed to generate reference code",
    ),
    "fawry_screen_label": MessageLookupByLibrary.simpleMessage(
      "Enter your payment details",
    ),
    "fawry_screen_pay_instruction": MessageLookupByLibrary.simpleMessage(
      "Pay at any Fawry POS using this code\nwithin 24 hours",
    ),
    "fawry_screen_retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "fawry_screen_terms": MessageLookupByLibrary.simpleMessage(
      "By continuing you agree to our Terms",
    ),
    "february": MessageLookupByLibrary.simpleMessage("February"),
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "field": MessageLookupByLibrary.simpleMessage("field"),
    "fieldTooShort": m14,
    "file_size_exceeds_limit": MessageLookupByLibrary.simpleMessage(
      "File size exceeds 500MB",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("First name"),
    "follow": MessageLookupByLibrary.simpleMessage("Follow"),
    "followBack": MessageLookupByLibrary.simpleMessage("Follow Back"),
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
    "forwardPasses": MessageLookupByLibrary.simpleMessage("Forward\nPasses"),
    "foundDate": MessageLookupByLibrary.simpleMessage("Foundation date"),
    "frames": MessageLookupByLibrary.simpleMessage("Frames"),
    "free": MessageLookupByLibrary.simpleMessage("FREE"),
    "freeCourse": MessageLookupByLibrary.simpleMessage("Free Course"),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
    "goToProfileButton": MessageLookupByLibrary.simpleMessage("Go to Profile"),
    "goalkeeper": MessageLookupByLibrary.simpleMessage("Goalkeeper"),
    "goalkeeperAnalysis": MessageLookupByLibrary.simpleMessage(
      "Goalkeeper Analysis",
    ),
    "goalkeeperAnalysisDescription": MessageLookupByLibrary.simpleMessage(
      "Analyze goalkeeper performance",
    ),
    "goalkeeperAnalysisLabel": MessageLookupByLibrary.simpleMessage(
      "Goalkeeper",
    ),
    "goalkeeperHeight": MessageLookupByLibrary.simpleMessage(
      "Goalkeeper Height (meters)",
    ),
    "goalkeeperVideoInstructions": MessageLookupByLibrary.simpleMessage(
      "Record from behind the goal or side angle. Ensure the goalkeeper is fully visible.",
    ),
    "good": MessageLookupByLibrary.simpleMessage("Good"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it"),
    "guest": MessageLookupByLibrary.simpleMessage("Guest"),
    "gymnast": MessageLookupByLibrary.simpleMessage("Gymnast"),
    "gymnastics": MessageLookupByLibrary.simpleMessage("Gymnastics"),
    "handball": MessageLookupByLibrary.simpleMessage("Handball"),
    "handballPlayer": MessageLookupByLibrary.simpleMessage("Handball Player"),
    "happyToSeeYouToday": MessageLookupByLibrary.simpleMessage(
      "Happy to see you today",
    ),
    "headUpPercent": MessageLookupByLibrary.simpleMessage("Head Up %"),
    "height": MessageLookupByLibrary.simpleMessage("Height (cm)"),
    "heightCalibrationInfo": MessageLookupByLibrary.simpleMessage(
      "Height calibrates extension & velocity measurements.",
    ),
    "heightExample": MessageLookupByLibrary.simpleMessage("e.g. 1.85"),
    "heightRequired": MessageLookupByLibrary.simpleMessage(
      "Height is required for goalkeeper analysis",
    ),
    "hi": MessageLookupByLibrary.simpleMessage("Hi"),
    "hideDescription": MessageLookupByLibrary.simpleMessage("Hide Description"),
    "hipVariance": MessageLookupByLibrary.simpleMessage("Hip Variance"),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "hoursAgo": m15,
    "inactiveDraft": MessageLookupByLibrary.simpleMessage("Inactive / Draft"),
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
    "invalidField": m16,
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
    "kneeAngle": MessageLookupByLibrary.simpleMessage("Knee Angle"),
    "knowingYourGoal": MessageLookupByLibrary.simpleMessage(
      "Knowing your goal helps us tailor your experience",
    ),
    "kpiAverageBallSpeed": MessageLookupByLibrary.simpleMessage(
      "Average Ball Speed (km/h)",
    ),
    "kpiAveragePlayerSpeed": MessageLookupByLibrary.simpleMessage(
      "Average Player Speed (km/h)",
    ),
    "kpiAvgBallDistance": MessageLookupByLibrary.simpleMessage(
      "Average Ball Distance (meters)",
    ),
    "kpiAvgPlayerSpeedDribbling": MessageLookupByLibrary.simpleMessage(
      "Average Player Speed (km/h)",
    ),
    "kpiConePasses": MessageLookupByLibrary.simpleMessage(
      "Cone Passes Forward/Backward & Hits",
    ),
    "kpiDeepestKneeAngle": MessageLookupByLibrary.simpleMessage(
      "Deepest Knee Angle (degrees)",
    ),
    "kpiDistanceCovered": MessageLookupByLibrary.simpleMessage(
      "Distance Covered per Team (km)",
    ),
    "kpiDrillDuration": MessageLookupByLibrary.simpleMessage(
      "Drill Duration (seconds)",
    ),
    "kpiHeadUpPercentage": MessageLookupByLibrary.simpleMessage(
      "Head-Up Percentage",
    ),
    "kpiHipBounceVariance": MessageLookupByLibrary.simpleMessage(
      "Hip Bounce Variance",
    ),
    "kpiMaxExtension": MessageLookupByLibrary.simpleMessage(
      "Maximum Extension (meters)",
    ),
    "kpiMaxVelocity": MessageLookupByLibrary.simpleMessage(
      "Maximum Velocity (km/h)",
    ),
    "kpiReactionTime": MessageLookupByLibrary.simpleMessage(
      "Reaction Time (seconds)",
    ),
    "kpiRightKneeAngle": MessageLookupByLibrary.simpleMessage(
      "Right Knee Angle (degrees)",
    ),
    "kpiTeamPossession": MessageLookupByLibrary.simpleMessage(
      "Team Possession (%)",
    ),
    "kpiTopSpeedPerTeam": MessageLookupByLibrary.simpleMessage(
      "Top Speed per Team (km/h)",
    ),
    "kpiTopSprintSpeedOverall": MessageLookupByLibrary.simpleMessage(
      "Top Sprint Speed overall (km/h)",
    ),
    "kpiTotalBallTouches": MessageLookupByLibrary.simpleMessage(
      "Total Ball Touches",
    ),
    "kpiTotalFramesProcessed": MessageLookupByLibrary.simpleMessage(
      "Total Frames Processed",
    ),
    "kpiTouchesPerSec": MessageLookupByLibrary.simpleMessage(
      "Total Ball Touches & Touches/sec",
    ),
    "lastName": MessageLookupByLibrary.simpleMessage("Last name"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage(
      "Last updated: 11 October 2025",
    ),
    "latestCourses": MessageLookupByLibrary.simpleMessage("Latest Courses"),
    "latestPosts": MessageLookupByLibrary.simpleMessage("Latest posts"),
    "learnMore": MessageLookupByLibrary.simpleMessage("Learn More"),
    "leftBack": MessageLookupByLibrary.simpleMessage("Left Back"),
    "leftWing": MessageLookupByLibrary.simpleMessage("Left Wing"),
    "lessonNumber": m17,
    "lessonOrder": m18,
    "lessonOrderAndDuration": m19,
    "lessonOrderSaved": MessageLookupByLibrary.simpleMessage(
      "Lesson order saved",
    ),
    "lessonTitle": MessageLookupByLibrary.simpleMessage("Lesson Title"),
    "lessons": MessageLookupByLibrary.simpleMessage("Lessons"),
    "lessonsCount": m20,
    "lessonsProgress": m21,
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
    "match": MessageLookupByLibrary.simpleMessage("Match"),
    "matchAnalysis": MessageLookupByLibrary.simpleMessage("Match Analysis"),
    "matchAnalysisDescription": MessageLookupByLibrary.simpleMessage(
      "Full match performance analysis",
    ),
    "matchAnalysisLabel": MessageLookupByLibrary.simpleMessage("Match"),
    "matchVideoInstructions": MessageLookupByLibrary.simpleMessage(
      "Full match footage preferred. If not available, record key phases.",
    ),
    "maxExtension": MessageLookupByLibrary.simpleMessage("Max Extension"),
    "maxFileSize": MessageLookupByLibrary.simpleMessage("Max 500MB"),
    "maxVelocity": MessageLookupByLibrary.simpleMessage("Max Velocity"),
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
    "minutesAgo": m22,
    "month": MessageLookupByLibrary.simpleMessage("Month"),
    "monthsAgo": m23,
    "moreDetails": MessageLookupByLibrary.simpleMessage("More details"),
    "moreInfo": MessageLookupByLibrary.simpleMessage("More info"),
    "morocco": MessageLookupByLibrary.simpleMessage("Morocco"),
    "myAdvertisements": MessageLookupByLibrary.simpleMessage(
      "My Advertisements",
    ),
    "myAnalysisLibrary": MessageLookupByLibrary.simpleMessage(
      "My Analysis Library",
    ),
    "myContacts": MessageLookupByLibrary.simpleMessage("My Contacts"),
    "myCourses": MessageLookupByLibrary.simpleMessage("My Courses"),
    "myOpportunities": MessageLookupByLibrary.simpleMessage("Opportunities"),
    "myPosts": MessageLookupByLibrary.simpleMessage("My Posts"),
    "name": MessageLookupByLibrary.simpleMessage("name"),
    "nationality": MessageLookupByLibrary.simpleMessage("Nationality"),
    "needsWork": MessageLookupByLibrary.simpleMessage("Needs Work"),
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
    "noActiveAds": MessageLookupByLibrary.simpleMessage(
      "No active advertisements",
    ),
    "noAnalysesFound": MessageLookupByLibrary.simpleMessage(
      "No analyses found",
    ),
    "noAnalyzedPlayersYet": MessageLookupByLibrary.simpleMessage(
      "No analyzed players yet",
    ),
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
    "noCoursesFoundFor": m24,
    "noDataForMonth": m25,
    "noDescriptionAvailable": MessageLookupByLibrary.simpleMessage(
      "No description available",
    ),
    "noEnrolleesYet": MessageLookupByLibrary.simpleMessage("No enrollees yet"),
    "noFollowersYet": MessageLookupByLibrary.simpleMessage("No followers yet"),
    "noFollowingYet": MessageLookupByLibrary.simpleMessage("No following yet"),
    "noInactiveAds": MessageLookupByLibrary.simpleMessage(
      "No inactive advertisements",
    ),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "No Internet Connection",
    ),
    "noLessonsAvailable": MessageLookupByLibrary.simpleMessage(
      "No lessons available",
    ),
    "noLikesYet": MessageLookupByLibrary.simpleMessage("No likes yet"),
    "noMoreContacts": MessageLookupByLibrary.simpleMessage("No more contacts"),
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
    "optional": MessageLookupByLibrary.simpleMessage("Optional"),
    "orPasteUrlLabel": MessageLookupByLibrary.simpleMessage("OR PASTE URL"),
    "orPasteVideoUrl": MessageLookupByLibrary.simpleMessage(
      "Or Paste a Video URL",
    ),
    "originalFootage": MessageLookupByLibrary.simpleMessage("Original Footage"),
    "originalVideo": MessageLookupByLibrary.simpleMessage("Original Video"),
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
    "overviewAllAds": MessageLookupByLibrary.simpleMessage(
      "Overview — All Ads",
    ),
    "passing": MessageLookupByLibrary.simpleMessage("Passing"),
    "passingAnalysis": MessageLookupByLibrary.simpleMessage("Passing Analysis"),
    "passingAnalysisDescription": MessageLookupByLibrary.simpleMessage(
      "Analyze passing accuracy and technique",
    ),
    "passingAnalysisLabel": MessageLookupByLibrary.simpleMessage("Passing"),
    "passingVideoInstructions": MessageLookupByLibrary.simpleMessage(
      "Record the player\'s upper body and feet. Show both successful and unsuccessful passes.",
    ),
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
    "pay": MessageLookupByLibrary.simpleMessage("Pay"),
    "payLaterDraft": MessageLookupByLibrary.simpleMessage(
      "Pay Later (Ad saved as draft)",
    ),
    "payNow": MessageLookupByLibrary.simpleMessage("Pay Now"),
    "payNowComingSoon": MessageLookupByLibrary.simpleMessage(
      "Pay Now (Coming Soon)",
    ),
    "payNowToUnlock": MessageLookupByLibrary.simpleMessage("Pay Now to Unlock"),
    "paymentComingSoon": MessageLookupByLibrary.simpleMessage(
      "Payment coming soon",
    ),
    "paymentIntegrationComingSoon": MessageLookupByLibrary.simpleMessage(
      "Payment integration is coming soon. You can pay later from your ads dashboard.",
    ),
    "payment_success_subtitle": MessageLookupByLibrary.simpleMessage(
      "Your subscription is now active.\nEnjoy your access! ",
    ),
    "payment_success_title": MessageLookupByLibrary.simpleMessage(
      "Payment Successful!",
    ),
    "payment_success_transaction_id": m26,
    "pending": MessageLookupByLibrary.simpleMessage("Pending"),
    "people": MessageLookupByLibrary.simpleMessage("People"),
    "percentComplete": m27,
    "percentage": m28,
    "percentageWatched": m29,
    "performanceOverview": MessageLookupByLibrary.simpleMessage(
      "Performance Overview",
    ),
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
    "possession": MessageLookupByLibrary.simpleMessage("Possession"),
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
    "postVideoSourceHint": MessageLookupByLibrary.simpleMessage(
      "The post video will be used as the source.",
    ),
    "posts": MessageLookupByLibrary.simpleMessage("Posts"),
    "powerForward": MessageLookupByLibrary.simpleMessage("Power Forward"),
    "preparing": MessageLookupByLibrary.simpleMessage("Preparing…"),
    "price": MessageLookupByLibrary.simpleMessage("Price"),
    "priceEGP": m30,
    "priceEGPtxt": MessageLookupByLibrary.simpleMessage("Price (EGP)"),
    "pricePerDay": m31,
    "priceRequired": MessageLookupByLibrary.simpleMessage("Price is required"),
    "privacyPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Privacy & Policy",
    ),
    "processing": MessageLookupByLibrary.simpleMessage("Processing..."),
    "processing_payment_subtitle": MessageLookupByLibrary.simpleMessage(
      "Please do not close the app",
    ),
    "processing_payment_title": MessageLookupByLibrary.simpleMessage(
      "Processing Payment...",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileLoadFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to load profile. Please try again.",
    ),
    "progress": MessageLookupByLibrary.simpleMessage("Progress"),
    "provideVideoUrl": MessageLookupByLibrary.simpleMessage(
      "Please provide a video URL",
    ),
    "provideVideoUrlOrUpload": MessageLookupByLibrary.simpleMessage(
      "Please provide a video URL or upload a video.",
    ),
    "publicOpportunities": MessageLookupByLibrary.simpleMessage(
      "Public Opportunities",
    ),
    "publicPosts": MessageLookupByLibrary.simpleMessage("Public Posts"),
    "reactionTime": MessageLookupByLibrary.simpleMessage("Reaction Time"),
    "reactionTimeShort": MessageLookupByLibrary.simpleMessage("Reaction Time"),
    "recordWithCamera": MessageLookupByLibrary.simpleMessage(
      "Record with Camera",
    ),
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
    "searchByPlayerName": MessageLookupByLibrary.simpleMessage(
      "Search by player name…",
    ),
    "searchResults": MessageLookupByLibrary.simpleMessage("Search Result"),
    "secondsAgo": m32,
    "seeOriginal": MessageLookupByLibrary.simpleMessage("See Original"),
    "select": MessageLookupByLibrary.simpleMessage("Select"),
    "selectAnalysisType": MessageLookupByLibrary.simpleMessage(
      "Select Analysis Type",
    ),
    "selectAtLeastOne": MessageLookupByLibrary.simpleMessage(
      "Please select at least one sport",
    ),
    "selectEndDate": MessageLookupByLibrary.simpleMessage("Select End Date"),
    "selectField": m33,
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
    "sponsor": MessageLookupByLibrary.simpleMessage("Sponsor"),
    "sport": MessageLookupByLibrary.simpleMessage("Sport"),
    "sportProfession": MessageLookupByLibrary.simpleMessage("Sport profession"),
    "startAnalysis": MessageLookupByLibrary.simpleMessage("Start Analysis"),
    "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
    "startSearching": MessageLookupByLibrary.simpleMessage("Start searching"),
    "stepAiProcessing": MessageLookupByLibrary.simpleMessage(
      "Our AI engine starts processing your video",
    ),
    "stepCompletePayment": MessageLookupByLibrary.simpleMessage(
      "Complete payment using your preferred method",
    ),
    "stepReportNotified": MessageLookupByLibrary.simpleMessage(
      "Report appears in your profile — you\'ll be notified",
    ),
    "strongPassword": MessageLookupByLibrary.simpleMessage(
      "Enter Strong Password ,contain at least 8 characters , 1 uppercase, 1 lowercase, 1 digit , 1 special character ",
    ),
    "subscription": MessageLookupByLibrary.simpleMessage("Subscription"),
    "subscription_btn": MessageLookupByLibrary.simpleMessage("SUBSCRIBE NOW"),
    "subscription_plan_ads_month": m34,
    "subscription_plan_basic_stats": MessageLookupByLibrary.simpleMessage(
      "Basic Stats",
    ),
    "subscription_plan_best_value": MessageLookupByLibrary.simpleMessage(
      "BEST VALUE",
    ),
    "subscription_plan_current": MessageLookupByLibrary.simpleMessage(
      "Current Plan",
    ),
    "subscription_plan_detailed_reports": MessageLookupByLibrary.simpleMessage(
      "Detailed Reports",
    ),
    "subscription_plan_duration_month": m35,
    "subscription_plan_duration_year": m36,
    "subscription_plan_forever": MessageLookupByLibrary.simpleMessage(
      "forever",
    ),
    "subscription_plan_no_ads": MessageLookupByLibrary.simpleMessage("No Ads"),
    "subscription_plan_no_videos": MessageLookupByLibrary.simpleMessage(
      "No Videos",
    ),
    "subscription_plan_per_month": MessageLookupByLibrary.simpleMessage(
      "/ month",
    ),
    "subscription_plan_per_year": MessageLookupByLibrary.simpleMessage(
      "/ year",
    ),
    "subscription_plan_popular": MessageLookupByLibrary.simpleMessage(
      "POPULAR",
    ),
    "subscription_plan_select": MessageLookupByLibrary.simpleMessage(
      "Select Now",
    ),
    "subscription_plan_unlimited_videos": MessageLookupByLibrary.simpleMessage(
      "Unlimited Videos",
    ),
    "subscription_plan_videos_month": m37,
    "subscription_renewal_note": MessageLookupByLibrary.simpleMessage(
      "This is an automatically renewed subscription.\nYou can cancel anytime in settings.",
    ),
    "subscription_retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "subscription_subtitle": MessageLookupByLibrary.simpleMessage(
      "Upgrade and analyse your game without limits",
    ),
    "subscription_title": MessageLookupByLibrary.simpleMessage(
      "Premium Access",
    ),
    "sudan": MessageLookupByLibrary.simpleMessage("Sudan"),
    "supportedFormats": MessageLookupByLibrary.simpleMessage("MP4 · MOV · AVI"),
    "switchAccount": MessageLookupByLibrary.simpleMessage("Switch Account"),
    "taekwondo": MessageLookupByLibrary.simpleMessage("Taekwondo"),
    "tapToAddFirstLesson": MessageLookupByLibrary.simpleMessage(
      "Tap the + button to add your first lesson",
    ),
    "tapToChange": MessageLookupByLibrary.simpleMessage("Tap to Change"),
    "tapToChangeMedia": MessageLookupByLibrary.simpleMessage(
      "Tap to change media",
    ),
    "tapToSelectFromGallery": MessageLookupByLibrary.simpleMessage(
      "Tap to select from gallery",
    ),
    "tapToUploadVideo": MessageLookupByLibrary.simpleMessage(
      "Tap to upload video",
    ),
    "targetAudience": MessageLookupByLibrary.simpleMessage("Target Audience"),
    "teakwando": MessageLookupByLibrary.simpleMessage("Teakwando"),
    "teakwandoPlayer": MessageLookupByLibrary.simpleMessage("Teakwando Player"),
    "team1": MessageLookupByLibrary.simpleMessage("Team 1"),
    "team2": MessageLookupByLibrary.simpleMessage("Team 2"),
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
    "topSpeed": MessageLookupByLibrary.simpleMessage("Top Speed"),
    "topSprintSpeed": MessageLookupByLibrary.simpleMessage("Top Sprint Speed"),
    "totalAds": MessageLookupByLibrary.simpleMessage("Total Ads"),
    "totalAmount": MessageLookupByLibrary.simpleMessage("Total Amount"),
    "totalClicks": MessageLookupByLibrary.simpleMessage("Total Clicks"),
    "totalEnrolled": MessageLookupByLibrary.simpleMessage("Total Enrolled"),
    "totalTouches": MessageLookupByLibrary.simpleMessage("Total Touches"),
    "totalViews": MessageLookupByLibrary.simpleMessage("Total Views"),
    "touchesPerSec": MessageLookupByLibrary.simpleMessage("Touches / sec"),
    "translate": MessageLookupByLibrary.simpleMessage("Translate"),
    "tryAdjustingSearch": MessageLookupByLibrary.simpleMessage(
      "Try adjusting your search or filter",
    ),
    "tryDifferentSearch": MessageLookupByLibrary.simpleMessage(
      "Try a different search",
    ),
    "tunisia": MessageLookupByLibrary.simpleMessage("Tunisia"),
    "unKnown": MessageLookupByLibrary.simpleMessage("N/A"),
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
    "unpaid": MessageLookupByLibrary.simpleMessage("Unpaid"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updateAd": MessageLookupByLibrary.simpleMessage("Update Ad"),
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
    "uploadError": m38,
    "uploadFailedPasteManually": MessageLookupByLibrary.simpleMessage(
      "Upload failed. Paste a URL manually.",
    ),
    "uploadImageOrVideo": MessageLookupByLibrary.simpleMessage(
      "Upload an Image or video",
    ),
    "uploadLesson": MessageLookupByLibrary.simpleMessage("Upload Lesson"),
    "uploadOrLinkVideo": MessageLookupByLibrary.simpleMessage(
      "Upload or Link Your Video",
    ),
    "uploadVideo": MessageLookupByLibrary.simpleMessage("Upload Video"),
    "uploadWillContinue": MessageLookupByLibrary.simpleMessage(
      "Upload will continue in background",
    ),
    "upload_photo_hint": MessageLookupByLibrary.simpleMessage(
      "Upload Achievement Photo",
    ),
    "uploading": MessageLookupByLibrary.simpleMessage("Uploading…"),
    "uploadingInBackground": MessageLookupByLibrary.simpleMessage(
      "Uploading lesson in background...",
    ),
    "uppercaseValidation": MessageLookupByLibrary.simpleMessage(
      "At least 1 uppercase letter",
    ),
    "urlPlaceholder": MessageLookupByLibrary.simpleMessage("https://..."),
    "useInfoBody": MessageLookupByLibrary.simpleMessage(
      "We use the collected data to:\n\n• Personalize your experience within the app.\n• Improve our features and services.\n• Send you relevant notifications about activities or opportunities.\n• Ensure the security and integrity of our platform.",
    ),
    "useInfoTitle": MessageLookupByLibrary.simpleMessage(
      "How We Use Your Information",
    ),
    "userNotFound": MessageLookupByLibrary.simpleMessage("User not found"),
    "userType": MessageLookupByLibrary.simpleMessage("User Type"),
    "usersAnalyses": m39,
    "validEmail": MessageLookupByLibrary.simpleMessage("Enter a valid email"),
    "validHeightRange": MessageLookupByLibrary.simpleMessage(
      "Enter a valid height (1.0 – 2.5 m)",
    ),
    "validationError": MessageLookupByLibrary.simpleMessage(
      "Validation error. Please check your inputs.",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("Verify"),
    "video": MessageLookupByLibrary.simpleMessage("Video"),
    "videoAnalysis": MessageLookupByLibrary.simpleMessage("Video Analysis"),
    "videoFromPost": MessageLookupByLibrary.simpleMessage("Video from Post"),
    "videoPlaybackError": MessageLookupByLibrary.simpleMessage(
      "Video Playback Error",
    ),
    "videoRecordingTips": MessageLookupByLibrary.simpleMessage(
      "Video Recording Tips",
    ),
    "videoTips": MessageLookupByLibrary.simpleMessage("Video Tips"),
    "videoUploaded": MessageLookupByLibrary.simpleMessage("Video uploaded"),
    "videoUrlPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Video URL (Cloudinary, YouTube, etc.)",
    ),
    "viewAnalyticsDashboard": MessageLookupByLibrary.simpleMessage(
      "View Analytics Dashboard",
    ),
    "viewReport": MessageLookupByLibrary.simpleMessage("View Report"),
    "views": MessageLookupByLibrary.simpleMessage("Views"),
    "vodafone_appbar_title": MessageLookupByLibrary.simpleMessage(
      "Enter Card Details",
    ),
    "vodafone_hint": MessageLookupByLibrary.simpleMessage(
      "Mobile Number (e.g., 010xxxxxxxx)",
    ),
    "vodafone_label": MessageLookupByLibrary.simpleMessage(
      "Enter your payment details",
    ),
    "vodafone_name": MessageLookupByLibrary.simpleMessage("vodafone Cash"),
    "vodafone_send_btn": MessageLookupByLibrary.simpleMessage(
      "Send Payment Request",
    ),
    "vodafone_terms": MessageLookupByLibrary.simpleMessage(
      "By continuing you agree to our Terms",
    ),
    "vodafone_validation_empty": MessageLookupByLibrary.simpleMessage(
      "Please enter your mobile number",
    ),
    "vodafone_validation_invalid": MessageLookupByLibrary.simpleMessage(
      "Enter a valid Egyptian mobile number",
    ),
    "volleyball": MessageLookupByLibrary.simpleMessage("Volleyball"),
    "volleyballer": MessageLookupByLibrary.simpleMessage("Volleyballer"),
    "vs": MessageLookupByLibrary.simpleMessage("VS"),
    "wantsToConnect": MessageLookupByLibrary.simpleMessage(
      "Wants to connect with you",
    ),
    "watched": MessageLookupByLibrary.simpleMessage("Watched"),
    "weeklyBreakdown": MessageLookupByLibrary.simpleMessage("Weekly Breakdown"),
    "weeklyDetails": MessageLookupByLibrary.simpleMessage("Weekly Details"),
    "weeksAgo": m40,
    "weight": MessageLookupByLibrary.simpleMessage("Weight (kg)"),
    "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
    "whatHappensNext": MessageLookupByLibrary.simpleMessage(
      "What happens next",
    ),
    "whatIsYourType": MessageLookupByLibrary.simpleMessage(
      "What Is Your Type?",
    ),
    "whatToExpect": MessageLookupByLibrary.simpleMessage("What to expect"),
    "whatWillBeAnalyzed": MessageLookupByLibrary.simpleMessage(
      "What will be analyzed",
    ),
    "whoShouldSeeThisAd": MessageLookupByLibrary.simpleMessage(
      "Who should see this ad?",
    ),
    "year": MessageLookupByLibrary.simpleMessage("Year"),
    "yearsAgo": m41,
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

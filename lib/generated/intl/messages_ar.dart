// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(percentage) => "اكتمل ${percentage}%";

  static String m1(count) =>
      "${Intl.plural(count, one: 'منذ يوم', two: 'منذ يومين', few: 'منذ ${count} أيام', many: 'منذ ${count} يومًا', other: 'منذ ${count} يوم')}";

  static String m2(lessonTitle) =>
      "هل أنت متأكد من حذف \"${lessonTitle}\"؟ لا يمكن التراجع عن هذا الإجراء.";

  static String m3(duration) => "المدة: ${duration}";

  static String m4(price) => "اشترك مقابل ${price}";

  static String m5(count) => "${count} مشترك";

  static String m6(field) => "يرجى إدخال ${field}";

  static String m7(field) => "يجب أن يحتوي ${field} على حرفين على الأقل";

  static String m8(count) =>
      "${Intl.plural(count, one: 'منذ ساعة', two: 'منذ ساعتين', few: 'منذ ${count} ساعات', many: 'منذ ${count} ساعة', other: 'منذ ${count} ساعة')}";

  static String m9(field) => "${field} غير صالح";

  static String m10(number) => "${number} درس";

  static String m11(order) => "ترتيب الدرس: ${order}";

  static String m12(order, duration) =>
      "ترتيب الدرس: ${order} • المدة: ${duration}";

  static String m13(count) => "${count} دروس";

  static String m14(completed, total) => "${completed} / ${total} دروس";

  static String m15(count) =>
      "${Intl.plural(count, one: 'منذ دقيقة', two: 'منذ دقيقتين', few: 'منذ ${count} دقائق', many: 'منذ ${count} دقيقة', other: 'منذ ${count} دقيقة')}";

  static String m16(count) =>
      "${Intl.plural(count, one: 'منذ شهر', two: 'منذ شهرين', few: 'منذ ${count} أشهر', many: 'منذ ${count} شهرًا', other: 'منذ ${count} شهر')}";

  static String m17(searchTerm) => "لا توجد دورات لـ \"${searchTerm}\"";

  static String m18(month) => "لا توجد بيانات متاحة لشهر ${month}";

  static String m19(percentage) => "اكتمل ${percentage}%";

  static String m20(percentage) => "تمت مشاهدة ${percentage}%";

  static String m21(count) =>
      "${Intl.plural(count, one: 'منذ ثانية', two: 'منذ ثانيتين', few: 'منذ ${count} ثوانٍ', many: 'منذ ${count} ثانية', other: 'منذ ${count} ثانية')}";

  static String m22(field) => "يرجى اختيار ${field}";

  static String m23(count) =>
      "${Intl.plural(count, one: 'منذ أسبوع', two: 'منذ أسبوعين', few: 'منذ ${count} أسابيع', many: 'منذ ${count} أسبوعًا', other: 'منذ ${count} أسبوع')}";

  static String m24(count) =>
      "${Intl.plural(count, one: 'منذ سنة', two: 'منذ سنتين', few: 'منذ ${count} سنوات', many: 'منذ ${count} سنة', other: 'منذ ${count} سنة')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "GetYourCode": MessageLookupByLibrary.simpleMessage(
      "احصل على الرمز الخاص بك!",
    ),
    "VerifyAndProceed": MessageLookupByLibrary.simpleMessage("تحقق وتابع"),
    "aboutUs": MessageLookupByLibrary.simpleMessage("معلومات عنا"),
    "accept": MessageLookupByLibrary.simpleMessage("قبول"),
    "accepted": MessageLookupByLibrary.simpleMessage("مقبول"),
    "account": MessageLookupByLibrary.simpleMessage("الحساب"),
    "achievement": MessageLookupByLibrary.simpleMessage("الإنجاز"),
    "achievementDeleted": MessageLookupByLibrary.simpleMessage(
      "تم حذف الإنجاز بنجاح",
    ),
    "achievementUpdated": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الإنجاز بنجاح",
    ),
    "achievement_added_success": MessageLookupByLibrary.simpleMessage(
      "تم إضافة الإنجاز بنجاح",
    ),
    "achievement_updated_success": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الإنجاز بنجاح",
    ),
    "achievements": MessageLookupByLibrary.simpleMessage("الإنجازات"),
    "activities": MessageLookupByLibrary.simpleMessage("الأنشطة"),
    "addAComment": MessageLookupByLibrary.simpleMessage("أضف تعليقاً..."),
    "addAccount": MessageLookupByLibrary.simpleMessage("إضافة حساب"),
    "addAchievement": MessageLookupByLibrary.simpleMessage("إنجاز الجديد"),
    "addLater": MessageLookupByLibrary.simpleMessage("أضف لاحقاً"),
    "addLesson": MessageLookupByLibrary.simpleMessage("إضافة درس"),
    "addLessonQuestion": MessageLookupByLibrary.simpleMessage(
      "هل ترغب في إضافة درس إلى هذه الدورة الآن؟",
    ),
    "addNow": MessageLookupByLibrary.simpleMessage("أضف الآن"),
    "add_achievement_title": MessageLookupByLibrary.simpleMessage(
      "إضافة إنجاز",
    ),
    "age": MessageLookupByLibrary.simpleMessage("العمر"),
    "agreeLabel": MessageLookupByLibrary.simpleMessage("أوافق"),
    "algeria": MessageLookupByLibrary.simpleMessage("الجزائر"),
    "all": MessageLookupByLibrary.simpleMessage("الكل"),
    "allTimeRevenue": MessageLookupByLibrary.simpleMessage("إجمالي الإيرادات"),
    "alreadyApplied": MessageLookupByLibrary.simpleMessage("تم التقديم بالفعل"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "لديك حساب بالفعل؟",
    ),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "لديك حساب بالفعل؟",
    ),
    "analyzeVideo": MessageLookupByLibrary.simpleMessage("تحليل الفيديو"),
    "analyzeVideoComingSoon": MessageLookupByLibrary.simpleMessage(
      "ميزة تحليل الفيديو قريباً",
    ),
    "analyzedPeople": MessageLookupByLibrary.simpleMessage("الأشخاص المحللون"),
    "analyzedVideosReports": MessageLookupByLibrary.simpleMessage(
      "تقارير الفيديو المحللة",
    ),
    "applicants": MessageLookupByLibrary.simpleMessage("المتقدمون"),
    "applicationSubmittedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم تقديم الطلب بنجاح!",
    ),
    "apply": MessageLookupByLibrary.simpleMessage("تقديم"),
    "applyNow": MessageLookupByLibrary.simpleMessage("قدم الآن"),
    "applyOpportunity": MessageLookupByLibrary.simpleMessage(
      "التقديم على الفرصة",
    ),
    "april": MessageLookupByLibrary.simpleMessage("أبريل"),
    "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
    "archive": MessageLookupByLibrary.simpleMessage("أرشفة"),
    "archiveOpportunities": MessageLookupByLibrary.simpleMessage(
      "فرصي المؤرشفة",
    ),
    "archivePost": MessageLookupByLibrary.simpleMessage("أرشفة المنشور"),
    "archivePostConfirmation": MessageLookupByLibrary.simpleMessage(
      "سيتم أرشفة هذا المنشور وإخفائه من ملفك الشخصي وتدفقك، لكن يمكنك استعادته لاحقاً. هل أنت متأكد من رغبتك في أرشفة هذا المنشور؟",
    ),
    "archivePosts": MessageLookupByLibrary.simpleMessage("المنشورات المؤرشفة"),
    "august": MessageLookupByLibrary.simpleMessage("أغسطس"),
    "available": MessageLookupByLibrary.simpleMessage("متاح"),
    "availableCourses": MessageLookupByLibrary.simpleMessage("الدورات المتاحة"),
    "avgProgress": MessageLookupByLibrary.simpleMessage("متوسط التقدم"),
    "back": MessageLookupByLibrary.simpleMessage("رجوع"),
    "badRequest": MessageLookupByLibrary.simpleMessage("طلب غير صالح"),
    "basketball": MessageLookupByLibrary.simpleMessage("كرة السلة"),
    "basketballer": MessageLookupByLibrary.simpleMessage("لاعب كرة السلة"),
    "beTheFirstToCreatePost": MessageLookupByLibrary.simpleMessage(
      "كن أول من ينشر منشوراً!",
    ),
    "bio": MessageLookupByLibrary.simpleMessage("الوصف"),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cancelEdit": MessageLookupByLibrary.simpleMessage("إلغاء التعديل"),
    "center": MessageLookupByLibrary.simpleMessage("محور (Center)"),
    "centerBack": MessageLookupByLibrary.simpleMessage("صانع لعب (وسط خلفي)"),
    "changePassword": MessageLookupByLibrary.simpleMessage("تغيير كلمة المرور"),
    "changeVideo": MessageLookupByLibrary.simpleMessage("تغيير الفيديو"),
    "changesBody": MessageLookupByLibrary.simpleMessage(
      "قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر. سيتم إعلامك بأي تغييرات مهمة من خلال التطبيق.",
    ),
    "changesTitle": MessageLookupByLibrary.simpleMessage(
      "التغييرات في هذه السياسة",
    ),
    "chat": MessageLookupByLibrary.simpleMessage("دردشة"),
    "chats": MessageLookupByLibrary.simpleMessage("المحادثات"),
    "clear": MessageLookupByLibrary.simpleMessage("مسح"),
    "clearFilters": MessageLookupByLibrary.simpleMessage("مسح الفلاتر"),
    "close": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "club": MessageLookupByLibrary.simpleMessage("نادي"),
    "clubName": MessageLookupByLibrary.simpleMessage("اسم النادي"),
    "coach": MessageLookupByLibrary.simpleMessage("مدرب"),
    "commentAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم إضافة التعليق بنجاح",
    ),
    "commentDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم حذف التعليق بنجاح",
    ),
    "commentUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم تحديث التعليق بنجاح",
    ),
    "comments": MessageLookupByLibrary.simpleMessage("التعليقات"),
    "completePercentage": m0,
    "completed": MessageLookupByLibrary.simpleMessage("مكتمل"),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage(
      "تأكيد كلمة المرور",
    ),
    "confirmPasswordIsRequired": MessageLookupByLibrary.simpleMessage(
      "تأكيد كلمة المرور مطلوب",
    ),
    "conflict": MessageLookupByLibrary.simpleMessage("حدث تعارض في البيانات"),
    "connect": MessageLookupByLibrary.simpleMessage("اتصل"),
    "connected": MessageLookupByLibrary.simpleMessage("متصل"),
    "connectionError": MessageLookupByLibrary.simpleMessage("فشل الاتصال"),
    "connectionSuccess": MessageLookupByLibrary.simpleMessage(
      "تم الاتصال بنجاح!",
    ),
    "connectionTimedOut": MessageLookupByLibrary.simpleMessage(
      "انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.",
    ),
    "connections": MessageLookupByLibrary.simpleMessage("الاتصالات"),
    "contactBody": MessageLookupByLibrary.simpleMessage(
      "إذا كانت لديك أي أسئلة أو مخاوف بشأن سياسة الخصوصية هذه، يرجى التواصل معنا عبر البريد الإلكتروني: support@sportsin.app",
    ),
    "contactTitle": MessageLookupByLibrary.simpleMessage("تواصل معنا"),
    "contactUs": MessageLookupByLibrary.simpleMessage("اتصل بنا"),
    "continueButton": MessageLookupByLibrary.simpleMessage("استمر"),
    "continueText": MessageLookupByLibrary.simpleMessage("استمر"),
    "continueWatching": MessageLookupByLibrary.simpleMessage("متابعة المشاهدة"),
    "continueWith": MessageLookupByLibrary.simpleMessage(
      "أو المتابعة باستخدام",
    ),
    "courseCreatedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء الدورة بنجاح",
    ),
    "courseDeleted": MessageLookupByLibrary.simpleMessage("تم حذف الدورة"),
    "courseDescriptionHint": MessageLookupByLibrary.simpleMessage("وصف الدورة"),
    "courseProgress": MessageLookupByLibrary.simpleMessage("تقدم الدورة"),
    "courseThumbnail": MessageLookupByLibrary.simpleMessage(
      "صورة مصغرة للدورة",
    ),
    "courseTitleHint": MessageLookupByLibrary.simpleMessage("عنوان الدورة"),
    "courses": MessageLookupByLibrary.simpleMessage("الدورات"),
    "create": MessageLookupByLibrary.simpleMessage("إنشاء"),
    "createAchievement": MessageLookupByLibrary.simpleMessage("إنشاء إنجاز"),
    "createAdvertisement": MessageLookupByLibrary.simpleMessage("إنشاء إعلان"),
    "createCourse": MessageLookupByLibrary.simpleMessage("إنشاء دورة"),
    "createOpportunity": MessageLookupByLibrary.simpleMessage("إنشاء فرصة"),
    "createPost": MessageLookupByLibrary.simpleMessage("إنشاء منشور"),
    "createYourAccount": MessageLookupByLibrary.simpleMessage("أنشئ حسابك"),
    "currentVideo": MessageLookupByLibrary.simpleMessage("الفيديو الحالي"),
    "currentlyInClub": MessageLookupByLibrary.simpleMessage("حاليًا في نادٍ"),
    "date": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "date_label": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "daysAgo": m1,
    "december": MessageLookupByLibrary.simpleMessage("ديسمبر"),
    "defender": MessageLookupByLibrary.simpleMessage("مدافع"),
    "delete": MessageLookupByLibrary.simpleMessage("حذف"),
    "deleteComment": MessageLookupByLibrary.simpleMessage("حذف التعليق"),
    "deleteCommentConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من حذف هذا التعليق؟",
    ),
    "deleteCourse": MessageLookupByLibrary.simpleMessage("حذف الدورة"),
    "deleteCourseConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من حذف هذه الدورة؟",
    ),
    "deleteLesson": MessageLookupByLibrary.simpleMessage("حذف الدرس"),
    "deleteLessonConfirmation": m2,
    "deleteOpportunity": MessageLookupByLibrary.simpleMessage("حذف الفرصة"),
    "deleteOpportunityConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من حذف هذه الفرصة؟ لا يمكن التراجع عن هذا الإجراء.",
    ),
    "deletePost": MessageLookupByLibrary.simpleMessage("حذف المنشور"),
    "deletePostConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من حذف هذا المنشور؟",
    ),
    "deleteachievement": MessageLookupByLibrary.simpleMessage("حذف الإنجاز"),
    "deleteachievementconfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد حذف هذا الإنجاز؟",
    ),
    "deletingLesson": MessageLookupByLibrary.simpleMessage("جاري حذف الدرس..."),
    "deletingOpportunity": MessageLookupByLibrary.simpleMessage(
      "جاري حذف الفرصة...",
    ),
    "description": MessageLookupByLibrary.simpleMessage("الوصف"),
    "descriptionRequired": MessageLookupByLibrary.simpleMessage("الوصف مطلوب"),
    "description_hint": MessageLookupByLibrary.simpleMessage("اشرح إنجازك..."),
    "description_label": MessageLookupByLibrary.simpleMessage("الوصف"),
    "details": MessageLookupByLibrary.simpleMessage("التفاصيل"),
    "disconnectSuccess": MessageLookupByLibrary.simpleMessage(
      "تم قطع الاتصال بنجاح!",
    ),
    "done": MessageLookupByLibrary.simpleMessage("تم"),
    "duration": m3,
    "edit": MessageLookupByLibrary.simpleMessage("تعديل"),
    "editCourse": MessageLookupByLibrary.simpleMessage("تعديل الدورة"),
    "editLesson": MessageLookupByLibrary.simpleMessage("تعديل الدرس"),
    "editPrice": MessageLookupByLibrary.simpleMessage("تعديل السعر"),
    "editProfile": MessageLookupByLibrary.simpleMessage("عدل الحساب"),
    "editProfileFailed": MessageLookupByLibrary.simpleMessage(
      "فشل تحديث الملف الشخصي.",
    ),
    "editProfileSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الملف الشخصي بنجاح!",
    ),
    "editYourComment": MessageLookupByLibrary.simpleMessage("عدّل تعليقك..."),
    "edit_achievement": MessageLookupByLibrary.simpleMessage("تعديل الإنجاز"),
    "editingComment": MessageLookupByLibrary.simpleMessage(
      "جاري تعديل التعليق",
    ),
    "egp": MessageLookupByLibrary.simpleMessage("جنيه"),
    "egypt": MessageLookupByLibrary.simpleMessage("مصر"),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "emailAlreadyExists": MessageLookupByLibrary.simpleMessage(
      "هذا البريد الإلكتروني مسجل بالفعل",
    ),
    "emailVerfiy": MessageLookupByLibrary.simpleMessage(
      "التحقق من البريد الإلكتروني",
    ),
    "emptyEmail": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني مطلوب",
    ),
    "emptyPassword": MessageLookupByLibrary.simpleMessage("كلمة المرور مطلوبة"),
    "endDate": MessageLookupByLibrary.simpleMessage("تاريخ الانتهاء"),
    "english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
    "enroll": MessageLookupByLibrary.simpleMessage("اشتراك"),
    "enrollForPrice": m4,
    "enrollNow": MessageLookupByLibrary.simpleMessage("اشترك الآن"),
    "enrolled": MessageLookupByLibrary.simpleMessage("تاريخ الاشتراك"),
    "enrolledCount": m5,
    "enrolledCourses": MessageLookupByLibrary.simpleMessage(
      "الدورات المسجل فيها",
    ),
    "enrolledSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم الاشتراك بنجاح",
    ),
    "enrolleesWillAppear": MessageLookupByLibrary.simpleMessage(
      "سيظهر الطلاب المسجلون هنا",
    ),
    "enterAge": MessageLookupByLibrary.simpleMessage("يرجى إدخال العمر"),
    "enterCourseDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "أدخل وصف الدورة",
    ),
    "enterCourseTitleHint": MessageLookupByLibrary.simpleMessage(
      "أدخل عنوان الدورة",
    ),
    "enterDate": MessageLookupByLibrary.simpleMessage("يرجى اختيار التاريخ"),
    "enterDescriptionHint": MessageLookupByLibrary.simpleMessage("أدخل الوصف"),
    "enterEmail": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال البريد الإلكتروني",
    ),
    "enterEmailAddressHere": MessageLookupByLibrary.simpleMessage(
      "أدخل عنوان البريد الإلكتروني هنا",
    ),
    "enterEmailAssociated": MessageLookupByLibrary.simpleMessage(
      "أدخل عنوان البريد الإلكتروني المرتبط بحسابك",
    ),
    "enterExperience": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال عدد سنين الخبرة",
    ),
    "enterField": m6,
    "enterHeight": MessageLookupByLibrary.simpleMessage("يرجى إدخال الطول"),
    "enterLessonTitleHint": MessageLookupByLibrary.simpleMessage(
      "أدخل عنوان الدرس",
    ),
    "enterNewPassword": MessageLookupByLibrary.simpleMessage(
      "أدخل كلمة المرور الجديدة",
    ),
    "enterPassword": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال كلمة المرور",
    ),
    "enterPriceHint": MessageLookupByLibrary.simpleMessage(
      "أدخل السعر (0 للمجاني)",
    ),
    "enterWeight": MessageLookupByLibrary.simpleMessage("يرجى إدخال الوزن"),
    "enterYourDescription": MessageLookupByLibrary.simpleMessage(
      "أدخل وصفك...",
    ),
    "enterYourRequirements": MessageLookupByLibrary.simpleMessage(
      "أدخل المتطلبات...",
    ),
    "enterYourTitle": MessageLookupByLibrary.simpleMessage("أدخل عنوانك."),
    "error": MessageLookupByLibrary.simpleMessage("خطأ"),
    "errorLoadingApplicants": MessageLookupByLibrary.simpleMessage(
      "خطأ في تحميل المتقدمين",
    ),
    "error_picking_image": MessageLookupByLibrary.simpleMessage(
      "خطأ في اختيار الصورة. الرجاء المحاولة مرة أخرى.",
    ),
    "error_picking_video": MessageLookupByLibrary.simpleMessage(
      "خطأ في اختيار الفيديو. الرجاء المحاولة مرة أخرى.",
    ),
    "extractingDuration": MessageLookupByLibrary.simpleMessage(
      "جاري استخراج المدة...",
    ),
    "failedToLoadImage": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل الصورة",
    ),
    "failedToLoadVideo": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل الفيديو",
    ),
    "failedToPlayVideo": MessageLookupByLibrary.simpleMessage(
      "فشل تشغيل الفيديو",
    ),
    "failedToSendMessage": MessageLookupByLibrary.simpleMessage(
      "فشل في إرسال الرسالة. يرجى المحاولة مرة أخرى.",
    ),
    "failedToTranslate": MessageLookupByLibrary.simpleMessage("فشلت الترجمة"),
    "failed_to_read_video_duration": MessageLookupByLibrary.simpleMessage(
      "فشل في قراءة مدة الفيديو",
    ),
    "february": MessageLookupByLibrary.simpleMessage("فبراير"),
    "female": MessageLookupByLibrary.simpleMessage("أنثى"),
    "field": MessageLookupByLibrary.simpleMessage("الحقل"),
    "fieldTooShort": m7,
    "file_size_exceeds_limit": MessageLookupByLibrary.simpleMessage(
      "حجم الملف يتجاوز 500 ميجابايت",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("الاسم الأول"),
    "follow": MessageLookupByLibrary.simpleMessage("تابع"),
    "followError": MessageLookupByLibrary.simpleMessage("فشلت المتابعة"),
    "followSuccess": MessageLookupByLibrary.simpleMessage(
      "تمت المتابعة بنجاح!",
    ),
    "followers": MessageLookupByLibrary.simpleMessage("يتابع"),
    "following": MessageLookupByLibrary.simpleMessage("متابع"),
    "football": MessageLookupByLibrary.simpleMessage("كرة القدم"),
    "footballer": MessageLookupByLibrary.simpleMessage("لاعب كرة القدم"),
    "forYou": MessageLookupByLibrary.simpleMessage("من اجلك"),
    "forbidden": MessageLookupByLibrary.simpleMessage("الوصول محظور"),
    "forgetPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور"),
    "forgetYourPassword": MessageLookupByLibrary.simpleMessage(
      "هل نسيت كلمة المرور؟",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور"),
    "forward": MessageLookupByLibrary.simpleMessage("مهاجم"),
    "foundDate": MessageLookupByLibrary.simpleMessage("تاريخ التأسيس"),
    "free": MessageLookupByLibrary.simpleMessage("مجاني"),
    "freeCourse": MessageLookupByLibrary.simpleMessage("دورة مجانية"),
    "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
    "gender": MessageLookupByLibrary.simpleMessage("الجنس"),
    "getStarted": MessageLookupByLibrary.simpleMessage("ابدأ"),
    "goalkeeper": MessageLookupByLibrary.simpleMessage("حارس المرمى"),
    "guest": MessageLookupByLibrary.simpleMessage("ضيف"),
    "gymnast": MessageLookupByLibrary.simpleMessage("لاعب جمباز"),
    "gymnastics": MessageLookupByLibrary.simpleMessage("الجمباز"),
    "handball": MessageLookupByLibrary.simpleMessage("كرة اليد"),
    "handballPlayer": MessageLookupByLibrary.simpleMessage("لاعب كرة اليد"),
    "happyToSeeYouToday": MessageLookupByLibrary.simpleMessage(
      "سعداء برؤيتك اليوم",
    ),
    "height": MessageLookupByLibrary.simpleMessage("الطول (سم)"),
    "hi": MessageLookupByLibrary.simpleMessage("مرحباً"),
    "hideDescription": MessageLookupByLibrary.simpleMessage("إخفاء الوصف"),
    "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "hoursAgo": m8,
    "industary": MessageLookupByLibrary.simpleMessage("المجال"),
    "informationBody": MessageLookupByLibrary.simpleMessage(
      "عند استخدامك لتطبيق سبورتس إن، قد نقوم بجمع الأنواع التالية من المعلومات:\n\n• البيانات الشخصية: الاسم، البريد الإلكتروني، صورة الملف الشخصي، المهارات والاهتمامات الرياضية.\n• بيانات النشاط: المنشورات، الرسائل، الإعجابات، والتفاعلات الأخرى.\n• بيانات الجهاز: نوع الجهاز، نظام التشغيل، وعنوان IP.",
    ),
    "informationTitle": MessageLookupByLibrary.simpleMessage(
      "المعلومات التي نجمعها",
    ),
    "institute": MessageLookupByLibrary.simpleMessage("موْسسة"),
    "instituteName": MessageLookupByLibrary.simpleMessage("اسم الموْسسة"),
    "interests": MessageLookupByLibrary.simpleMessage("الاهتمامات"),
    "introductionBody": MessageLookupByLibrary.simpleMessage(
      "سبورتس إن هي منصة اجتماعية احترافية للرياضيين والمدربين والأندية الرياضية للتواصل ومشاركة الخبرات واكتشاف الفرص.",
    ),
    "introductionTitle": MessageLookupByLibrary.simpleMessage("المقدمة"),
    "invalidAge": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال عمر صالح (5-99)",
    ),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال بريد إلكتروني صالح",
    ),
    "invalidEmailOrPassword": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني أو كلمة المرور غير صحيحة.",
    ),
    "invalidField": m9,
    "invalidHeight": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال طول صالح (100–250 سم)",
    ),
    "invalidPassword": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور غير صحيحة",
    ),
    "invalidPrice": MessageLookupByLibrary.simpleMessage("سعر غير صالح"),
    "invalidVideoDuration": MessageLookupByLibrary.simpleMessage(
      "مدة الفيديو غير صالحة. الرجاء اختيار فيديو آخر.",
    ),
    "invalidWeight": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال وزن صالح (30–200 كجم)",
    ),
    "january": MessageLookupByLibrary.simpleMessage("يناير"),
    "july": MessageLookupByLibrary.simpleMessage("يوليو"),
    "june": MessageLookupByLibrary.simpleMessage("يونيو"),
    "justNow": MessageLookupByLibrary.simpleMessage("الآن"),
    "knowingYourGoal": MessageLookupByLibrary.simpleMessage(
      "معرفة هدفك تساعدنا على تخصيص تجربتك",
    ),
    "lastName": MessageLookupByLibrary.simpleMessage("اسم العائلة"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage(
      "آخر تحديث: 11 أكتوبر 2025",
    ),
    "latestCourses": MessageLookupByLibrary.simpleMessage("أحدث الدورات"),
    "latestPosts": MessageLookupByLibrary.simpleMessage("أحدث المنشورات"),
    "leftBack": MessageLookupByLibrary.simpleMessage("ظهير أيسر"),
    "leftWing": MessageLookupByLibrary.simpleMessage("جناح أيسر"),
    "lessonNumber": m10,
    "lessonOrder": m11,
    "lessonOrderAndDuration": m12,
    "lessonOrderSaved": MessageLookupByLibrary.simpleMessage(
      "تم حفظ ترتيب الدروس",
    ),
    "lessonTitle": MessageLookupByLibrary.simpleMessage("عنوان الدرس"),
    "lessons": MessageLookupByLibrary.simpleMessage("الدروس"),
    "lessonsCount": m13,
    "lessonsProgress": m14,
    "libero": MessageLookupByLibrary.simpleMessage("ليبرو (Libero)"),
    "likes": MessageLookupByLibrary.simpleMessage("الإعجابات"),
    "loading": MessageLookupByLibrary.simpleMessage("جار التحميل"),
    "loadingUserData": MessageLookupByLibrary.simpleMessage(
      "جاري تحميل بيانات المستخدم...",
    ),
    "location": MessageLookupByLibrary.simpleMessage("الموقع"),
    "loginSuccess": MessageLookupByLibrary.simpleMessage(
      "مرحبًا بعودتك، هيا نبدأ!",
    ),
    "loginToYourAccount": MessageLookupByLibrary.simpleMessage(
      "سجّل الدخول إلى حسابك",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد تسجيل الخروج؟",
    ),
    "lowercaseValidation": MessageLookupByLibrary.simpleMessage(
      "على الأقل حرف صغير واحد",
    ),
    "makeVideoAnalysis": MessageLookupByLibrary.simpleMessage(
      "عمل تحليل فيديو",
    ),
    "male": MessageLookupByLibrary.simpleMessage("ذكر"),
    "manageAchievement": MessageLookupByLibrary.simpleMessage(
      "إدارة الإنجازات",
    ),
    "manageAdvertisement": MessageLookupByLibrary.simpleMessage(
      "إدارة الإعلانات",
    ),
    "manageCourse": MessageLookupByLibrary.simpleMessage("إدارة الدروس"),
    "manageOpportunities": MessageLookupByLibrary.simpleMessage("إدارة الفرص"),
    "managePosts": MessageLookupByLibrary.simpleMessage("إدارة المنشورات"),
    "manageSubscription": MessageLookupByLibrary.simpleMessage(
      "إدارة إلإشتراك",
    ),
    "manageVideoAnalysis": MessageLookupByLibrary.simpleMessage(
      "إدارة تحليل الفيديو",
    ),
    "march": MessageLookupByLibrary.simpleMessage("مارس"),
    "maxFileSize": MessageLookupByLibrary.simpleMessage(
      "الحد الأقصى 500 ميجابايت",
    ),
    "maximumFileSize": MessageLookupByLibrary.simpleMessage(
      "الحد الأقصى لحجم الملف 200 ميجابايت",
    ),
    "may": MessageLookupByLibrary.simpleMessage("مايو"),
    "messageSent": MessageLookupByLibrary.simpleMessage(
      "تم إرسال الرسالة بنجاح",
    ),
    "middleBlocker": MessageLookupByLibrary.simpleMessage(
      "حائط صد وسطي (Middle Blocker)",
    ),
    "midfielder": MessageLookupByLibrary.simpleMessage("لاعب وسط"),
    "minLengthValidation": MessageLookupByLibrary.simpleMessage(
      "يجب أن تتكون من 8 أحرف على الأقل",
    ),
    "minutesAgo": m15,
    "month": MessageLookupByLibrary.simpleMessage("الشهر"),
    "monthsAgo": m16,
    "moreDetails": MessageLookupByLibrary.simpleMessage("المزيد من التفاصيل"),
    "morocco": MessageLookupByLibrary.simpleMessage("المغرب"),
    "myContacts": MessageLookupByLibrary.simpleMessage("جهات اتصالي"),
    "myCourses": MessageLookupByLibrary.simpleMessage("دوراتي"),
    "myOpportunities": MessageLookupByLibrary.simpleMessage("فرصي"),
    "myPosts": MessageLookupByLibrary.simpleMessage("منشوراتي"),
    "name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "nationality": MessageLookupByLibrary.simpleMessage("الجنسية"),
    "newConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "طلبات الاتصال الجديدة",
    ),
    "newCourses": MessageLookupByLibrary.simpleMessage("دورات جديدة"),
    "newPassword": MessageLookupByLibrary.simpleMessage("كلمة المرور الجديدة"),
    "newVideoSelected": MessageLookupByLibrary.simpleMessage(
      "تم اختيار فيديو جديد",
    ),
    "newVideoWillBeUploaded": MessageLookupByLibrary.simpleMessage(
      "سيتم رفع فيديو جديد",
    ),
    "next": MessageLookupByLibrary.simpleMessage("التالي"),
    "noAcceptedApplicants": MessageLookupByLibrary.simpleMessage(
      "لا يوجد متقدمون مقبولون",
    ),
    "noAchievements": MessageLookupByLibrary.simpleMessage("لا توجدإنجازات"),
    "noApplicantsFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على متقدمين",
    ),
    "noArchivedPosts": MessageLookupByLibrary.simpleMessage(
      "لا توجد منشورات مؤرشفة",
    ),
    "noAvailableCourses": MessageLookupByLibrary.simpleMessage(
      "لا توجد دورات متاحة",
    ),
    "noBio": MessageLookupByLibrary.simpleMessage("لا وصف"),
    "noCommentsYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد تعليقات بعد",
    ),
    "noConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "لا توجد طلبات اتصال",
    ),
    "noContactsYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد جهات اتصال بعد",
    ),
    "noCourses": MessageLookupByLibrary.simpleMessage("لا توجد دورات"),
    "noCoursesFound": MessageLookupByLibrary.simpleMessage("لا توجد دورات"),
    "noCoursesFoundFor": m17,
    "noDataForMonth": m18,
    "noDescriptionAvailable": MessageLookupByLibrary.simpleMessage(
      "لا يوجد وصف متاح",
    ),
    "noEnrolleesYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد مشتركين بعد",
    ),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "لا يوجد اتصال بالإنترنت.",
    ),
    "noLessonsAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد دروس متاحة",
    ),
    "noLikesYet": MessageLookupByLibrary.simpleMessage("لا توجد إعجابات بعد"),
    "noMoreRequests": MessageLookupByLibrary.simpleMessage(
      "لا توجد المزيد من طلبات الاتصال",
    ),
    "noOpportunities": MessageLookupByLibrary.simpleMessage("لا توجد فرص"),
    "noOpportunitiesAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد فرص متاحة",
    ),
    "noOpportunitiesFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على فرص",
    ),
    "noPosts": MessageLookupByLibrary.simpleMessage("لا توجد منشورات"),
    "noPostsAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد منشورات متاحة",
    ),
    "noPostsYet": MessageLookupByLibrary.simpleMessage("لا توجد منشورات بعد"),
    "noProfileData": MessageLookupByLibrary.simpleMessage(
      "لا توجد بيانات ملف شخصي.",
    ),
    "noRejectedApplicants": MessageLookupByLibrary.simpleMessage(
      "لا يوجد متقدمون مرفوضون",
    ),
    "noResultsForCriteria": MessageLookupByLibrary.simpleMessage(
      "لا توجد نتائج لمعايير البحث",
    ),
    "noResultsFound": MessageLookupByLibrary.simpleMessage("لا توجد نتائج"),
    "noUserDataFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على بيانات المستخدم",
    ),
    "notDetected": MessageLookupByLibrary.simpleMessage("غير محدد"),
    "notHaveAccount": MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟"),
    "notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
    "november": MessageLookupByLibrary.simpleMessage("نوفمبر"),
    "number": MessageLookupByLibrary.simpleMessage("الرقم"),
    "numberValidation": MessageLookupByLibrary.simpleMessage(
      "على الأقل رقم واحد",
    ),
    "october": MessageLookupByLibrary.simpleMessage("أكتوبر"),
    "ok": MessageLookupByLibrary.simpleMessage("حسنًا"),
    "onboarding1Desc": MessageLookupByLibrary.simpleMessage(
      "ابحث وتواصل مع أفضل الرياضيين من خلال اكتشاف المواهب المدعوم بالذكاء الاصطناعي.",
    ),
    "onboarding1Title": MessageLookupByLibrary.simpleMessage(
      "اكتشف المواهب الرياضية",
    ),
    "onboarding2Desc": MessageLookupByLibrary.simpleMessage(
      "أنشئ وانشر تجارب الأداء أو البطولات لجذب الرياضيين المناسبين.",
    ),
    "onboarding2Title": MessageLookupByLibrary.simpleMessage("انشر الفرص"),
    "onboarding3Desc": MessageLookupByLibrary.simpleMessage(
      "انضم إلى SportsIn وارتقِ بمسيرتك الرياضية إلى المستوى التالي.",
    ),
    "onboarding3Title": MessageLookupByLibrary.simpleMessage(
      "أنشئ ملفك الرياضي",
    ),
    "onboarding4Desc": MessageLookupByLibrary.simpleMessage(
      "حمّل مقاطع الفيديو الخاصة بك واحصل على تحليل فوري مدعوم بالذكاء الاصطناعي.",
    ),
    "onboarding4Title": MessageLookupByLibrary.simpleMessage(
      "تحليل الفيديو بالذكاء الاصطناعي",
    ),
    "onboarding5Desc": MessageLookupByLibrary.simpleMessage(
      "تحدث مباشرة مع المدربين والأندية والرياضيين. كوّن شبكتك الرياضية وابقَ على اطلاع على الفرص الجديدة.",
    ),
    "onboarding5Title": MessageLookupByLibrary.simpleMessage("تواصل وتفاعل"),
    "online": MessageLookupByLibrary.simpleMessage("متصل"),
    "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "عذراً! حدث خطأ ما",
    ),
    "opportunities": MessageLookupByLibrary.simpleMessage("الفرص"),
    "opportunityCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء الفرصة بنجاح!",
    ),
    "oppositeHitter": MessageLookupByLibrary.simpleMessage(
      "مهاجم معاكس (Opposite Hitter)",
    ),
    "other": MessageLookupByLibrary.simpleMessage("أخرى"),
    "otpHint": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال رمز مكون من 6 أرقام تم إرساله إلى عنوان بريدك الإلكتروني",
    ),
    "otpMsgError": MessageLookupByLibrary.simpleMessage(
      "الرجاء إدخال جميع الأرقام الستة للتحقق من بريدك الإلكتروني",
    ),
    "otpMsgSuccess": MessageLookupByLibrary.simpleMessage(
      "تم التحقق من بريدك الإلكتروني بنجاح",
    ),
    "otpSentSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم إرسال رمز التحقق بنجاح! يرجى التحقق من بريدك الإلكتروني.",
    ),
    "outsideHitter": MessageLookupByLibrary.simpleMessage(
      "مهاجم خارجي (Outside Hitter)",
    ),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "passwordHintDesc": MessageLookupByLibrary.simpleMessage(
      "يجب أن تكون كلمة المرور الجديدة مختلفة عن السابقة",
    ),
    "passwordIsRequired": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور مطلوبة",
    ),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "يجب أن تتكون كلمة المرور من 8 أحرف على الأقل.",
    ),
    "passwordMismatch": MessageLookupByLibrary.simpleMessage(
      "كلمات المرور غير متطابقة",
    ),
    "passwordNeedsLowercase": MessageLookupByLibrary.simpleMessage(
      "يجب أن تحتوي كلمة المرور على حرف صغير واحد على الأقل.",
    ),
    "passwordNeedsNumber": MessageLookupByLibrary.simpleMessage(
      "يجب أن تحتوي كلمة المرور على رقم واحد على الأقل.",
    ),
    "passwordNeedsSpecialChar": MessageLookupByLibrary.simpleMessage(
      "يجب أن تحتوي كلمة المرور على رمز خاص واحد على الأقل (!@#\$%^&* إلخ).",
    ),
    "passwordNeedsUppercase": MessageLookupByLibrary.simpleMessage(
      "يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل.",
    ),
    "passwordsDonotMatch": MessageLookupByLibrary.simpleMessage(
      "كلمتا المرور غير متطابقتين",
    ),
    "passwordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "كلمتا المرور غير متطابقتين",
    ),
    "pending": MessageLookupByLibrary.simpleMessage("معلق"),
    "percentComplete": m19,
    "percentageWatched": m20,
    "personalInfo": MessageLookupByLibrary.simpleMessage("المعلومات الشخصية"),
    "pickImage": MessageLookupByLibrary.simpleMessage("اختر صورة"),
    "pickVideo": MessageLookupByLibrary.simpleMessage("اختر فيديو"),
    "pivot": MessageLookupByLibrary.simpleMessage("محور (Pivot)"),
    "player": MessageLookupByLibrary.simpleMessage("لاعب"),
    "playing": MessageLookupByLibrary.simpleMessage("جارٍ التشغيل"),
    "pleaseEnterDescription": MessageLookupByLibrary.simpleMessage(
      "الرجاء إدخال وصف",
    ),
    "pleaseEnterPrice": MessageLookupByLibrary.simpleMessage(
      "الرجاء إدخال السعر",
    ),
    "pleaseEnterRequirements": MessageLookupByLibrary.simpleMessage(
      "الرجاء إدخال المتطلبات",
    ),
    "pleaseEnterTitle": MessageLookupByLibrary.simpleMessage(
      "الرجاء إدخال عنوان",
    ),
    "pleaseEnteraStrongPassword": MessageLookupByLibrary.simpleMessage(
      "يرجى إدخال كلمة مرور قوية",
    ),
    "pleaseFillAllFields": MessageLookupByLibrary.simpleMessage(
      "يرجى ملء جميع الحقول",
    ),
    "pleaseSelectEndDate": MessageLookupByLibrary.simpleMessage(
      "الرجاء اختيار تاريخ الانتهاء",
    ),
    "pleaseSelectSport": MessageLookupByLibrary.simpleMessage(
      "الرجاء اختيار رياضة",
    ),
    "pleaseSelectVideo": MessageLookupByLibrary.simpleMessage(
      "الرجاء اختيار فيديو",
    ),
    "please_select_date": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار تاريخ",
    ),
    "pointGuard": MessageLookupByLibrary.simpleMessage(
      "صانع ألعاب (Point Guard)",
    ),
    "position": MessageLookupByLibrary.simpleMessage("المركز"),
    "post": MessageLookupByLibrary.simpleMessage("نشر"),
    "postArchived": MessageLookupByLibrary.simpleMessage(
      "تم أرشفة المنشور بنجاح!",
    ),
    "postDeleteFailed": MessageLookupByLibrary.simpleMessage(
      "فشل حذف المنشور. حاول مرة أخرى.",
    ),
    "postDeleted": MessageLookupByLibrary.simpleMessage(
      "تم حذف المنشور بنجاح!",
    ),
    "postRestored": MessageLookupByLibrary.simpleMessage(
      "تمت استعادة المنشور بنجاح!",
    ),
    "postUpdateFailed": MessageLookupByLibrary.simpleMessage(
      "فشل تحديث المنشور. حاول مرة أخرى.",
    ),
    "postUpdated": MessageLookupByLibrary.simpleMessage(
      "تم تحديث المنشور بنجاح!",
    ),
    "postUploadedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم رفع المنشور بنجاح!",
    ),
    "posts": MessageLookupByLibrary.simpleMessage("المنشورات"),
    "powerForward": MessageLookupByLibrary.simpleMessage(
      "مهاجم قوي (Power Forward)",
    ),
    "price": MessageLookupByLibrary.simpleMessage("السعر"),
    "priceEGP": MessageLookupByLibrary.simpleMessage("السعر (جنيه)"),
    "priceRequired": MessageLookupByLibrary.simpleMessage("السعر مطلوب"),
    "privacyPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "الخصوصية والسياسة",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "profileLoadFailed": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل الملف الشخصي. يرجى المحاولة مرة أخرى.",
    ),
    "progress": MessageLookupByLibrary.simpleMessage("التقدم"),
    "publicOpportunities": MessageLookupByLibrary.simpleMessage("فرصي العامة"),
    "publicPosts": MessageLookupByLibrary.simpleMessage("المنشورات العامة"),
    "register": MessageLookupByLibrary.simpleMessage("تسجيل"),
    "registeredSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم التسجيل بنجاح!",
    ),
    "registrationFailed": MessageLookupByLibrary.simpleMessage(
      "فشل التسجيل. يرجى المحاولة مرة أخرى.",
    ),
    "registrationSuccessful": MessageLookupByLibrary.simpleMessage(
      "تم التسجيل بنجاح!",
    ),
    "reject": MessageLookupByLibrary.simpleMessage("رفض"),
    "rejected": MessageLookupByLibrary.simpleMessage("مرفوض"),
    "remove": MessageLookupByLibrary.simpleMessage("إزالة"),
    "replaceVideo": MessageLookupByLibrary.simpleMessage("استبدال الفيديو"),
    "requestCancelled": MessageLookupByLibrary.simpleMessage("تم إلغاء الطلب."),
    "requirements": MessageLookupByLibrary.simpleMessage("المتطلبات"),
    "resetPassword": MessageLookupByLibrary.simpleMessage(
      "إعادة تعيين كلمة المرور",
    ),
    "resetPasswordFailure": MessageLookupByLibrary.simpleMessage(
      "فشل إعادة تعيين كلمة المرور. حاول مرة أخرى",
    ),
    "resetPasswordSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إعادة تعيين كلمة المرور بنجاح",
    ),
    "resourceNotFound": MessageLookupByLibrary.simpleMessage(
      "المورد غير موجود.",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("استعادة"),
    "restorePost": MessageLookupByLibrary.simpleMessage("استعادة المنشور"),
    "restorePostConfirmation": MessageLookupByLibrary.simpleMessage(
      "سيتم استعادة هذا المنشور وجعله مرئياً في ملفك الشخصي وتدفقك. هل أنت متأكد من رغبتك في استعادة هذا المنشور؟",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "revenue": MessageLookupByLibrary.simpleMessage("الإيرادات"),
    "rightBack": MessageLookupByLibrary.simpleMessage("ظهير أيمن"),
    "rightWing": MessageLookupByLibrary.simpleMessage("جناح أيمن"),
    "save": MessageLookupByLibrary.simpleMessage("حفظ"),
    "save_achievement_button": MessageLookupByLibrary.simpleMessage(
      "حفظ الإنجاز",
    ),
    "savingChanges": MessageLookupByLibrary.simpleMessage(
      "جاري حفظ التغييرات...",
    ),
    "scout": MessageLookupByLibrary.simpleMessage("مستكشف مواهب"),
    "search": MessageLookupByLibrary.simpleMessage("أبحث"),
    "searchResults": MessageLookupByLibrary.simpleMessage("نتائج البحث"),
    "secondsAgo": m21,
    "seeOriginal": MessageLookupByLibrary.simpleMessage("رؤية النص الأصلي"),
    "select": MessageLookupByLibrary.simpleMessage("اختر"),
    "selectEndDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ الانتهاء",
    ),
    "selectField": m22,
    "selectLanguage": MessageLookupByLibrary.simpleMessage("اختر اللغة"),
    "selectSport": MessageLookupByLibrary.simpleMessage("اختر الرياضة"),
    "selectSports": MessageLookupByLibrary.simpleMessage("اختر الرياضة"),
    "select_date_hint": MessageLookupByLibrary.simpleMessage("اختر التاريخ"),
    "select_sport_error": MessageLookupByLibrary.simpleMessage(
      "الرجاء اختيار رياضة",
    ),
    "sendVerificationCode": MessageLookupByLibrary.simpleMessage(
      "إرسال رمز التحقق",
    ),
    "september": MessageLookupByLibrary.simpleMessage("سبتمبر"),
    "serverError": MessageLookupByLibrary.simpleMessage(
      "خطأ في الخادم. يرجى المحاولة لاحقًا.",
    ),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage(
      "الخدمة غير متاحة مؤقتاً",
    ),
    "setter": MessageLookupByLibrary.simpleMessage("موزع (Setter)"),
    "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "sharingInfoBody": MessageLookupByLibrary.simpleMessage(
      "نحن لا نشارك بياناتك الشخصية مع أطراف ثالثة إلا في الحالات التالية:\n\n• الامتثال للالتزامات القانونية أو الطلبات الرسمية.\n• لتقديم الخدمات من خلال شركاء موثوقين (مثل خدمات التحليلات أو الإشعارات).",
    ),
    "sharingInfoTitle": MessageLookupByLibrary.simpleMessage("مشاركة معلوماتك"),
    "shootingGuard": MessageLookupByLibrary.simpleMessage(
      "مدافع مسدد (Shooting Guard)",
    ),
    "showAll": MessageLookupByLibrary.simpleMessage("عرض الكل"),
    "showApplicants": MessageLookupByLibrary.simpleMessage("عرض المتقدمين"),
    "showDescription": MessageLookupByLibrary.simpleMessage("عرض الوصف"),
    "showMore": MessageLookupByLibrary.simpleMessage("عرض المزيد"),
    "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "signingIn": MessageLookupByLibrary.simpleMessage("جارٍ تسجيل الدخول..."),
    "since": MessageLookupByLibrary.simpleMessage("منذ"),
    "skills": MessageLookupByLibrary.simpleMessage("المهارات"),
    "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
    "smallForward": MessageLookupByLibrary.simpleMessage(
      "مهاجم صغير (Small Forward)",
    ),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. يرجى المحاولة مرة أخرى.",
    ),
    "specialCharacterValidation": MessageLookupByLibrary.simpleMessage(
      "على الأقل رمز خاص واحد",
    ),
    "specializedSport": MessageLookupByLibrary.simpleMessage(
      "الرياضة المتخصصة",
    ),
    "sport": MessageLookupByLibrary.simpleMessage("الرياضة"),
    "sportProfession": MessageLookupByLibrary.simpleMessage("المهنة الرياضية"),
    "startSearching": MessageLookupByLibrary.simpleMessage("ابدأ البحث"),
    "strongPassword": MessageLookupByLibrary.simpleMessage(
      "أدخل كلمة مرور قوية تحتوي على 8 أحرف على الأقل، حرف كبير واحد، حرف صغير واحد، رقم واحد، وحرف خاص واحد.",
    ),
    "subscription": MessageLookupByLibrary.simpleMessage("الاشتراك"),
    "sudan": MessageLookupByLibrary.simpleMessage("السودان"),
    "switchAccount": MessageLookupByLibrary.simpleMessage("تبديل الحساب"),
    "taekwondo": MessageLookupByLibrary.simpleMessage("التايكوندو"),
    "tapToAddFirstLesson": MessageLookupByLibrary.simpleMessage(
      "اضغط على زر + لإضافة أول درس لك",
    ),
    "tapToChange": MessageLookupByLibrary.simpleMessage("اضغط للاختيار"),
    "tapToSelectFromGallery": MessageLookupByLibrary.simpleMessage(
      "اضغط للاختيار من المعرض",
    ),
    "teakwando": MessageLookupByLibrary.simpleMessage("تايكوندو"),
    "teakwandoPlayer": MessageLookupByLibrary.simpleMessage("لاعب تايكوندو"),
    "theme": MessageLookupByLibrary.simpleMessage("الوضع الفاتح"),
    "timeSpent": MessageLookupByLibrary.simpleMessage("الوقت المستغرق"),
    "title": MessageLookupByLibrary.simpleMessage("العنوان"),
    "titleCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "العنوان لا يمكن أن يكون فارغاً",
    ),
    "titleRequired": MessageLookupByLibrary.simpleMessage("العنوان مطلوب"),
    "title_hint": MessageLookupByLibrary.simpleMessage("مثال: البطولة الوطنية"),
    "title_label": MessageLookupByLibrary.simpleMessage("العنوان"),
    "tokenEX": MessageLookupByLibrary.simpleMessage(
      "انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى",
    ),
    "totalEnrolled": MessageLookupByLibrary.simpleMessage("إجمالي المشتركين"),
    "translate": MessageLookupByLibrary.simpleMessage("ترجمة"),
    "tryAdjustingSearch": MessageLookupByLibrary.simpleMessage(
      "حاول تعديل البحث أو التصفية",
    ),
    "tryDifferentSearch": MessageLookupByLibrary.simpleMessage("جرب بحث أخر"),
    "tunisia": MessageLookupByLibrary.simpleMessage("تونس"),
    "unauthorized": MessageLookupByLibrary.simpleMessage(
      "غير مصرح لك. يرجى التحقق من بيانات الاعتماد الخاصة بك.",
    ),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ غير متوقع.",
    ),
    "unfollowSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إلغاء المتابعة بنجاح!",
    ),
    "unknownError": MessageLookupByLibrary.simpleMessage("خطأ غير معروف"),
    "update": MessageLookupByLibrary.simpleMessage("تحديث"),
    "updateLesson": MessageLookupByLibrary.simpleMessage("تحديث الدرس"),
    "updatePost": MessageLookupByLibrary.simpleMessage("تحديث المنشور"),
    "update_button": MessageLookupByLibrary.simpleMessage("تحديث"),
    "updatingLesson": MessageLookupByLibrary.simpleMessage(
      "جاري تحديث الدرس...",
    ),
    "updatingPost": MessageLookupByLibrary.simpleMessage("جار تحديث المنشور"),
    "updatingProfile": MessageLookupByLibrary.simpleMessage(
      "جارٍ تحديث الملف الشخصي",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("رفع"),
    "uploadAnImage": MessageLookupByLibrary.simpleMessage("ارفع صورة"),
    "uploadContent": MessageLookupByLibrary.simpleMessage("رفع محتوى"),
    "uploadCourseThumbnail": MessageLookupByLibrary.simpleMessage(
      "رفع صورة مصغرة للدورة",
    ),
    "uploadImageOrVideo": MessageLookupByLibrary.simpleMessage(
      "ارفع صورة أو فيديو",
    ),
    "uploadLesson": MessageLookupByLibrary.simpleMessage("رفع الدرس"),
    "uploadVideo": MessageLookupByLibrary.simpleMessage("رفع الفيديو"),
    "uploadWillContinue": MessageLookupByLibrary.simpleMessage(
      "سيستمر الرفع في الخلفية",
    ),
    "upload_photo_hint": MessageLookupByLibrary.simpleMessage(
      "رفع صورة الإنجاز",
    ),
    "uploadingInBackground": MessageLookupByLibrary.simpleMessage(
      "جاري رفع الدرس في الخلفية...",
    ),
    "uppercaseValidation": MessageLookupByLibrary.simpleMessage(
      "على الأقل حرف كبير واحد",
    ),
    "useInfoBody": MessageLookupByLibrary.simpleMessage(
      "نستخدم البيانات التي نجمعها من أجل:\n\n• تخصيص تجربتك داخل التطبيق.\n• تحسين ميزاتنا وخدماتنا.\n• إرسال إشعارات ذات صلة بالأنشطة أو الفرص.\n• ضمان أمان ونزاهة منصتنا.",
    ),
    "useInfoTitle": MessageLookupByLibrary.simpleMessage(
      "كيفية استخدام معلوماتك",
    ),
    "userNotFound": MessageLookupByLibrary.simpleMessage("المستخدم غير موجود"),
    "userType": MessageLookupByLibrary.simpleMessage("نوع المستخدم"),
    "validEmail": MessageLookupByLibrary.simpleMessage(
      "أدخل بريدًا إلكترونيًا صالحًا",
    ),
    "validationError": MessageLookupByLibrary.simpleMessage(
      "خطأ في التحقق. يرجى التحقق من المدخلات.",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("تحقق"),
    "video": MessageLookupByLibrary.simpleMessage("الفيديو"),
    "videoPlaybackError": MessageLookupByLibrary.simpleMessage(
      "خطأ في تشغيل الفيديو",
    ),
    "volleyball": MessageLookupByLibrary.simpleMessage("كرة الطائرة"),
    "volleyballer": MessageLookupByLibrary.simpleMessage("لاعب كرة الطائرة"),
    "wantsToConnect": MessageLookupByLibrary.simpleMessage("يريد الاتصال بك"),
    "watched": MessageLookupByLibrary.simpleMessage("تمت المشاهدة"),
    "weeklyBreakdown": MessageLookupByLibrary.simpleMessage("تفاصيل الأسبوع"),
    "weeklyDetails": MessageLookupByLibrary.simpleMessage("التفاصيل الأسبوعية"),
    "weeksAgo": m23,
    "weight": MessageLookupByLibrary.simpleMessage("الوزن (كجم)"),
    "welcome": MessageLookupByLibrary.simpleMessage("مرحبًا"),
    "whatIsYourType": MessageLookupByLibrary.simpleMessage("ما هو نوعك؟"),
    "year": MessageLookupByLibrary.simpleMessage("السنة"),
    "yearsAgo": m24,
    "yearsOfExperience": MessageLookupByLibrary.simpleMessage("سنوات الخبرة"),
    "yearsOfExperience0to2": MessageLookupByLibrary.simpleMessage("0-2 سنوات"),
    "yearsOfExperience10Plus": MessageLookupByLibrary.simpleMessage(
      "أكثر من 10 سنوات",
    ),
    "yearsOfExperience3to5": MessageLookupByLibrary.simpleMessage("3-5 سنوات"),
    "yearsOfExperience5to10": MessageLookupByLibrary.simpleMessage(
      "6-10 سنوات",
    ),
  };
}

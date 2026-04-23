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

  static String m0(type) =>
      "تقرير ${type} الخاص بك جاهز. جده في ملفك الشخصي ضمن قسم تحليل الفيديو.";

  static String m1(message) => "فشل التحليل: ${message}";

  static String m2(type) =>
      "يتم معالجة فيديو ${type} الخاص بك بواسطة محرك الذكاء الاصطناعي. قد يستغرق هذا بضع دقائق.";

  static String m3(type) => "تحليل ${type} جاهز! تحقق من ملفك الشخصي.";

  static String m4(type) => "تحليل ${type}";

  static String m5(action) => "هل أنت متأكد من ${action} هذه الفرصة؟";

  static String m6(percentage) => "اكتمل ${percentage}%";

  static String m7(count) =>
      "${Intl.plural(count, one: 'منذ يوم', two: 'منذ يومين', few: 'منذ ${count} أيام', many: 'منذ ${count} يومًا', other: 'منذ ${count} يوم')}";

  static String m8(lessonTitle) =>
      "هل أنت متأكد من حذف \"${lessonTitle}\"؟ لا يمكن التراجع عن هذا الإجراء.";

  static String m9(duration) => "المدة: ${duration}";

  static String m10(price) => "اشترك مقابل ${price}";

  static String m11(count) => "${count} مشترك";

  static String m12(field) => "يرجى إدخال ${field}";

  static String m13(price) => "التكلفة التقديرية: ${price} جنيه";

  static String m14(type) => "مثال: تمرين ${type}";

  static String m15(field) => "يجب أن يحتوي ${field} على حرفين على الأقل";

  static String m16(count) =>
      "${Intl.plural(count, one: 'منذ ساعة', two: 'منذ ساعتين', few: 'منذ ${count} ساعات', many: 'منذ ${count} ساعة', other: 'منذ ${count} ساعة')}";

  static String m17(field) => "${field} غير صالح";

  static String m18(number) => "${number} درس";

  static String m19(order) => "ترتيب الدرس: ${order}";

  static String m20(order, duration) =>
      "ترتيب الدرس: ${order} • المدة: ${duration}";

  static String m21(count) => "${count} دروس";

  static String m22(completed, total) => "${completed} / ${total} دروس";

  static String m23(count) =>
      "${Intl.plural(count, one: 'منذ دقيقة', two: 'منذ دقيقتين', few: 'منذ ${count} دقائق', many: 'منذ ${count} دقيقة', other: 'منذ ${count} دقيقة')}";

  static String m24(count) =>
      "${Intl.plural(count, one: 'منذ شهر', two: 'منذ شهرين', few: 'منذ ${count} أشهر', many: 'منذ ${count} شهرًا', other: 'منذ ${count} شهر')}";

  static String m25(count) => "${count} جديد";

  static String m26(searchTerm) => "لا توجد دورات لـ \"${searchTerm}\"";

  static String m27(month) => "لا توجد بيانات متاحة لشهر ${month}";

  static String m28(id) => "رقم العملية: ${id}";

  static String m29(percentage) => "اكتمل ${percentage}%";

  static String m30(value) => "${value}%";

  static String m31(percentage) => "تمت مشاهدة ${percentage}%";

  static String m32(price) => "${price} جنيه";

  static String m33(price) => "(${price} جنيه في اليوم)";

  static String m34(count) =>
      "${Intl.plural(count, one: 'منذ ثانية', two: 'منذ ثانيتين', few: 'منذ ${count} ثوانٍ', many: 'منذ ${count} ثانية', other: 'منذ ${count} ثانية')}";

  static String m35(field) => "يرجى اختيار ${field}";

  static String m36(date) => "منذ ${date}";

  static String m37(count) => "${count} إعلان / شهر";

  static String m38(count) => "${count} يوم";

  static String m39(count) => "${count} شهر";

  static String m40(count) => "${count} فيديو / شهر";

  static String m41(count) => "${count} ي";

  static String m42(count) => "${count} س";

  static String m43(count) => "${count} د";

  static String m44(name) => "${name} يكتب...";

  static String m45(error) => "خطأ في الرفع: ${error}";

  static String m46(name) => "تحليلات ${name}";

  static String m47(count) =>
      "${Intl.plural(count, one: 'منذ أسبوع', two: 'منذ أسبوعين', few: 'منذ ${count} أسابيع', many: 'منذ ${count} أسبوعًا', other: 'منذ ${count} أسبوع')}";

  static String m48(count) =>
      "${Intl.plural(count, one: 'منذ سنة', two: 'منذ سنتين', few: 'منذ ${count} سنوات', many: 'منذ ${count} سنة', other: 'منذ ${count} سنة')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "GetYourCode": MessageLookupByLibrary.simpleMessage(
      "احصل على الرمز الخاص بك!",
    ),
    "PreferredClubExperience": MessageLookupByLibrary.simpleMessage(
      "خبرة في نادي سابق",
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
    "actionUrlOptional": MessageLookupByLibrary.simpleMessage(
      "رابط الإجراء (اختياري)",
    ),
    "activate": MessageLookupByLibrary.simpleMessage("تفعيل"),
    "activateAd": MessageLookupByLibrary.simpleMessage("تنشيط الإعلان"),
    "activateAdMessage": MessageLookupByLibrary.simpleMessage(
      "سيظهر هذا الإعلان في الخلاصة مرة أخرى.",
    ),
    "active": MessageLookupByLibrary.simpleMessage("نشط"),
    "activeChats": MessageLookupByLibrary.simpleMessage("المحادثات النشطة"),
    "activities": MessageLookupByLibrary.simpleMessage("الأنشطة"),
    "adActivated": MessageLookupByLibrary.simpleMessage("تم تنشيط الإعلان"),
    "adCreatedPendingPayment": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء الإعلان — في انتظار الدفع",
    ),
    "adDashboard": MessageLookupByLibrary.simpleMessage("لوحة تحكم الإعلانات"),
    "adDeactivated": MessageLookupByLibrary.simpleMessage(
      "تم إلغاء تنشيط الإعلان",
    ),
    "adDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم حذف الإعلان بنجاح",
    ),
    "adPublished": MessageLookupByLibrary.simpleMessage("تم نشر الإعلان!"),
    "adPublishedDescription": MessageLookupByLibrary.simpleMessage(
      "إعلانك أصبح نشطاً الآن وسيظهر في الخلاصة لجمهورك المستهدف.",
    ),
    "adSavedAsDraft": MessageLookupByLibrary.simpleMessage(
      "تم حفظ الإعلان كمسودة — لم ينشر",
    ),
    "adSavedCompletePayment": MessageLookupByLibrary.simpleMessage(
      "تم حفظ إعلانك. أكمل الدفع لتفعيله في الخلاصة.",
    ),
    "adUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الإعلان بنجاح",
    ),
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
    "additionalNotes": MessageLookupByLibrary.simpleMessage("ملاحظات إضافية"),
    "ads": MessageLookupByLibrary.simpleMessage("إعلانات"),
    "advertisement": MessageLookupByLibrary.simpleMessage("إعلان"),
    "advertisements": MessageLookupByLibrary.simpleMessage("إعلانات"),
    "age": MessageLookupByLibrary.simpleMessage("العمر"),
    "ageRange": MessageLookupByLibrary.simpleMessage("الفئة العمرية"),
    "agreeLabel": MessageLookupByLibrary.simpleMessage("أوافق"),
    "aiAssistantSubtitle": MessageLookupByLibrary.simpleMessage(
      "باستخدام هذا البرنامج يمكنك طرح الأسئلة والحصول على مقالات باستخدام مساعد الذكاء الاصطناعي.",
    ),
    "aiAssistantTitle": MessageLookupByLibrary.simpleMessage("مساعدك الذكي"),
    "aiEnhancedAnalysis": MessageLookupByLibrary.simpleMessage(
      "تحليل محسن بالذكاء الاصطناعي",
    ),
    "all": MessageLookupByLibrary.simpleMessage("الكل"),
    "allCaughtUp": MessageLookupByLibrary.simpleMessage(
      "لقد اطلعت على كل شيء!",
    ),
    "allTimeRevenue": MessageLookupByLibrary.simpleMessage("إجمالي الإيرادات"),
    "alreadyApplied": MessageLookupByLibrary.simpleMessage("تم التقديم بالفعل"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "لديك حساب بالفعل؟",
    ),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "لديك حساب بالفعل؟",
    ),
    "analysisCompleteMessage": m0,
    "analysisCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "اكتمل التحليل!",
    ),
    "analysisDeleted": MessageLookupByLibrary.simpleMessage("تم حذف التحليل"),
    "analysisFailedToast": m1,
    "analysisInProgressMessage": m2,
    "analysisInProgressTitle": MessageLookupByLibrary.simpleMessage(
      "التحليل قيد التقدم",
    ),
    "analysisNotificationHint": MessageLookupByLibrary.simpleMessage(
      "ستظهر إشعارات هنا عندما يصبح التقرير جاهزاً.",
    ),
    "analysisNotificationInfo": MessageLookupByLibrary.simpleMessage(
      "سترى إشعاراً هنا عندما يصبح تقريرك جاهزاً — لا داعي للانتظار على هذه الشاشة.",
    ),
    "analysisPendingPayment": MessageLookupByLibrary.simpleMessage(
      "التحليل في انتظار الدفع",
    ),
    "analysisReadyToast": m3,
    "analysisSavedCompletePayment": MessageLookupByLibrary.simpleMessage(
      "تم حفظ الفيديو الخاص بك. أكمل الدفع لتشغيل تحليل الذكاء الاصطناعي.",
    ),
    "analysisStartFailedToast": MessageLookupByLibrary.simpleMessage(
      "تم إضافة التحليل إلى قائمة الانتظار. سيتم عرض التقرير في ملفك الشخصي عندما يكون جاهزًا.",
    ),
    "analysisStartedToast": MessageLookupByLibrary.simpleMessage(
      "تم بدء التحليل! سيكون تقريرك جاهزًا قريبًا.",
    ),
    "analysisTypeSubtitle": MessageLookupByLibrary.simpleMessage(
      "اختر الفئة التي تناسب تمرينك التدريبي.",
    ),
    "analysisTypeTitle": m4,
    "analyticsOverview": MessageLookupByLibrary.simpleMessage(
      "نظرة عامة تحليلية",
    ),
    "analyzeVideo": MessageLookupByLibrary.simpleMessage("تحليل الفيديو"),
    "analyzeVideoComingSoon": MessageLookupByLibrary.simpleMessage(
      "ميزة تحليل الفيديو قريباً",
    ),
    "analyzed": MessageLookupByLibrary.simpleMessage("محلل"),
    "analyzedPeople": MessageLookupByLibrary.simpleMessage("الأشخاص المحللون"),
    "analyzedPlayers": MessageLookupByLibrary.simpleMessage(
      "اللاعبين الذين تم تحليلهم",
    ),
    "analyzedVideo": MessageLookupByLibrary.simpleMessage("فيديو محلل"),
    "analyzedVideoLocked": MessageLookupByLibrary.simpleMessage(
      "الفيديو المحلل (مغلق)",
    ),
    "analyzedVideoReport": MessageLookupByLibrary.simpleMessage(
      "تقرير الفيديو المحلل",
    ),
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
    "archiveOpportunity": MessageLookupByLibrary.simpleMessage("أرشفة الفرصة"),
    "archivePost": MessageLookupByLibrary.simpleMessage("أرشفة المنشور"),
    "archivePostConfirmation": MessageLookupByLibrary.simpleMessage(
      "سيتم أرشفة هذا المنشور وإخفائه من ملفك الشخصي وتدفقك، لكن يمكنك استعادته لاحقاً. هل أنت متأكد من رغبتك في أرشفة هذا المنشور؟",
    ),
    "archivePosts": MessageLookupByLibrary.simpleMessage("المنشورات المؤرشفة"),
    "archiveRestoreConfirmation": m5,
    "august": MessageLookupByLibrary.simpleMessage("أغسطس"),
    "available": MessageLookupByLibrary.simpleMessage("متاح"),
    "availableCourses": MessageLookupByLibrary.simpleMessage("الدورات المتاحة"),
    "average": MessageLookupByLibrary.simpleMessage("متوسط"),
    "averageCompletionRate": MessageLookupByLibrary.simpleMessage(
      "متوسط نسبة الإكمال",
    ),
    "avgBallDistance": MessageLookupByLibrary.simpleMessage(
      "متوسط مسافة الكرة",
    ),
    "avgBallSpeed": MessageLookupByLibrary.simpleMessage("متوسط سرعة الكرة"),
    "avgKneeAngle": MessageLookupByLibrary.simpleMessage("متوسط زاوية الركبة"),
    "avgPlayerSpeed": MessageLookupByLibrary.simpleMessage("متوسط سرعة اللاعب"),
    "avgProgress": MessageLookupByLibrary.simpleMessage("متوسط التقدم"),
    "back": MessageLookupByLibrary.simpleMessage("رجوع"),
    "backToHome": MessageLookupByLibrary.simpleMessage("العودة للرئيسية"),
    "backToHomeButton": MessageLookupByLibrary.simpleMessage(
      "العودة إلى الرئيسية",
    ),
    "backwardPasses": MessageLookupByLibrary.simpleMessage("تمريرات\nللخلف"),
    "badRequest": MessageLookupByLibrary.simpleMessage("طلب غير صالح"),
    "ballTouches": MessageLookupByLibrary.simpleMessage("لمسات الكرة"),
    "basketball": MessageLookupByLibrary.simpleMessage("كرة السلة"),
    "basketballer": MessageLookupByLibrary.simpleMessage("لاعب كرة السلة"),
    "beTheFirstToCreatePost": MessageLookupByLibrary.simpleMessage(
      "كن أول من ينشر منشوراً!",
    ),
    "bio": MessageLookupByLibrary.simpleMessage("الوصف"),
    "botMessage": MessageLookupByLibrary.simpleMessage("رسالة البوت"),
    "campaignDurationRequired": MessageLookupByLibrary.simpleMessage(
      "مدة الحملة *",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cancelEdit": MessageLookupByLibrary.simpleMessage("إلغاء التعديل"),
    "categoryOpportunities": MessageLookupByLibrary.simpleMessage("الفرص"),
    "categoryReactions": MessageLookupByLibrary.simpleMessage("التفاعلات"),
    "categoryRecent": MessageLookupByLibrary.simpleMessage("الأحدث"),
    "categoryRequests": MessageLookupByLibrary.simpleMessage("الطلبات"),
    "certifications": MessageLookupByLibrary.simpleMessage("شهادات"),
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
    "chooseAnalysisType": MessageLookupByLibrary.simpleMessage(
      "اختر نوع التحليل",
    ),
    "chooseFromGallery": MessageLookupByLibrary.simpleMessage("اختر من المعرض"),
    "chooseMethod": MessageLookupByLibrary.simpleMessage("اختر طريقة للدفع"),
    "clear": MessageLookupByLibrary.simpleMessage("مسح"),
    "clearFilters": MessageLookupByLibrary.simpleMessage("مسح الفلاتر"),
    "clicks": MessageLookupByLibrary.simpleMessage("نقرات"),
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
    "completePayment": MessageLookupByLibrary.simpleMessage("إتمام الدفع"),
    "completePaymentToActivate": MessageLookupByLibrary.simpleMessage(
      "أكمل الدفع لتفعيل هذا الإعلان في الخلاصة.",
    ),
    "completePaymentToUnlock": MessageLookupByLibrary.simpleMessage(
      "أكمل الدفع لفتح تقرير الذكاء الاصطناعي الكامل والفيديو المحلل.",
    ),
    "completePaymentToViewAnalyzedVideo": MessageLookupByLibrary.simpleMessage(
      "أكمل الدفع لعرض\nالفيديو المحلل",
    ),
    "completePercentage": m6,
    "completed": MessageLookupByLibrary.simpleMessage("مكتمل"),
    "completion": MessageLookupByLibrary.simpleMessage("الإكمال"),
    "coneHits": MessageLookupByLibrary.simpleMessage("إصابات المخروط"),
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
    "connectionFailed": MessageLookupByLibrary.simpleMessage(
      "فشل الاتصال. اضغط للمحاولة مجدداً",
    ),
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
    "contacts": MessageLookupByLibrary.simpleMessage("جهات الاتصال"),
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
    "createGroup": MessageLookupByLibrary.simpleMessage("إنشاء مجموعة"),
    "createOpportunity": MessageLookupByLibrary.simpleMessage("إنشاء فرصة"),
    "createPost": MessageLookupByLibrary.simpleMessage("إنشاء منشور"),
    "createYourAccount": MessageLookupByLibrary.simpleMessage("أنشئ حسابك"),
    "ctaButtonTextOptional": MessageLookupByLibrary.simpleMessage(
      "نص زر الإجراء (اختياري)",
    ),
    "ctaPlaceholder": MessageLookupByLibrary.simpleMessage(
      "مثال: اعرف المزيد, اشتر الآن",
    ),
    "currentVideo": MessageLookupByLibrary.simpleMessage("الفيديو الحالي"),
    "currentlyInClub": MessageLookupByLibrary.simpleMessage("حاليًا في نادٍ"),
    "dashboard": MessageLookupByLibrary.simpleMessage("لوحة التحكم"),
    "date": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "dateToday": MessageLookupByLibrary.simpleMessage("اليوم"),
    "dateYesterday": MessageLookupByLibrary.simpleMessage("أمس"),
    "date_label": MessageLookupByLibrary.simpleMessage("التاريخ"),
    "daysAgo": m7,
    "deactivate": MessageLookupByLibrary.simpleMessage("تعطيل"),
    "deactivateAd": MessageLookupByLibrary.simpleMessage("إلغاء تنشيط الإعلان"),
    "deactivateAdMessage": MessageLookupByLibrary.simpleMessage(
      "لن يظهر هذا الإعلان في الخلاصة بعد الآن.",
    ),
    "december": MessageLookupByLibrary.simpleMessage("ديسمبر"),
    "delete": MessageLookupByLibrary.simpleMessage("حذف"),
    "deleteAdConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من حذف هذا الإعلان؟",
    ),
    "deleteAnalysis": MessageLookupByLibrary.simpleMessage("حذف التحليل"),
    "deleteAnalysisConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من حذف هذا التحليل؟",
    ),
    "deleteChat": MessageLookupByLibrary.simpleMessage("حذف المحادثة"),
    "deleteComment": MessageLookupByLibrary.simpleMessage("حذف التعليق"),
    "deleteCommentConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من حذف هذا التعليق؟",
    ),
    "deleteConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد حذف هذه المحادثة؟",
    ),
    "deleteCourse": MessageLookupByLibrary.simpleMessage("حذف الدورة"),
    "deleteCourseConfirmation": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد من حذف هذه الدورة؟",
    ),
    "deleteFailed": MessageLookupByLibrary.simpleMessage(
      "فشل الحذف. يرجى المحاولة مرة أخرى.",
    ),
    "deleteLesson": MessageLookupByLibrary.simpleMessage("حذف الدرس"),
    "deleteLessonConfirmation": m8,
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
    "descriptionOptional": MessageLookupByLibrary.simpleMessage(
      "الوصف (اختياري)",
    ),
    "descriptionRequired": MessageLookupByLibrary.simpleMessage("الوصف مطلوب"),
    "description_hint": MessageLookupByLibrary.simpleMessage("اشرح إنجازك..."),
    "description_label": MessageLookupByLibrary.simpleMessage("الوصف"),
    "details": MessageLookupByLibrary.simpleMessage("التفاصيل"),
    "disconnectSuccess": MessageLookupByLibrary.simpleMessage(
      "تم قطع الاتصال بنجاح!",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage(
      "غير متصل. اضغط لإعادة الاتصال",
    ),
    "distanceCovered": MessageLookupByLibrary.simpleMessage("المسافة المقطوعة"),
    "done": MessageLookupByLibrary.simpleMessage("تم"),
    "dribbling": MessageLookupByLibrary.simpleMessage("مراوغة"),
    "dribblingAnalysis": MessageLookupByLibrary.simpleMessage("تحليل المراوغة"),
    "dribblingAnalysisDescription": MessageLookupByLibrary.simpleMessage(
      "تحليل مهارات المراوغة والتحكم بالكرة",
    ),
    "dribblingAnalysisLabel": MessageLookupByLibrary.simpleMessage("مراوغة"),
    "dribblingVideoInstructions": MessageLookupByLibrary.simpleMessage(
      "• استخدم حامل ثلاثي القوائم – كاميرا ثابتة، خلفية ثابتة\n• احصل على الجسم بالكامل – زاوية واسعة\n• صوّر من الزاوية الجانبية\n• المسافة بين المخاريط 90 سم\n• كاميرا بعيدة بما يكفي لرؤية نقطة البداية وجميع المخاريط واللاعب\n• فقط اللاعب والكرة والمخاريط في الإطار\n• ضع الكاميرا على بُعد 5–7 أمتار، بارتفاع 1.5 م\n• إضاءة جيدة\n• تجنب الملابس الفضفاضة",
    ),
    "drillDuration": MessageLookupByLibrary.simpleMessage("مدة التمرين"),
    "duration": m9,
    "edit": MessageLookupByLibrary.simpleMessage("تعديل"),
    "editAdvertisement": MessageLookupByLibrary.simpleMessage("تعديل الإعلان"),
    "editCourse": MessageLookupByLibrary.simpleMessage("تعديل الدورة"),
    "editLesson": MessageLookupByLibrary.simpleMessage("تعديل الدرس"),
    "editOpportunity": MessageLookupByLibrary.simpleMessage("تعديل الفرصة"),
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
    "edited": MessageLookupByLibrary.simpleMessage("تم التعديل"),
    "editingComment": MessageLookupByLibrary.simpleMessage(
      "جاري تعديل التعليق",
    ),
    "egp": MessageLookupByLibrary.simpleMessage("جنيه"),
    "elite": MessageLookupByLibrary.simpleMessage("ممتاز"),
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
    "endedChats": MessageLookupByLibrary.simpleMessage("المحادثات المنتهية"),
    "engagement": MessageLookupByLibrary.simpleMessage("التفاعل"),
    "english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
    "enroll": MessageLookupByLibrary.simpleMessage("اشتراك"),
    "enrollForPrice": m10,
    "enrollNow": MessageLookupByLibrary.simpleMessage("اشترك الآن"),
    "enrolled": MessageLookupByLibrary.simpleMessage("تاريخ الاشتراك"),
    "enrolledCount": m11,
    "enrolledCourses": MessageLookupByLibrary.simpleMessage(
      "الدورات المسجل فيها",
    ),
    "enrolledSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم الاشتراك بنجاح",
    ),
    "enrolleesWillAppear": MessageLookupByLibrary.simpleMessage(
      "سيظهر الطلاب المسجلون هنا",
    ),
    "enterAdDescription": MessageLookupByLibrary.simpleMessage(
      "أدخل وصف الإعلان",
    ),
    "enterAdTitle": MessageLookupByLibrary.simpleMessage("أدخل عنوان الإعلان"),
    "enterAdditionalNotes": MessageLookupByLibrary.simpleMessage(
      "أي تفاصيل إضافية...",
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
    "enterField": m12,
    "enterHeight": MessageLookupByLibrary.simpleMessage("يرجى إدخال الطول"),
    "enterLessonTitleHint": MessageLookupByLibrary.simpleMessage(
      "أدخل عنوان الدرس",
    ),
    "enterMinExperience": MessageLookupByLibrary.simpleMessage("مثال: 3"),
    "enterNewName": MessageLookupByLibrary.simpleMessage("أدخل الاسم الجديد"),
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
    "estimatedCost": m13,
    "exampleDrill": m14,
    "exampleFrame": MessageLookupByLibrary.simpleMessage("إطار مثال"),
    "extractingDuration": MessageLookupByLibrary.simpleMessage(
      "جاري استخراج المدة...",
    ),
    "failedToLoadImage": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل الصورة",
    ),
    "failedToLoadPage": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل الصفحة",
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
    "fawry_mobile_appbar_title": MessageLookupByLibrary.simpleMessage(
      "أدخل رقم الهاتف",
    ),
    "fawry_mobile_confirm_btn": MessageLookupByLibrary.simpleMessage(
      "متابعة إلى فوري",
    ),
    "fawry_mobile_hint": MessageLookupByLibrary.simpleMessage(
      "رقم الهاتف (مثال: 010xxxxxxxx)",
    ),
    "fawry_mobile_label": MessageLookupByLibrary.simpleMessage(
      "أدخل رقم هاتف فوري",
    ),
    "fawry_mobile_terms": MessageLookupByLibrary.simpleMessage(
      "بالمتابعة فإنك توافق على الشروط والأحكام",
    ),
    "fawry_mobile_validation_empty": MessageLookupByLibrary.simpleMessage(
      "من فضلك أدخل رقم هاتفك",
    ),
    "fawry_mobile_validation_invalid": MessageLookupByLibrary.simpleMessage(
      "أدخل رقم هاتف مصري صحيح",
    ),
    "fawry_screen_appbar_title": MessageLookupByLibrary.simpleMessage(
      "كود فوري المرجعي",
    ),
    "fawry_screen_copied": MessageLookupByLibrary.simpleMessage(
      "تم نسخ الكود المرجعي",
    ),
    "fawry_screen_copied_btn": MessageLookupByLibrary.simpleMessage(
      "تم النسخ!",
    ),
    "fawry_screen_copied_reminder": MessageLookupByLibrary.simpleMessage(
      "تم نسخ الرمز! اذهب إلى أي منفذ فوري وادفع باستخدام هذا الرمز.",
    ),
    "fawry_screen_copy_btn": MessageLookupByLibrary.simpleMessage("نسخ الكود"),
    "fawry_screen_done_btn": MessageLookupByLibrary.simpleMessage("تم"),
    "fawry_screen_failed_code": MessageLookupByLibrary.simpleMessage(
      "فشل في توليد الكود المرجعي",
    ),
    "fawry_screen_label": MessageLookupByLibrary.simpleMessage(
      "أدخل بيانات الدفع",
    ),
    "fawry_screen_pay_instruction": MessageLookupByLibrary.simpleMessage(
      "ادفع في أي نقطة فوري باستخدام هذا الكود\nخلال 24 ساعة",
    ),
    "fawry_screen_retry": MessageLookupByLibrary.simpleMessage(
      "إعادة المحاولة",
    ),
    "fawry_screen_terms": MessageLookupByLibrary.simpleMessage(
      "بالمتابعة فإنك توافق على الشروط والأحكام",
    ),
    "february": MessageLookupByLibrary.simpleMessage("فبراير"),
    "female": MessageLookupByLibrary.simpleMessage("أنثى"),
    "field": MessageLookupByLibrary.simpleMessage("الحقل"),
    "fieldTooShort": m15,
    "file_size_exceeds_limit": MessageLookupByLibrary.simpleMessage(
      "حجم الملف يتجاوز 500 ميجابايت",
    ),
    "firstName": MessageLookupByLibrary.simpleMessage("الاسم الأول"),
    "follow": MessageLookupByLibrary.simpleMessage("تابع"),
    "followBack": MessageLookupByLibrary.simpleMessage("رد المتابعة"),
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
    "forwardPasses": MessageLookupByLibrary.simpleMessage("تمريرات\nللأمام"),
    "foundDate": MessageLookupByLibrary.simpleMessage("تاريخ التأسيس"),
    "frames": MessageLookupByLibrary.simpleMessage("الإطارات"),
    "free": MessageLookupByLibrary.simpleMessage("مجاني"),
    "freeCourse": MessageLookupByLibrary.simpleMessage("دورة مجانية"),
    "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
    "gender": MessageLookupByLibrary.simpleMessage("الجنس"),
    "getStarted": MessageLookupByLibrary.simpleMessage("ابدأ"),
    "goToProfileButton": MessageLookupByLibrary.simpleMessage(
      "انتقل إلى الملف الشخصي",
    ),
    "goalkeeper": MessageLookupByLibrary.simpleMessage("حارس مرمى"),
    "goalkeeperAnalysis": MessageLookupByLibrary.simpleMessage(
      "تحليل حارس المرمى",
    ),
    "goalkeeperAnalysisDescription": MessageLookupByLibrary.simpleMessage(
      "تحليل أداء حارس المرمى",
    ),
    "goalkeeperAnalysisLabel": MessageLookupByLibrary.simpleMessage(
      "حارس مرمى",
    ),
    "goalkeeperHeight": MessageLookupByLibrary.simpleMessage(
      "طول حارس المرمى (متر)",
    ),
    "goalkeeperVideoInstructions": MessageLookupByLibrary.simpleMessage(
      "• استخدم حامل ثلاثي القوائم – حافظ على ثبات الكاميرا تمامًا\n• احصل على الجسم بالكامل – تأكد من أن زاوية الكاميرا واسعة بما يكفي\n• صوّر من الزاوية الجانبية (كما في المثال)\n• يجب أن يكون اللاعب هو الشخص الوحيد في الإطار، وكرة واحدة فقط مرئية\n• ضع الكاميرا على بُعد 5–7 أمتار، بارتفاع الصدر (1.5 م)\n• تأكد من الإضاءة الجيدة\n• تجنب الملابس الفضفاضة – يجب أن تكون مفاصل الركبة والورك واضحة",
    ),
    "good": MessageLookupByLibrary.simpleMessage("جيد"),
    "gotIt": MessageLookupByLibrary.simpleMessage("فهمت"),
    "groupName": MessageLookupByLibrary.simpleMessage("اسم المجموعة"),
    "guest": MessageLookupByLibrary.simpleMessage("ضيف"),
    "gymnast": MessageLookupByLibrary.simpleMessage("لاعب جمباز"),
    "gymnastics": MessageLookupByLibrary.simpleMessage("الجمباز"),
    "handball": MessageLookupByLibrary.simpleMessage("كرة اليد"),
    "handballPlayer": MessageLookupByLibrary.simpleMessage("لاعب كرة اليد"),
    "happyToSeeYouToday": MessageLookupByLibrary.simpleMessage(
      "سعداء برؤيتك اليوم",
    ),
    "headUpPercent": MessageLookupByLibrary.simpleMessage("نسبة النظر للأعلى"),
    "height": MessageLookupByLibrary.simpleMessage("الطول (سم)"),
    "heightCalibrationInfo": MessageLookupByLibrary.simpleMessage(
      "الطول يستخدم لمعايرة قياسات الامتداد والسرعة.",
    ),
    "heightExample": MessageLookupByLibrary.simpleMessage("مثال: 1.85"),
    "heightRange": MessageLookupByLibrary.simpleMessage("نطاق الطول (سم)"),
    "heightRequired": MessageLookupByLibrary.simpleMessage(
      "الطول مطلوب لتحليل حارس المرمى",
    ),
    "hi": MessageLookupByLibrary.simpleMessage("مرحباً"),
    "hideDescription": MessageLookupByLibrary.simpleMessage("إخفاء الوصف"),
    "hipVariance": MessageLookupByLibrary.simpleMessage("تباين الورك"),
    "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "hoursAgo": m16,
    "inactiveDraft": MessageLookupByLibrary.simpleMessage("غير نشط / مسودة"),
    "inbox": MessageLookupByLibrary.simpleMessage("صندوق الوارد"),
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
    "invalidExperience": MessageLookupByLibrary.simpleMessage(
      "يجب على سنين الخبرة ان لا تتجاوز ال 60 عاماً",
    ),
    "invalidField": m17,
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
    "kneeAngle": MessageLookupByLibrary.simpleMessage("زاوية الركبة"),
    "knowingYourGoal": MessageLookupByLibrary.simpleMessage(
      "معرفة هدفك تساعدنا على تخصيص تجربتك",
    ),
    "kpiAverageBallSpeed": MessageLookupByLibrary.simpleMessage(
      "متوسط سرعة الكرة (كم/ساعة)",
    ),
    "kpiAveragePlayerSpeed": MessageLookupByLibrary.simpleMessage(
      "متوسط سرعة اللاعب (كم/ساعة)",
    ),
    "kpiAvgBallDistance": MessageLookupByLibrary.simpleMessage(
      "متوسط مسافة الكرة (متر)",
    ),
    "kpiAvgPlayerSpeedDribbling": MessageLookupByLibrary.simpleMessage(
      "متوسط سرعة اللاعب (كم/ساعة)",
    ),
    "kpiConePasses": MessageLookupByLibrary.simpleMessage(
      "تمريرات المخروط للأمام/للخلف والإصابات",
    ),
    "kpiDeepestKneeAngle": MessageLookupByLibrary.simpleMessage(
      "أعمق زاوية ركبة (درجة)",
    ),
    "kpiDistanceCovered": MessageLookupByLibrary.simpleMessage(
      "المسافة المقطوعة لكل فريق (كم)",
    ),
    "kpiDrillDuration": MessageLookupByLibrary.simpleMessage(
      "مدة التمرين (ثانية)",
    ),
    "kpiHeadUpPercentage": MessageLookupByLibrary.simpleMessage(
      "نسبة النظر للأعلى",
    ),
    "kpiHipBounceVariance": MessageLookupByLibrary.simpleMessage(
      "تباين ارتداد الورك",
    ),
    "kpiMaxExtension": MessageLookupByLibrary.simpleMessage(
      "أقصى امتداد (متر)",
    ),
    "kpiMaxVelocity": MessageLookupByLibrary.simpleMessage(
      "أقصى سرعة (كم/ساعة)",
    ),
    "kpiReactionTime": MessageLookupByLibrary.simpleMessage(
      "وقت رد الفعل (ثانية)",
    ),
    "kpiRightKneeAngle": MessageLookupByLibrary.simpleMessage(
      "زاوية الركبة اليمنى (درجة)",
    ),
    "kpiTeamPossession": MessageLookupByLibrary.simpleMessage(
      "استحواذ الفريق (%)",
    ),
    "kpiTopSpeedPerTeam": MessageLookupByLibrary.simpleMessage(
      "السرعة القصوى لكل فريق (كم/ساعة)",
    ),
    "kpiTopSprintSpeedOverall": MessageLookupByLibrary.simpleMessage(
      "أقصى سرعة ركض عامة (كم/ساعة)",
    ),
    "kpiTotalBallTouches": MessageLookupByLibrary.simpleMessage(
      "إجمالي لمسات الكرة",
    ),
    "kpiTotalFramesProcessed": MessageLookupByLibrary.simpleMessage(
      "إجمالي الإطارات المعالجة",
    ),
    "kpiTouchesPerSec": MessageLookupByLibrary.simpleMessage(
      "إجمالي لمسات الكرة و اللمسات/ثانية",
    ),
    "lastName": MessageLookupByLibrary.simpleMessage("اسم العائلة"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage(
      "آخر تحديث: 11 أكتوبر 2025",
    ),
    "latestCourses": MessageLookupByLibrary.simpleMessage("أحدث الدورات"),
    "latestPosts": MessageLookupByLibrary.simpleMessage("أحدث المنشورات"),
    "learnMore": MessageLookupByLibrary.simpleMessage("اعرف المزيد"),
    "lessonNumber": m18,
    "lessonOrder": m19,
    "lessonOrderAndDuration": m20,
    "lessonOrderSaved": MessageLookupByLibrary.simpleMessage(
      "تم حفظ ترتيب الدروس",
    ),
    "lessonTitle": MessageLookupByLibrary.simpleMessage("عنوان الدرس"),
    "lessons": MessageLookupByLibrary.simpleMessage("الدروس"),
    "lessonsCount": m21,
    "lessonsProgress": m22,
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
    "markAllAsRead": MessageLookupByLibrary.simpleMessage("تحديد الكل كمقروء"),
    "match": MessageLookupByLibrary.simpleMessage("مباراة"),
    "matchAnalysis": MessageLookupByLibrary.simpleMessage("تحليل المباراة"),
    "matchAnalysisDescription": MessageLookupByLibrary.simpleMessage(
      "تحليل أداء المباراة الكامل",
    ),
    "matchAnalysisLabel": MessageLookupByLibrary.simpleMessage("مباراة"),
    "matchCriteria": MessageLookupByLibrary.simpleMessage("معايير المطابقة"),
    "matchCriteriaSubtitle": MessageLookupByLibrary.simpleMessage(
      "استهداف متقدم لمقدمين محددين (اختياري)",
    ),
    "matchVideoInstructions": MessageLookupByLibrary.simpleMessage(
      "• استخدم حامل ثلاثي القوائم – كاميرا ثابتة، زاوية واسعة\n• صوّر كامل الملعب\n• إضاءة جيدة وأقل قدر من الحركة في الخلفية\n• ارتفاع الكاميرا 1.5 م على الأقل لتجنب العوائق",
    ),
    "maxAge": MessageLookupByLibrary.simpleMessage("الحد الأقصى للعمر"),
    "maxExtension": MessageLookupByLibrary.simpleMessage("أقصى امتداد"),
    "maxFileSize": MessageLookupByLibrary.simpleMessage(
      "الحد الأقصى 500 ميجابايت",
    ),
    "maxHeight": MessageLookupByLibrary.simpleMessage("الحد الأقصى للطول"),
    "maxVelocity": MessageLookupByLibrary.simpleMessage("أقصى سرعة"),
    "maxWeight": MessageLookupByLibrary.simpleMessage("الحد الأقصى للوزن"),
    "maximumFileSize": MessageLookupByLibrary.simpleMessage(
      "الحد الأقصى لحجم الملف 200 ميجابايت",
    ),
    "may": MessageLookupByLibrary.simpleMessage("مايو"),
    "members": MessageLookupByLibrary.simpleMessage("الأعضاء"),
    "messageSent": MessageLookupByLibrary.simpleMessage(
      "تم إرسال الرسالة بنجاح",
    ),
    "messages": MessageLookupByLibrary.simpleMessage("الرسائل"),
    "minAge": MessageLookupByLibrary.simpleMessage("الحد الأدنى للعمر"),
    "minExperienceYears": MessageLookupByLibrary.simpleMessage(
      "الحد الأدنى للخبرة (سنوات)",
    ),
    "minHeight": MessageLookupByLibrary.simpleMessage("الحد الأدنى للطول"),
    "minLengthValidation": MessageLookupByLibrary.simpleMessage(
      "يجب أن تتكون من 8 أحرف على الأقل",
    ),
    "minWeight": MessageLookupByLibrary.simpleMessage("الحد الأدنى للوزن"),
    "minutesAgo": m23,
    "month": MessageLookupByLibrary.simpleMessage("الشهر"),
    "monthsAgo": m24,
    "moreDetails": MessageLookupByLibrary.simpleMessage("المزيد من التفاصيل"),
    "moreInfo": MessageLookupByLibrary.simpleMessage("مزيد من المعلومات"),
    "myAdvertisements": MessageLookupByLibrary.simpleMessage("إعلاناتي"),
    "myAnalysisLibrary": MessageLookupByLibrary.simpleMessage(
      "مكتبة التحليلات الخاصة بي",
    ),
    "myContacts": MessageLookupByLibrary.simpleMessage("جهات اتصالي"),
    "myCourses": MessageLookupByLibrary.simpleMessage("دوراتي"),
    "myOpportunities": MessageLookupByLibrary.simpleMessage("فرصي"),
    "myPosts": MessageLookupByLibrary.simpleMessage("منشوراتي"),
    "name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "nationality": MessageLookupByLibrary.simpleMessage("الجنسية"),
    "needsWork": MessageLookupByLibrary.simpleMessage("يحتاج تحسيناً"),
    "newBadge": m25,
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
    "noActiveAds": MessageLookupByLibrary.simpleMessage("لا توجد إعلانات نشطة"),
    "noActiveOpportunities": MessageLookupByLibrary.simpleMessage(
      "لا توجد فرص نشطة",
    ),
    "noAnalysesFound": MessageLookupByLibrary.simpleMessage("لا توجد تحليلات"),
    "noAnalyzedPlayersYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد لاعبين تم تحليلهم بعد",
    ),
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
    "noChatsYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد محادثات بعد.\nابدأ محادثة جديدة!",
    ),
    "noCommentsYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد تعليقات بعد",
    ),
    "noConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "لا توجد طلبات اتصال",
    ),
    "noContactsAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد جهات اتصال",
    ),
    "noContactsYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد جهات اتصال بعد",
    ),
    "noCourses": MessageLookupByLibrary.simpleMessage("لا توجد دورات"),
    "noCoursesFound": MessageLookupByLibrary.simpleMessage("لا توجد دورات"),
    "noCoursesFoundFor": m26,
    "noData": MessageLookupByLibrary.simpleMessage("لا بيانات"),
    "noDataForMonth": m27,
    "noDescriptionAvailable": MessageLookupByLibrary.simpleMessage(
      "لا يوجد وصف متاح",
    ),
    "noEnrolleesYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد مشتركين بعد",
    ),
    "noFollowersYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد متابعين بعد",
    ),
    "noFollowingYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد متابعة بعد",
    ),
    "noInactiveAds": MessageLookupByLibrary.simpleMessage(
      "لا توجد إعلانات غير نشطة",
    ),
    "noInactiveOpportunities": MessageLookupByLibrary.simpleMessage(
      "لا توجد فرص غير نشطة",
    ),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "لا يوجد اتصال بالإنترنت.",
    ),
    "noLessonsAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد دروس متاحة",
    ),
    "noLikesYet": MessageLookupByLibrary.simpleMessage("لا توجد إعجابات بعد"),
    "noMoreContacts": MessageLookupByLibrary.simpleMessage(
      "لا توجد جهات اتصال أخرى",
    ),
    "noMoreRequests": MessageLookupByLibrary.simpleMessage(
      "لا توجد المزيد من طلبات الاتصال",
    ),
    "noNotificationsYet": MessageLookupByLibrary.simpleMessage(
      "لا توجد إشعارات بعد",
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
    "noTopMatchFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على تطابق",
    ),
    "noUserDataFound": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على بيانات المستخدم",
    ),
    "notDetected": MessageLookupByLibrary.simpleMessage("غير محدد"),
    "notHaveAccount": MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟"),
    "notificationTitle": MessageLookupByLibrary.simpleMessage("الإشعارات"),
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
    "onlineStatus": MessageLookupByLibrary.simpleMessage("● متصل"),
    "oopsSomethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "عذراً! حدث خطأ ما",
    ),
    "opportunityCreatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء الفرصة بنجاح!",
    ),
    "opportunityDeletedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم حذف الفرصة بنجاح",
    ),
    "opportunityDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الفرصة"),
    "opportunityUpdatedSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الفرصة بنجاح",
    ),
    "opportunityUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم تحديث الفرصة بنجاح!",
    ),
    "optional": MessageLookupByLibrary.simpleMessage("اختياري"),
    "orPasteUrlLabel": MessageLookupByLibrary.simpleMessage("أو الصق الرابط"),
    "orPasteVideoUrl": MessageLookupByLibrary.simpleMessage(
      "أو الصق رابط فيديو",
    ),
    "originalFootage": MessageLookupByLibrary.simpleMessage("اللقطات الأصلية"),
    "originalVideo": MessageLookupByLibrary.simpleMessage("الفيديو الأصلي"),
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
    "overviewAllAds": MessageLookupByLibrary.simpleMessage(
      "نظرة عامة — جميع الإعلانات",
    ),
    "passing": MessageLookupByLibrary.simpleMessage("تمرير"),
    "passingAnalysis": MessageLookupByLibrary.simpleMessage("تحليل التمرير"),
    "passingAnalysisDescription": MessageLookupByLibrary.simpleMessage(
      "تحليل دقة التمرير والتقنية",
    ),
    "passingAnalysisLabel": MessageLookupByLibrary.simpleMessage("تمرير"),
    "passingVideoInstructions": MessageLookupByLibrary.simpleMessage(
      "• استخدم حامل ثلاثي القوائم – حافظ على ثبات الكاميرا\n• احصل على الجسم بالكامل – زاوية واسعة\n• صوّر من الزاوية الجانبية\n• اللاعب في أقصى يمين الإطار، والمدرب في أقصى اليسار\n• رؤية واضحة – فقط اللاعب والمدرب والكرة\n• ضع الكاميرا على بُعد 5–7 أمتار، بارتفاع 1.5 م\n• إضاءة جيدة\n• تجنب الملابس الفضفاضة – وضوح مفاصل الركبة والورك",
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
    "pay": MessageLookupByLibrary.simpleMessage("دفع"),
    "payLaterDraft": MessageLookupByLibrary.simpleMessage(
      "ادفع لاحقاً (سيتم حفظ الإعلان كمسودة)",
    ),
    "payNow": MessageLookupByLibrary.simpleMessage("ادفع الآن"),
    "payNowComingSoon": MessageLookupByLibrary.simpleMessage(
      "ادفع الآن (قريباً)",
    ),
    "payNowToUnlock": MessageLookupByLibrary.simpleMessage("ادفع الآن للفتح"),
    "paymentComingSoon": MessageLookupByLibrary.simpleMessage("الدفع قريباً"),
    "paymentIntegrationComingSoon": MessageLookupByLibrary.simpleMessage(
      "تكامل الدفع قريباً. يمكنك الدفع لاحقاً من لوحة تحكم إعلاناتك.",
    ),
    "payment_success_subtitle": MessageLookupByLibrary.simpleMessage(
      "اشتراكك أصبح نشطاً الآن.\nاستمتع بالوصول المميز! ",
    ),
    "payment_success_title": MessageLookupByLibrary.simpleMessage(
      "تمت عملية الدفع بنجاح!",
    ),
    "payment_success_transaction_id": m28,
    "pending": MessageLookupByLibrary.simpleMessage("معلق"),
    "people": MessageLookupByLibrary.simpleMessage("أشخاص"),
    "percentComplete": m29,
    "percentage": m30,
    "percentageWatched": m31,
    "performanceOverview": MessageLookupByLibrary.simpleMessage(
      "نظرة عامة على الأداء",
    ),
    "personalInfo": MessageLookupByLibrary.simpleMessage("المعلومات الشخصية"),
    "pickImage": MessageLookupByLibrary.simpleMessage("اختر صورة"),
    "pickVideo": MessageLookupByLibrary.simpleMessage("اختر فيديو"),
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
    "position": MessageLookupByLibrary.simpleMessage("المركز"),
    "possession": MessageLookupByLibrary.simpleMessage("الاستحواذ"),
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
    "postVideoSourceHint": MessageLookupByLibrary.simpleMessage(
      "سيتم استخدام فيديو المنشور كمصدر.",
    ),
    "posts": MessageLookupByLibrary.simpleMessage("المنشورات"),
    "preparing": MessageLookupByLibrary.simpleMessage("جاري التحضير…"),
    "price": MessageLookupByLibrary.simpleMessage("السعر"),
    "priceEGP": m32,
    "priceEGPtxt": MessageLookupByLibrary.simpleMessage("السعر (جنيه)"),
    "pricePerDay": m33,
    "priceRequired": MessageLookupByLibrary.simpleMessage("السعر مطلوب"),
    "privacyPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "الخصوصية والسياسة",
    ),
    "processing": MessageLookupByLibrary.simpleMessage("جاري المعالجة..."),
    "processing_payment_subtitle": MessageLookupByLibrary.simpleMessage(
      "من فضلك لا تغلق التطبيق",
    ),
    "processing_payment_title": MessageLookupByLibrary.simpleMessage(
      "جارٍ معالجة الدفع...",
    ),
    "profile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
    "profileLoadFailed": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل الملف الشخصي. يرجى المحاولة مرة أخرى.",
    ),
    "progress": MessageLookupByLibrary.simpleMessage("التقدم"),
    "provideVideoUrl": MessageLookupByLibrary.simpleMessage(
      "الرجاء توفير رابط الفيديو",
    ),
    "provideVideoUrlOrUpload": MessageLookupByLibrary.simpleMessage(
      "الرجاء توفير رابط فيديو أو تحميل فيديو.",
    ),
    "publicOpportunities": MessageLookupByLibrary.simpleMessage("فرصي العامة"),
    "publicPosts": MessageLookupByLibrary.simpleMessage("المنشورات العامة"),
    "reactionTime": MessageLookupByLibrary.simpleMessage("وقت رد الفعل"),
    "reactionTimeShort": MessageLookupByLibrary.simpleMessage("وقت رد الفعل"),
    "reconnecting": MessageLookupByLibrary.simpleMessage("جارٍ إعادة الاتصال…"),
    "recordWithCamera": MessageLookupByLibrary.simpleMessage("تصوير بالكاميرا"),
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
    "rename": MessageLookupByLibrary.simpleMessage("إعادة تسمية"),
    "renameChat": MessageLookupByLibrary.simpleMessage("إعادة تسمية المحادثة"),
    "replaceVideo": MessageLookupByLibrary.simpleMessage("استبدال الفيديو"),
    "requestAccepted": MessageLookupByLibrary.simpleMessage("تم قبول الطلب"),
    "requestCancelled": MessageLookupByLibrary.simpleMessage("تم إلغاء الطلب."),
    "requestDeclined": MessageLookupByLibrary.simpleMessage("تم رفض الطلب"),
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
    "restoreOpportunity": MessageLookupByLibrary.simpleMessage(
      "استعادة الفرصة",
    ),
    "restorePost": MessageLookupByLibrary.simpleMessage("استعادة المنشور"),
    "restorePostConfirmation": MessageLookupByLibrary.simpleMessage(
      "سيتم استعادة هذا المنشور وجعله مرئياً في ملفك الشخصي وتدفقك. هل أنت متأكد من رغبتك في استعادة هذا المنشور؟",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "revenue": MessageLookupByLibrary.simpleMessage("الإيرادات"),
    "save": MessageLookupByLibrary.simpleMessage("حفظ"),
    "save_achievement_button": MessageLookupByLibrary.simpleMessage(
      "حفظ الإنجاز",
    ),
    "savingChanges": MessageLookupByLibrary.simpleMessage(
      "جاري حفظ التغييرات...",
    ),
    "sayHello": MessageLookupByLibrary.simpleMessage("قل مرحباً لـ SportsIn! "),
    "scout": MessageLookupByLibrary.simpleMessage("مستكشف مواهب"),
    "search": MessageLookupByLibrary.simpleMessage("أبحث"),
    "searchByPlayerInstruction1": MessageLookupByLibrary.simpleMessage(
      "ابحث عن تحليلات الفيديو العامة",
    ),
    "searchByPlayerInstruction2": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم اللاعب أو عدل حسب نوع التحليل",
    ),
    "searchByPlayerName": MessageLookupByLibrary.simpleMessage(
      "ابحث باسم اللاعب",
    ),
    "searchByUserName": MessageLookupByLibrary.simpleMessage(
      "ابحث باسم المستخدم",
    ),
    "searchChats": MessageLookupByLibrary.simpleMessage("ابحث في المحادثات"),
    "searchResults": MessageLookupByLibrary.simpleMessage("نتائج البحث"),
    "secondsAgo": m34,
    "seeOriginal": MessageLookupByLibrary.simpleMessage("رؤية النص الأصلي"),
    "select": MessageLookupByLibrary.simpleMessage("اختر"),
    "selectAnalysisType": MessageLookupByLibrary.simpleMessage(
      "اختر نوع التحليل",
    ),
    "selectCertifications": MessageLookupByLibrary.simpleMessage(
      "اختر الشهادات",
    ),
    "selectEndDate": MessageLookupByLibrary.simpleMessage(
      "اختر تاريخ الانتهاء",
    ),
    "selectField": m35,
    "selectGender": MessageLookupByLibrary.simpleMessage("اختر الجنس"),
    "selectLanguage": MessageLookupByLibrary.simpleMessage("اختر اللغة"),
    "selectLocation": MessageLookupByLibrary.simpleMessage("اختر الموقع"),
    "selectPosition": MessageLookupByLibrary.simpleMessage("اختر المركز"),
    "selectSpecialization": MessageLookupByLibrary.simpleMessage("اختر التخصص"),
    "selectSport": MessageLookupByLibrary.simpleMessage("اختر الرياضة"),
    "selectSports": MessageLookupByLibrary.simpleMessage("اختر الرياضة"),
    "selectTargetUserType": MessageLookupByLibrary.simpleMessage(
      "اختر لاعب أو مدرب",
    ),
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
    "sessionAvatarLabel": MessageLookupByLibrary.simpleMessage("S"),
    "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "sharingInfoBody": MessageLookupByLibrary.simpleMessage(
      "نحن لا نشارك بياناتك الشخصية مع أطراف ثالثة إلا في الحالات التالية:\n\n• الامتثال للالتزامات القانونية أو الطلبات الرسمية.\n• لتقديم الخدمات من خلال شركاء موثوقين (مثل خدمات التحليلات أو الإشعارات).",
    ),
    "sharingInfoTitle": MessageLookupByLibrary.simpleMessage("مشاركة معلوماتك"),
    "showAll": MessageLookupByLibrary.simpleMessage("عرض الكل"),
    "showApplicants": MessageLookupByLibrary.simpleMessage("عرض المتقدمين"),
    "showDescription": MessageLookupByLibrary.simpleMessage("عرض الوصف"),
    "showMore": MessageLookupByLibrary.simpleMessage("عرض المزيد"),
    "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "signingIn": MessageLookupByLibrary.simpleMessage("جارٍ تسجيل الدخول..."),
    "since": MessageLookupByLibrary.simpleMessage("منذ"),
    "sinceDate": m36,
    "skills": MessageLookupByLibrary.simpleMessage("المهارات"),
    "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. يرجى المحاولة مرة أخرى.",
    ),
    "specialCharacterValidation": MessageLookupByLibrary.simpleMessage(
      "على الأقل رمز خاص واحد",
    ),
    "specialist": MessageLookupByLibrary.simpleMessage("التخصص"),
    "specializedSport": MessageLookupByLibrary.simpleMessage(
      "الرياضة المتخصصة",
    ),
    "sponsor": MessageLookupByLibrary.simpleMessage("راعي"),
    "sport": MessageLookupByLibrary.simpleMessage("الرياضة"),
    "sportProfession": MessageLookupByLibrary.simpleMessage("المهنة الرياضية"),
    "sportsinTitle": MessageLookupByLibrary.simpleMessage("SportsIn"),
    "startAnalysis": MessageLookupByLibrary.simpleMessage("بدء التحليل"),
    "startAnotherChat": MessageLookupByLibrary.simpleMessage(
      "ابدأ محادثة أخرى مع SportsIn",
    ),
    "startDate": MessageLookupByLibrary.simpleMessage("تاريخ البدء"),
    "startSearching": MessageLookupByLibrary.simpleMessage("ابدأ البحث"),
    "stepAiProcessing": MessageLookupByLibrary.simpleMessage(
      "يبدأ محرك الذكاء الاصطناعي في معالجة الفيديو الخاص بك",
    ),
    "stepCompletePayment": MessageLookupByLibrary.simpleMessage(
      "أكمل الدفع باستخدام الطريقة المفضلة لديك",
    ),
    "stepReportNotified": MessageLookupByLibrary.simpleMessage(
      "يظهر التقرير في ملفك الشخصي — سيتم إعلامك",
    ),
    "strongPassword": MessageLookupByLibrary.simpleMessage(
      "أدخل كلمة مرور قوية تحتوي على 8 أحرف على الأقل، حرف كبير واحد، حرف صغير واحد، رقم واحد، وحرف خاص واحد.",
    ),
    "subscription": MessageLookupByLibrary.simpleMessage("الاشتراك"),
    "subscription_btn": MessageLookupByLibrary.simpleMessage("اشترك الآن"),
    "subscription_plan_ads_month": m37,
    "subscription_plan_basic_stats": MessageLookupByLibrary.simpleMessage(
      "إحصائيات أساسية",
    ),
    "subscription_plan_best_value": MessageLookupByLibrary.simpleMessage(
      "الأفضل قيمة",
    ),
    "subscription_plan_current": MessageLookupByLibrary.simpleMessage(
      "الخطة الحالية",
    ),
    "subscription_plan_detailed_reports": MessageLookupByLibrary.simpleMessage(
      "تقارير مفصّلة",
    ),
    "subscription_plan_duration_month": m38,
    "subscription_plan_duration_year": m39,
    "subscription_plan_forever": MessageLookupByLibrary.simpleMessage("للأبد"),
    "subscription_plan_no_ads": MessageLookupByLibrary.simpleMessage(
      "بدون إعلانات",
    ),
    "subscription_plan_no_videos": MessageLookupByLibrary.simpleMessage(
      "بدون فيديوهات",
    ),
    "subscription_plan_per_month": MessageLookupByLibrary.simpleMessage(
      "/ شهر",
    ),
    "subscription_plan_per_year": MessageLookupByLibrary.simpleMessage("/ سنة"),
    "subscription_plan_popular": MessageLookupByLibrary.simpleMessage(
      "الأكثر شيوعاً",
    ),
    "subscription_plan_select": MessageLookupByLibrary.simpleMessage(
      "اختر الآن",
    ),
    "subscription_plan_unlimited_videos": MessageLookupByLibrary.simpleMessage(
      "فيديوهات غير محدودة",
    ),
    "subscription_plan_videos_month": m40,
    "subscription_renewal_note": MessageLookupByLibrary.simpleMessage(
      "هذا اشتراك يتجدد تلقائياً.\nيمكنك الإلغاء في أي وقت من الإعدادات.",
    ),
    "subscription_retry": MessageLookupByLibrary.simpleMessage(
      "إعادة المحاولة",
    ),
    "subscription_subtitle": MessageLookupByLibrary.simpleMessage(
      "طوّر لعبتك وحلّل أداءك بلا حدود",
    ),
    "subscription_title": MessageLookupByLibrary.simpleMessage("الوصول المميز"),
    "supportedFormats": MessageLookupByLibrary.simpleMessage("MP4 · MOV · AVI"),
    "switchAccount": MessageLookupByLibrary.simpleMessage("تبديل الحساب"),
    "taekwondo": MessageLookupByLibrary.simpleMessage("التايكوندو"),
    "tapToAddFirstLesson": MessageLookupByLibrary.simpleMessage(
      "اضغط على زر + لإضافة أول درس لك",
    ),
    "tapToChange": MessageLookupByLibrary.simpleMessage("اضغط للاختيار"),
    "tapToChangeMedia": MessageLookupByLibrary.simpleMessage(
      "اضغط لتغيير الوسائط",
    ),
    "tapToContinue": MessageLookupByLibrary.simpleMessage(
      "اضغط لمتابعة هذه المحادثة...",
    ),
    "tapToSelectFromGallery": MessageLookupByLibrary.simpleMessage(
      "اضغط للاختيار من المعرض",
    ),
    "tapToUploadVideo": MessageLookupByLibrary.simpleMessage("اضغط لرفع فيديو"),
    "targetAudience": MessageLookupByLibrary.simpleMessage("الجمهور المستهدف"),
    "targetGender": MessageLookupByLibrary.simpleMessage("الجنس المستهدف"),
    "targetLocation": MessageLookupByLibrary.simpleMessage("الموقع المستهدف"),
    "targetUserType": MessageLookupByLibrary.simpleMessage(
      "نوع المستخدم المستهدف",
    ),
    "teakwando": MessageLookupByLibrary.simpleMessage("تايكوندو"),
    "teakwandoPlayer": MessageLookupByLibrary.simpleMessage("لاعب تايكوندو"),
    "team1": MessageLookupByLibrary.simpleMessage("الفريق 1"),
    "team2": MessageLookupByLibrary.simpleMessage("الفريق 2"),
    "theme": MessageLookupByLibrary.simpleMessage("الوضع الفاتح"),
    "timeDays": m41,
    "timeHours": m42,
    "timeMinutes": m43,
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
    "topMatch": MessageLookupByLibrary.simpleMessage("أفضل تطابق"),
    "topSpeed": MessageLookupByLibrary.simpleMessage("السرعة القصوى"),
    "topSprintSpeed": MessageLookupByLibrary.simpleMessage("أقصى سرعة ركض"),
    "totalAds": MessageLookupByLibrary.simpleMessage("إجمالي الإعلانات"),
    "totalAmount": MessageLookupByLibrary.simpleMessage("المبلغ الإجمالي"),
    "totalClicks": MessageLookupByLibrary.simpleMessage("إجمالي النقرات"),
    "totalEnrolled": MessageLookupByLibrary.simpleMessage("إجمالي المشتركين"),
    "totalTouches": MessageLookupByLibrary.simpleMessage("إجمالي اللمسات"),
    "totalViews": MessageLookupByLibrary.simpleMessage("إجمالي المشاهدات"),
    "touchesPerSec": MessageLookupByLibrary.simpleMessage("لمسة/ثانية"),
    "translate": MessageLookupByLibrary.simpleMessage("ترجمة"),
    "tryAdjustingSearch": MessageLookupByLibrary.simpleMessage(
      "حاول تعديل البحث أو التصفية",
    ),
    "tryDifferentSearch": MessageLookupByLibrary.simpleMessage("جرب بحث أخر"),
    "typeAMessage": MessageLookupByLibrary.simpleMessage("اكتب رسالة..."),
    "typing": MessageLookupByLibrary.simpleMessage("يكتب..."),
    "typingWithName": m44,
    "unKnown": MessageLookupByLibrary.simpleMessage("غير محدد"),
    "unauthorized": MessageLookupByLibrary.simpleMessage(
      "غير مصرح لك. يرجى التحقق من بيانات الاعتماد الخاصة بك.",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("تراجع"),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ غير متوقع.",
    ),
    "unfollowSuccess": MessageLookupByLibrary.simpleMessage(
      "تم إلغاء المتابعة بنجاح!",
    ),
    "unknownError": MessageLookupByLibrary.simpleMessage("خطأ غير معروف"),
    "unpaid": MessageLookupByLibrary.simpleMessage("غير مدفوع"),
    "update": MessageLookupByLibrary.simpleMessage("تحديث"),
    "updateAd": MessageLookupByLibrary.simpleMessage("تحديث الإعلان"),
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
    "uploadError": m45,
    "uploadFailedPasteManually": MessageLookupByLibrary.simpleMessage(
      "فشل الرفع. الصق رابط الفيديو يدوياً.",
    ),
    "uploadImageOrVideo": MessageLookupByLibrary.simpleMessage(
      "ارفع صورة أو فيديو",
    ),
    "uploadLesson": MessageLookupByLibrary.simpleMessage("رفع الدرس"),
    "uploadOrLinkVideo": MessageLookupByLibrary.simpleMessage(
      "تحميل أو ربط الفيديو",
    ),
    "uploadVideo": MessageLookupByLibrary.simpleMessage("رفع الفيديو"),
    "uploadWillContinue": MessageLookupByLibrary.simpleMessage(
      "سيستمر الرفع في الخلفية",
    ),
    "upload_photo_hint": MessageLookupByLibrary.simpleMessage(
      "رفع صورة الإنجاز",
    ),
    "uploading": MessageLookupByLibrary.simpleMessage("جاري الرفع…"),
    "uploadingInBackground": MessageLookupByLibrary.simpleMessage(
      "جاري رفع الدرس في الخلفية...",
    ),
    "uppercaseValidation": MessageLookupByLibrary.simpleMessage(
      "على الأقل حرف كبير واحد",
    ),
    "urlPlaceholder": MessageLookupByLibrary.simpleMessage("https://..."),
    "useInfoBody": MessageLookupByLibrary.simpleMessage(
      "نستخدم البيانات التي نجمعها من أجل:\n\n• تخصيص تجربتك داخل التطبيق.\n• تحسين ميزاتنا وخدماتنا.\n• إرسال إشعارات ذات صلة بالأنشطة أو الفرص.\n• ضمان أمان ونزاهة منصتنا.",
    ),
    "useInfoTitle": MessageLookupByLibrary.simpleMessage(
      "كيفية استخدام معلوماتك",
    ),
    "userMessage": MessageLookupByLibrary.simpleMessage("رسالة المستخدم"),
    "userNotFound": MessageLookupByLibrary.simpleMessage("المستخدم غير موجود"),
    "userType": MessageLookupByLibrary.simpleMessage("نوع المستخدم"),
    "usersAnalyses": m46,
    "validEmail": MessageLookupByLibrary.simpleMessage(
      "أدخل بريدًا إلكترونيًا صالحًا",
    ),
    "validHeightRange": MessageLookupByLibrary.simpleMessage(
      "أدخل طولاً صالحاً (1.0 – 2.5 م)",
    ),
    "validationError": MessageLookupByLibrary.simpleMessage(
      "خطأ في التحقق. يرجى التحقق من المدخلات.",
    ),
    "verify": MessageLookupByLibrary.simpleMessage("تحقق"),
    "video": MessageLookupByLibrary.simpleMessage("الفيديو"),
    "videoAnalysis": MessageLookupByLibrary.simpleMessage("تحليل الفيديو"),
    "videoFromPost": MessageLookupByLibrary.simpleMessage("فيديو من المنشور"),
    "videoPlaybackError": MessageLookupByLibrary.simpleMessage(
      "خطأ في تشغيل الفيديو",
    ),
    "videoRecordingTips": MessageLookupByLibrary.simpleMessage(
      "نصائح لتسجيل الفيديو",
    ),
    "videoTips": MessageLookupByLibrary.simpleMessage("نصائح الفيديو"),
    "videoUploaded": MessageLookupByLibrary.simpleMessage("تم رفع الفيديو"),
    "videoUrlPlaceholder": MessageLookupByLibrary.simpleMessage(
      "رابط الفيديو (Cloudinary، YouTube، إلخ)",
    ),
    "viewAnalyticsDashboard": MessageLookupByLibrary.simpleMessage(
      "عرض لوحة التحكم التحليلية",
    ),
    "viewReport": MessageLookupByLibrary.simpleMessage("عرض التقرير"),
    "views": MessageLookupByLibrary.simpleMessage("مشاهدات"),
    "vodafone_appbar_title": MessageLookupByLibrary.simpleMessage(
      "أدخل تفاصيل البطاقة",
    ),
    "vodafone_hint": MessageLookupByLibrary.simpleMessage(
      "رقم الهاتف (مثال: 010xxxxxxxx)",
    ),
    "vodafone_label": MessageLookupByLibrary.simpleMessage("أدخل بيانات الدفع"),
    "vodafone_name": MessageLookupByLibrary.simpleMessage("فودافون كاش"),
    "vodafone_send_btn": MessageLookupByLibrary.simpleMessage(
      "إرسال طلب الدفع",
    ),
    "vodafone_terms": MessageLookupByLibrary.simpleMessage(
      "بالمتابعة فإنك توافق على الشروط والأحكام",
    ),
    "vodafone_validation_empty": MessageLookupByLibrary.simpleMessage(
      "من فضلك أدخل رقم هاتفك",
    ),
    "vodafone_validation_invalid": MessageLookupByLibrary.simpleMessage(
      "أدخل رقم هاتف مصري صحيح",
    ),
    "volleyball": MessageLookupByLibrary.simpleMessage("كرة الطائرة"),
    "volleyballer": MessageLookupByLibrary.simpleMessage("لاعب كرة الطائرة"),
    "vs": MessageLookupByLibrary.simpleMessage("ضد"),
    "wantsToConnect": MessageLookupByLibrary.simpleMessage("يريد الاتصال بك"),
    "watched": MessageLookupByLibrary.simpleMessage("تمت المشاهدة"),
    "weeklyBreakdown": MessageLookupByLibrary.simpleMessage("تفاصيل الأسبوع"),
    "weeklyDetails": MessageLookupByLibrary.simpleMessage("التفاصيل الأسبوعية"),
    "weeksAgo": m47,
    "weight": MessageLookupByLibrary.simpleMessage("الوزن (كجم)"),
    "weightRange": MessageLookupByLibrary.simpleMessage("نطاق الوزن (كجم)"),
    "welcome": MessageLookupByLibrary.simpleMessage("مرحبًا"),
    "whatHappensNext": MessageLookupByLibrary.simpleMessage(
      "ماذا يحدث بعد ذلك",
    ),
    "whatIsYourType": MessageLookupByLibrary.simpleMessage("ما هو نوعك؟"),
    "whatToExpect": MessageLookupByLibrary.simpleMessage("ماذا تتوقع"),
    "whatWillBeAnalyzed": MessageLookupByLibrary.simpleMessage(
      "ما الذي سيتم تحليله",
    ),
    "whoShouldSeeThisAd": MessageLookupByLibrary.simpleMessage(
      "من يجب أن يرى هذا الإعلان؟",
    ),
    "writeMessageHint": MessageLookupByLibrary.simpleMessage("اكتب رسالتك"),
    "year": MessageLookupByLibrary.simpleMessage("السنة"),
    "years": MessageLookupByLibrary.simpleMessage("سنوات"),
    "yearsAgo": m48,
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

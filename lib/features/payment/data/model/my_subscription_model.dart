// lib/features/payment/data/models/my_subscription_model.dart

/// Maps to the response of:
/// GET https://sportsin.runasp.net/api/Payments/my-subscription?userId={userId}
///
/// Returns null body / 204 when the user has no active subscription,
/// in which case [MySubscriptionModel.fromJson] will return null and
/// the UI should navigate to the SubscriptionScreen.
///
/// Example JSON (active):
/// ```json
/// {
///   "planName": "Free",
///   "startDate": "0001-01-01T00:00:00",
///   "endDate": "2026-04-08T17:24:29.5228181Z",
///   "isActive": true,
///   "planId": "a1b2c3d4-e5f6-4789-a1b2-c3d4e5f67890",
///   "price": 0,
///   "description": null,
///   "monthlyAdLimit": 0,
///   "monthlyVideoAnalysisLimit": 3,
///   "hasDetailedReports": false,
///   "durationDays": 30
/// }
/// ```
class MySubscriptionModel {
  final String planName;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String planId;
  final double price;
  final String? description;
  final int monthlyAdLimit;
  final int monthlyVideoAnalysisLimit;
  final bool hasDetailedReports;
  final int durationDays;

  const MySubscriptionModel({
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.planId,
    required this.price,
    this.description,
    required this.monthlyAdLimit,
    required this.monthlyVideoAnalysisLimit,
    required this.hasDetailedReports,
    required this.durationDays,
  });

  /// Returns null if [json] is null or empty — caller should show SubscriptionScreen.
  static MySubscriptionModel? fromJsonNullable(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return null;
    return MySubscriptionModel.fromJson(json);
  }

  factory MySubscriptionModel.fromJson(Map<String, dynamic> json) {
    return MySubscriptionModel(
      planName: json['planName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool,
      planId: json['planId'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      monthlyAdLimit: json['monthlyAdLimit'] as int,
      monthlyVideoAnalysisLimit: json['monthlyVideoAnalysisLimit'] as int,
      hasDetailedReports: json['hasDetailedReports'] as bool,
      durationDays: json['durationDays'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'planName': planName,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'isActive': isActive,
        'planId': planId,
        'price': price,
        'description': description,
        'monthlyAdLimit': monthlyAdLimit,
        'monthlyVideoAnalysisLimit': monthlyVideoAnalysisLimit,
        'hasDetailedReports': hasDetailedReports,
        'durationDays': durationDays,
      };

  /// Whether the subscription is currently valid (active + not expired).
  bool get isValid => isActive && endDate.isAfter(DateTime.now());

  bool get isFree => price == 0;

  /// Remaining days until subscription expires.
  int get remainingDays => endDate.difference(DateTime.now()).inDays;

  @override
  String toString() =>
      'MySubscriptionModel(planName: $planName, isActive: $isActive, endDate: $endDate)';
}
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

  bool get isValid => isActive && endDate.isAfter(DateTime.now());

  bool get isFree => price == 0;
  int get remainingDays => endDate.difference(DateTime.now()).inDays;

  @override
  String toString() =>
      'MySubscriptionModel(planName: $planName, isActive: $isActive, endDate: $endDate)';
}
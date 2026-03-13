// lib/features/payment/data/models/subscription_plan_model.dart

/// Maps to one item in the array returned by:
/// GET https://sportsin.runasp.net/api/Payments/plans
///
/// Example JSON:
/// ```json
/// {
///   "id": "a1b2c3d4-e5f6-4789-a1b2-c3d4e5f67890",
///   "name": "Free",
///   "price": 0,
///   "description": null,
///   "monthlyAdLimit": 0,
///   "monthlyVideoAnalysisLimit": 3,
///   "hasDetailedReports": false,
///   "durationDays": 30
/// }
/// ```
class SubscriptionPlanModel {
  final String id;
  final String name;
  final double price;
  final String? description;
  final int monthlyAdLimit;
  final int monthlyVideoAnalysisLimit;
  final bool hasDetailedReports;
  final int durationDays;

  const SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.monthlyAdLimit,
    required this.monthlyVideoAnalysisLimit,
    required this.hasDetailedReports,
    required this.durationDays,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      monthlyAdLimit: json['monthlyAdLimit'] as int,
      monthlyVideoAnalysisLimit: json['monthlyVideoAnalysisLimit'] as int,
      hasDetailedReports: json['hasDetailedReports'] as bool,
      durationDays: json['durationDays'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'description': description,
        'monthlyAdLimit': monthlyAdLimit,
        'monthlyVideoAnalysisLimit': monthlyVideoAnalysisLimit,
        'hasDetailedReports': hasDetailedReports,
        'durationDays': durationDays,
      };

  /// Whether this is the free tier.
  bool get isFree => price == 0;

  @override
  String toString() => 'SubscriptionPlanModel(id: $id, name: $name, price: $price)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionPlanModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
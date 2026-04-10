class CreateAnalysisResponse {
  final String id;
  final String? analyzedVideoUrl;
  final String originalVideoUrl;
  final bool isPaid;
  final bool isDeleted;
  final String? deletedAt;
  final String createdAt;
  final String userId;
  final String createdByUserId;

  // Goalkeeper fields
  final double? reactionTimeSec;
  final double? maxExtensionMeters;
  final double? maxVelocityKmh;
  final double? deepestKneeAngleDeg;
  final double? keeperHeightMeters;

  // Passing fields
  final double? drillDurationSeconds;
  final int? totalBallTouches;
  final double? avgBallSpeedKmh;
  final double? avgPlayerSpeedKmh;
  final double? avgRKneeAngleDeg;

  // Dribbling fields
  final int? totalTouches;
  final double? touchesPerSecond;
  final double? avgBallDistanceMeters;
  final double? headUpPercentage;
  final double? hipBounceVarianceMeters;
  final int? conePassesForward;
  final int? conePassesBackward;
  final int? coneHits;

  // Match fields
  final double? team1Possession;
  final double? team2Possession;
  final double? team1DistanceCoveredKm;
  final double? team1TopSpeedKmh;
  final double? team2DistanceCoveredKm;
  final double? team2TopSpeedKmh;
  final double? topSprintSpeed;
  final int? totalFrames;

  const CreateAnalysisResponse({
    required this.id,
    required this.isPaid,
    required this.isDeleted,
    required this.originalVideoUrl,
    required this.createdAt,
    required this.userId,
    required this.createdByUserId,
    this.analyzedVideoUrl,
    this.deletedAt,
    this.reactionTimeSec,
    this.maxExtensionMeters,
    this.maxVelocityKmh,
    this.deepestKneeAngleDeg,
    this.keeperHeightMeters,
    this.drillDurationSeconds,
    this.totalBallTouches,
    this.avgBallSpeedKmh,
    this.avgPlayerSpeedKmh,
    this.avgRKneeAngleDeg,
    this.totalTouches,
    this.touchesPerSecond,
    this.avgBallDistanceMeters,
    this.headUpPercentage,
    this.hipBounceVarianceMeters,
    this.conePassesForward,
    this.conePassesBackward,
    this.coneHits,
    this.team1Possession,
    this.team2Possession,
    this.team1DistanceCoveredKm,
    this.team1TopSpeedKmh,
    this.team2DistanceCoveredKm,
    this.team2TopSpeedKmh,
    this.topSprintSpeed,
    this.totalFrames,
  });

  bool get requiresPayment =>
      !isPaid &&
      (analyzedVideoUrl == null || analyzedVideoUrl!.isEmpty);

  factory CreateAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return CreateAnalysisResponse(
      id: json['id'] as String,
      analyzedVideoUrl: json['analyzedVideoUrl'] as String?,
      originalVideoUrl: json['originalVideoUrl'] as String? ?? '',
      isPaid: json['isPaid'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      createdByUserId: json['createdByUserId'] as String? ?? '',
      reactionTimeSec: (json['reactionTimeSec'] as num?)?.toDouble(),
      maxExtensionMeters: (json['maxExtensionMeters'] as num?)?.toDouble(),
      maxVelocityKmh: (json['maxVelocityKmh'] as num?)?.toDouble(),
      deepestKneeAngleDeg: (json['deepestKneeAngleDeg'] as num?)?.toDouble(),
      keeperHeightMeters: (json['keeperHeightMeters'] as num?)?.toDouble(),
      drillDurationSeconds: (json['drillDurationSeconds'] as num?)?.toDouble(),
      totalBallTouches: json['totalBallTouches'] as int?,
      avgBallSpeedKmh: (json['avgBallSpeedKmh'] as num?)?.toDouble(),
      avgPlayerSpeedKmh: (json['avgPlayerSpeedKmh'] as num?)?.toDouble(),
      avgRKneeAngleDeg: (json['avgRKneeAngleDeg'] as num?)?.toDouble(),
      totalTouches: json['totalTouches'] as int?,
      touchesPerSecond: (json['touchesPerSecond'] as num?)?.toDouble(),
      avgBallDistanceMeters:
          (json['avgBallDistanceMeters'] as num?)?.toDouble(),
      headUpPercentage: (json['headUpPercentage'] as num?)?.toDouble(),
      hipBounceVarianceMeters:
          (json['hipBounceVarianceMeters'] as num?)?.toDouble(),
      conePassesForward: json['conePassesForward'] as int?,
      conePassesBackward: json['conePassesBackward'] as int?,
      coneHits: json['coneHits'] as int?,
      team1Possession: (json['team1Possession'] as num?)?.toDouble(),
      team2Possession: (json['team2Possession'] as num?)?.toDouble(),
      team1DistanceCoveredKm:
          (json['team1DistanceCoveredKm'] as num?)?.toDouble(),
      team1TopSpeedKmh: (json['team1TopSpeedKmh'] as num?)?.toDouble(),
      team2DistanceCoveredKm:
          (json['team2DistanceCoveredKm'] as num?)?.toDouble(),
      team2TopSpeedKmh: (json['team2TopSpeedKmh'] as num?)?.toDouble(),
      topSprintSpeed: (json['topSprintSpeed'] as num?)?.toDouble(),
      totalFrames: json['totalFrames'] as int?,
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Shared mini-models
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisUserRef {
  final String userId;
  final String fullName;
  final String? profilePicture;

  const AnalysisUserRef({
    required this.userId,
    required this.fullName,
    this.profilePicture,
  });

  factory AnalysisUserRef.fromJson(Map<String, dynamic> json) =>
      AnalysisUserRef(
        userId: json['userId'] as String,
        fullName: json['fullName'] as String,
        profilePicture: json['profilePicture'] as String?,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// /api/Analysis/my-analyzed-users
// ─────────────────────────────────────────────────────────────────────────────

class AnalyzedUserModel {
  final String userId;
  final String fullName;
  final String? profilePictureUrl;

  const AnalyzedUserModel({
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
  });

  factory AnalyzedUserModel.fromJson(Map<String, dynamic> json) =>
      AnalyzedUserModel(
        userId: json['userId'] as String,
        fullName: json['fullName'] as String,
        profilePictureUrl: json['profilePictureUrl'] as String?,
      );
}

class AnalyzedUsersPage {
  final List<AnalyzedUserModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const AnalyzedUsersPage({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory AnalyzedUsersPage.fromJson(Map<String, dynamic> json) =>
      AnalyzedUsersPage(
        items: (json['items'] as List)
            .map((e) => AnalyzedUserModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalCount: (json['totalCount'] as num).toInt(),
        pageNumber: (json['pageNumber'] as num).toInt(),
        pageSize: (json['pageSize'] as num).toInt(),
        totalPages: (json['totalPages'] as num).toInt(),
        hasNextPage: json['hasNextPage'] as bool,
        hasPreviousPage: json['hasPreviousPage'] as bool,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared list-item — used by target-analyses, my-self-analyses, search/*
// ─────────────────────────────────────────────────────────────────────────────

class AnalysisListItemModel {
  final String id;
  final String type; // "Goalkeeper" | "Passing" | "Dribbling" | "Match"
  final String createdAt;
  final String originalVideoUrl;
  final String? analyzedVideoUrl;
  final bool isPaid;
  final AnalysisUserRef player;
  final AnalysisUserRef analyst;

  const AnalysisListItemModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.originalVideoUrl,
    this.analyzedVideoUrl,
    required this.isPaid,
    required this.player,
    required this.analyst,
  });

  factory AnalysisListItemModel.fromJson(Map<String, dynamic> json) =>
      AnalysisListItemModel(
        id: json['id'] as String,
        type: json['type'] as String,
        createdAt: json['createdAt'] as String,
        originalVideoUrl: json['originalVideoUrl'] as String,
        analyzedVideoUrl: json['analyzedVideoUrl'] as String?,
        isPaid: json['isPaid'] as bool,
        player:
            AnalysisUserRef.fromJson(json['player'] as Map<String, dynamic>),
        analyst:
            AnalysisUserRef.fromJson(json['analyst'] as Map<String, dynamic>),
      );
        Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'createdAt': createdAt,
      'originalVideoUrl': originalVideoUrl,
      'analyzedVideoUrl': analyzedVideoUrl,
      'isPaid': isPaid,
      'player': player,
      'analyst': analyst,
    };
  }
}

class AnalysisListPage {
  final List<AnalysisListItemModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const AnalysisListPage({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory AnalysisListPage.fromJson(Map<String, dynamic> json) =>
      AnalysisListPage(
        items: (json['items'] as List)
            .map((e) =>
                AnalysisListItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalCount: (json['totalCount'] as num).toInt(),
        pageNumber: (json['pageNumber'] as num).toInt(),
        pageSize: (json['pageSize'] as num).toInt(),
        totalPages: (json['totalPages'] as num).toInt(),
        hasNextPage: json['hasNextPage'] as bool,
        hasPreviousPage: json['hasPreviousPage'] as bool,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// /api/Analysis/report/{id}  — sealed KPI models per type
// ─────────────────────────────────────────────────────────────────────────────

abstract class AnalysisKpis {
  const AnalysisKpis();
}

class GoalkeeperKpis extends AnalysisKpis {
  final double reactionTimeSec;
  final double maxExtensionMeters;
  final double maxVelocityKmh;
  final double deepestKneeAngleDeg;

  const GoalkeeperKpis({
    required this.reactionTimeSec,
    required this.maxExtensionMeters,
    required this.maxVelocityKmh,
    required this.deepestKneeAngleDeg,
  });

  factory GoalkeeperKpis.fromJson(Map<String, dynamic> j) => GoalkeeperKpis(
        reactionTimeSec: (j['reactionTimeSec'] as num).toDouble(),
        maxExtensionMeters: (j['maxExtensionMeters'] as num).toDouble(),
        maxVelocityKmh: (j['maxVelocityKmh'] as num).toDouble(),
        deepestKneeAngleDeg: (j['deepestKneeAngleDeg'] as num).toDouble(),
      );
}

class PassingKpis extends AnalysisKpis {
  final int drillDurationSeconds;
  final int totalBallTouches;
  final double avgBallSpeedKmh;
  final double avgPlayerSpeedKmh;
  final double avgRKneeAngleDeg;

  const PassingKpis({
    required this.drillDurationSeconds,
    required this.totalBallTouches,
    required this.avgBallSpeedKmh,
    required this.avgPlayerSpeedKmh,
    required this.avgRKneeAngleDeg,
  });

  factory PassingKpis.fromJson(Map<String, dynamic> j) => PassingKpis(
        drillDurationSeconds: (j['drillDurationSeconds'] as num).toInt(),
        totalBallTouches: (j['totalBallTouches'] as num).toInt(),
        avgBallSpeedKmh: (j['avgBallSpeedKmh'] as num).toDouble(),
        avgPlayerSpeedKmh: (j['avgPlayerSpeedKmh'] as num).toDouble(),
        avgRKneeAngleDeg: (j['avgRKneeAngleDeg'] as num).toDouble(),
      );
}

class DribblingKpis extends AnalysisKpis {
  final int drillDurationSeconds;
  final int totalTouches;
  final double touchesPerSecond;
  final double avgPlayerSpeedKmh;
  final double avgBallDistanceMeters;
  final double headUpPercentage;
  final double hipBounceVarianceMeters;
  final int conePassesForward;
  final int conePassesBackward;
  final int coneHits;

  const DribblingKpis({
    required this.drillDurationSeconds,
    required this.totalTouches,
    required this.touchesPerSecond,
    required this.avgPlayerSpeedKmh,
    required this.avgBallDistanceMeters,
    required this.headUpPercentage,
    required this.hipBounceVarianceMeters,
    required this.conePassesForward,
    required this.conePassesBackward,
    required this.coneHits,
  });

  factory DribblingKpis.fromJson(Map<String, dynamic> j) => DribblingKpis(
        drillDurationSeconds: (j['drillDurationSeconds'] as num).toInt(),
        totalTouches: (j['totalTouches'] as num).toInt(),
        touchesPerSecond: (j['touchesPerSecond'] as num).toDouble(),
        avgPlayerSpeedKmh: (j['avgPlayerSpeedKmh'] as num).toDouble(),
        avgBallDistanceMeters: (j['avgBallDistanceMeters'] as num).toDouble(),
        headUpPercentage: (j['headUpPercentage'] as num).toDouble(),
        hipBounceVarianceMeters:
            (j['hipBounceVarianceMeters'] as num).toDouble(),
        conePassesForward: (j['conePassesForward'] as num).toInt(),
        conePassesBackward: (j['conePassesBackward'] as num).toInt(),
        coneHits: (j['coneHits'] as num).toInt(),
      );
}

class MatchKpis extends AnalysisKpis {
  final double team1Possession;
  final double team2Possession;
  final double team1DistanceCoveredKm;
  final double team1TopSpeedKmh;
  final double team2DistanceCoveredKm;
  final double team2TopSpeedKmh;
  final double topSprintSpeed;
  final int totalFrames;

  const MatchKpis({
    required this.team1Possession,
    required this.team2Possession,
    required this.team1DistanceCoveredKm,
    required this.team1TopSpeedKmh,
    required this.team2DistanceCoveredKm,
    required this.team2TopSpeedKmh,
    required this.topSprintSpeed,
    required this.totalFrames,
  });

  factory MatchKpis.fromJson(Map<String, dynamic> j) => MatchKpis(
        team1Possession: (j['team1Possession'] as num).toDouble(),
        team2Possession: (j['team2Possession'] as num).toDouble(),
        team1DistanceCoveredKm: (j['team1DistanceCoveredKm'] as num).toDouble(),
        team1TopSpeedKmh: (j['team1TopSpeedKmh'] as num).toDouble(),
        team2DistanceCoveredKm: (j['team2DistanceCoveredKm'] as num).toDouble(),
        team2TopSpeedKmh: (j['team2TopSpeedKmh'] as num).toDouble(),
        topSprintSpeed: (j['topSprintSpeed'] as num).toDouble(),
        totalFrames: (j['totalFrames'] as num).toInt(),
      );
}

AnalysisKpis _parseKpis(String type, Map<String, dynamic> kpisJson) {
  switch (type) {
    case 'Goalkeeper':
      return GoalkeeperKpis.fromJson(kpisJson);
    case 'Passing':
      return PassingKpis.fromJson(kpisJson);
    case 'Dribbling':
      return DribblingKpis.fromJson(kpisJson);
    case 'Match':
      return MatchKpis.fromJson(kpisJson);
    default:
      throw ArgumentError('Unknown analysis type: $type');
  }
}

class ReportPlayerModel {
  final String firstName;
  final String secondName;
  final String? profilePicture;

  String get fullName => '$firstName $secondName';

  const ReportPlayerModel({
    required this.firstName,
    required this.secondName,
    this.profilePicture,
  });

  factory ReportPlayerModel.fromJson(Map<String, dynamic> json) =>
      ReportPlayerModel(
        firstName: json['firstName'] as String,
        secondName: json['secondName'] as String,
        profilePicture: json['profilePicture'] as String?,
      );
}

class AnalysisReportModel {
  final String id;
  final String type;
  final String createdAt;
  final bool isPaid;
  final String originalVideoUrl;
  final String? analyzedVideoUrl;
  final AnalysisKpis kpis;
  final ReportPlayerModel player;
  final AnalysisUserRef analyst;

  const AnalysisReportModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.isPaid,
    required this.originalVideoUrl,
    this.analyzedVideoUrl,
    required this.kpis,
    required this.player,
    required this.analyst,
  });

  factory AnalysisReportModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    return AnalysisReportModel(
      id: json['id'] as String,
      type: type,
      createdAt: json['createdAt'] as String,
      isPaid: json['isPaid'] as bool,
      originalVideoUrl: json['originalVideoUrl'] as String,
      analyzedVideoUrl: json['analyzedVideoUrl'] as String?,
      kpis: _parseKpis(type, json['kpIs'] as Map<String, dynamic>),
      player: ReportPlayerModel.fromJson(
          json['player'] as Map<String, dynamic>),
      analyst:
          AnalysisUserRef.fromJson(json['analyst'] as Map<String, dynamic>),
    );
  }
}
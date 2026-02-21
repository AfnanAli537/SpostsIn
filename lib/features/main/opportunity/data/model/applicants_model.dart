import 'package:equatable/equatable.dart';

class ApplicantsResponseModel extends Equatable {
  final List<Applicant> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const ApplicantsResponseModel({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ApplicantsResponseModel.fromJson(Map<String, dynamic> json) {
    return ApplicantsResponseModel(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => Applicant.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  @override
  List<Object?> get props => [
        items,
        totalCount,
        pageNumber,
        pageSize,
        totalPages,
        hasNextPage,
        hasPreviousPage,
      ];
}

class Applicant extends Equatable {
  final String applicationId;
  final String applicantId;
  final String applicantName;
  final String? profilePictureUrl;
  final String applicantType;
  final String status;

  const Applicant({
    required this.applicationId,
    required this.applicantId,
    required this.applicantName,
    this.profilePictureUrl,
    required this.applicantType,
    required this.status,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      applicationId: json['applicationId'] ?? '',
      applicantId: json['applicantId'] ?? '',
      applicantName: json['applicantName'] ?? '',
      profilePictureUrl: json['profilePictureUrl'],
      applicantType: json['applicantType'] ?? 'User',
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicationId': applicationId,
      'applicantId': applicantId,
      'applicantName': applicantName,
      'profilePictureUrl': profilePictureUrl,
      'applicantType': applicantType,
      'status': status,
    };
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isAccepted => status.toLowerCase() == 'accepted';
  bool get isRejected => status.toLowerCase() == 'rejected';

  String get statusColor {
    switch (status.toLowerCase()) {
      case 'accepted':
        return 'green';
      case 'rejected':
        return 'red';
      case 'pending':
      default:
        return 'orange';
    }
  }

  @override
  List<Object?> get props => [
        applicationId,
        applicantId,
        applicantName,
        profilePictureUrl,
        applicantType,
        status,
      ];
}
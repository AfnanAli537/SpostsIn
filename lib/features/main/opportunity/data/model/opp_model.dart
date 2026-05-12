class OpportunityModel {
  final String id;
  final String title;
  final String publisherName;
  final String? mediaUrl;
  final bool isOwner;
  final DateTime createdAt;

  OpportunityModel({
    required this.id,
    required this.title,
    required this.publisherName,
    this.mediaUrl,
    required this.isOwner,
    required this.createdAt,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      publisherName: json['publisherName'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String?,
      isOwner: json['isOwner'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'publisherName': publisherName,
      'mediaUrl': mediaUrl,
      'isOwner': isOwner,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  
}



class PaginatedOpportunitiesResponse {
  final List<OpportunityModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedOpportunitiesResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedOpportunitiesResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedOpportunitiesResponse(
      items: (json['items'] as List<dynamic>)
          .map((item) => OpportunityModel.fromJson(item))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

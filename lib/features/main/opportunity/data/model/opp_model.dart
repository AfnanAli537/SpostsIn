class OpportunityModel {
  final String id;
  final String title;
  final String organization;
  final String sport;
  final String location;
  final String type;
  final String iconPath;
  final int colorCode;

  OpportunityModel({
    required this.id,
    required this.title,
    required this.organization,
    required this.sport,
    required this.location,
    required this.type,
    required this.iconPath,
    required this.colorCode,
  });

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      organization: json['organization'] ?? '',
      sport: json['sport'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      iconPath: json['iconPath'] ?? '',
      colorCode: json['colorCode'] ?? 0xFF1A5F4E,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'organization': organization,
      'sport': sport,
      'location': location,
      'type': type,
      'iconPath': iconPath,
      'colorCode': colorCode,
    };
  }
}





// ✅ Paginated Response Model
class PaginatedCommentsResponse {
  final List<OpportunityModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedCommentsResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedCommentsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedCommentsResponse(
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



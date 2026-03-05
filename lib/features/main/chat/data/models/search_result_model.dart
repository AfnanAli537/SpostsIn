///✅ ─── Search Result Model ───────────────────────────────────────
class SearchResultModel {
  final String id;
  final String title;
  final String? imageUrl;
  final String type;
  final bool isOnline;

  SearchResultModel({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.type,
    this.isOnline = false,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'],
      type: json['type'] ?? 'User',
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'type': type,
    'isOnline': isOnline,
  };
}

///✅ ─── Paginated Response ───────────────────────────────────────

class PaginatedSearchResponse {
  final List<SearchResultModel>? items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedSearchResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedSearchResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] ?? [];
    final itemsList = (itemsJson as List)
        .map((e) => SearchResultModel.fromJson(e))
        .toList();

    return PaginatedSearchResponse(
      items: itemsList,
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

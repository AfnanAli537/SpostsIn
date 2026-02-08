class DetailsModel {
  final String title;
  final String description;
  final String requirements;
  final DateTime endDate;
  final int sportTypeId;
  final String? mediaFile;
  final String? uploadedMediaUrl;

  DetailsModel({
    required this.title,
    required this.description,
    required this.requirements,
    required this.endDate,
    required this.sportTypeId,
    this.mediaFile,
    this.uploadedMediaUrl,
  });

  // --------------------------
  // From JSON
  // --------------------------
  factory DetailsModel.fromJson(Map<String, dynamic> json) {
    return DetailsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requirements: json['requirements'] ?? '',
      endDate: DateTime.parse(json['endDate']),
      sportTypeId: json['sportTypeId'] ?? 0,
      mediaFile: json['mediaFile'],
      uploadedMediaUrl: json['uploadedMediaUrl'],
    );
  }

  // --------------------------
  // To JSON
  // ------------
 // --------------------------
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'requirements': requirements,
      'endDate': endDate.toIso8601String(),
      'sportTypeId': sportTypeId,
      'mediaFile': mediaFile,
      'uploadedMediaUrl': uploadedMediaUrl,
    };
  }
}
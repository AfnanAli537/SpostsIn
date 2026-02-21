class DetailsModel {
  final String title;
  final String description;
  final String requirements;
  final DateTime endDate;
  final int sportTypeId;
  final String? mediaFile;
  final String? uploadedMediaUrl;
  final bool isAlreadyApplied;

  DetailsModel({
    required this.title,
    required this.description,
    required this.requirements,
    required this.endDate,
    required this.sportTypeId,
    this.mediaFile,
    this.uploadedMediaUrl,
     required this.isAlreadyApplied,
  });

  factory DetailsModel.fromJson(Map<String, dynamic> json) {
    return DetailsModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requirements: json['requirements'] ?? '',
      endDate: DateTime.parse(json['endDate']),
      sportTypeId: json['sportTypeId'] ?? 0,
      mediaFile: json['mediaFile'],
      uploadedMediaUrl: json['uploadedMediaUrl'],
      isAlreadyApplied: json['isAlreadyApplied']?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'requirements': requirements,
      'endDate': endDate.toIso8601String(),
      'sportTypeId': sportTypeId,
      'mediaFile': mediaFile,
      'uploadedMediaUrl': uploadedMediaUrl,
      'isAlreadyApplied':isAlreadyApplied,
    };
  }
}
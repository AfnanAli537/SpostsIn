class CertificationModel {
  final int id;
  final String name;

  const CertificationModel({required this.id, required this.name});

  factory CertificationModel.fromJson(Map<String, dynamic> json) =>
      CertificationModel(id: json['id'] as int, name: json['name'] as String);
}
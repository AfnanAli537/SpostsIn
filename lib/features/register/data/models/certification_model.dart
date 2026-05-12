class CertificationModel {
  final int id;
  final String name;

  const CertificationModel({required this.id, required this.name});

  factory CertificationModel.fromJson(Map<String, dynamic> json) =>
      CertificationModel(id: json['id'] as int, name: json['name'] as String);
}

extension CertificationIdMapper on String {
  String mapCertificationIdsToNames(List<CertificationModel> certifications) {
    if (isEmpty) return '';
    
    final ids = split(',').map((id) => int.tryParse(id.trim())).toList();
    final names = ids
        .map((id) {
          if (id == null) return null;
          final cert = certifications.firstWhere(
            (c) => c.id == id,
            orElse: () => CertificationModel(id: 0, name: ''),
          );
          return cert.name.isEmpty ? null : cert.name;
        })
        .where((name) => name != null)
        .cast<String>()
        .toList();
    
    return names.join(', ');
  }
}
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'dart:io';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';

@lazySingleton  
class CloudinaryService {
  static const String _defaultImageUrl = NetworkImageAssets.unknownImage;
  final ApiClient apiClient;

  CloudinaryService({required this.apiClient});

  Future<String> uploadImage(File? file) async {
    if (file == null) {
      return _defaultImageUrl;
    }
    return _uploadToCloudinary(file, 'image');
  }

  Future<String> uploadVideo(File file, {String folder = 'analysis/videos'}) async {
    return _uploadToCloudinary(file, 'video', folder: folder);
  }

  Future<String> _uploadToCloudinary(
    File file,
    String resourceType, {
    String? folder,
  }) async {
    try {
      final signatureResponse = await apiClient.get(Endpoints.uploadSignature);

      final data = signatureResponse.data['data'];
      final signature = data['signature'];
      final timestamp = data['timestamp'];
      final apiKey = data['apiKey'];
      final cloudName = data['cloudName'];

      final dio = Dio();
      final url = 'https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload';

      final Map<String, dynamic> uploadData = {
        'file': await MultipartFile.fromFile(file.path),
        'api_key': apiKey,
        'signature': signature,
        'timestamp': timestamp,
      };

      if (folder != null && folder.isNotEmpty) {
        uploadData['folder'] = folder;
      }

      final response = await dio.post(url, data: FormData.fromMap(uploadData));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['secure_url'];
      } else {
        return '';
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      return '';
    }
  }
}
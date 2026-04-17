// cloudinary_service.dart
import 'package:dio/dio.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'dart:io';
import 'package:sports_in/core/constants/strings_keys.dart';

class CloudinaryService {
  static const String _defaultImageUrl = NetworkImageAssets.unknownImage;

  static Future<String> uploadImage(File? file) async {
    if (file == null) {
      return _defaultImageUrl;
    }
    return _uploadToCloudinary(file, 'image');
  }

  static Future<String> uploadVideo(File file, {String folder = 'analysis/videos'}) async {
    return _uploadToCloudinary(file, 'video', folder: folder);
  }

  static Future<String> _uploadToCloudinary(File file, String resourceType, {String? folder}) async {
    final dio = Dio();
    final url = 'https://api.cloudinary.com/v1_1/${StringKeys.cloudName}/$resourceType/upload';

    try {
      final Map<String, dynamic> data = {
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': StringKeys.uploadPreset,
        'resource_type': resourceType,
      };
      if (folder != null && folder.isNotEmpty) {
        data['folder'] = folder;
      }

      final response = await dio.post(url, data: FormData.fromMap(data));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['secure_url'];
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
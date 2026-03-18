import 'package:dio/dio.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'dart:io';
import 'package:sports_in/core/constants/strings_keys.dart';

class CloudinaryService {
  static const String _defaultImageUrl =
      NetworkImageAssets.unknownImage;
  static Future<String> uploadImage(File? file) async {
    if (file == null) {
      return _defaultImageUrl;
    }
    final dio = Dio();
    final url =
        'https://api.cloudinary.com/v1_1/${StringKeys.cloudName}/image/upload';

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': StringKeys.uploadPreset,
        'folder': 'users/avatars',
      });

      final response = await dio.post(url, data: formData);

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

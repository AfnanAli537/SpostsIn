import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppImagePicker extends StatefulWidget {
  final void Function(File?) onImageSelected;
  final String? initialImage; 

  const AppImagePicker({
    super.key,
    required this.onImageSelected,
    this.initialImage,
  });

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      widget.onImageSelected(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: ColorManager.grey,
            backgroundImage: _getImageProvider(),
            child: _shouldShowPlaceholderIcon() 
                ? Icon(Icons.person, size: 40, color: ColorManager.white)
                : null,
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.lightAccent,
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(Icons.camera_alt, size: 18, color: ColorManager.black),
          )
        ],
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    if (_image != null) {
      return FileImage(_image!);
    }
    
    if (widget.initialImage != null && widget.initialImage!.isNotEmpty) {
      if (widget.initialImage!.startsWith('http')) {
        return NetworkImage(widget.initialImage!);
      } else {
        return const AssetImage(NetworkImageAssets.unknownImage); 
      }
    }
    
    return null;
  }

  bool _shouldShowPlaceholderIcon() {
    return _image == null && 
          (widget.initialImage == null || widget.initialImage!.isEmpty);
  }
}
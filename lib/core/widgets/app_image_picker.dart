import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppImagePicker extends StatefulWidget {
  final void Function(File?) onImageSelected;

  const AppImagePicker({super.key, required this.onImageSelected});

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
            backgroundImage: _image != null ? FileImage(_image!) : null,
            child: _image == null ? Icon(Icons.person, size: 40, color: ColorManager.white) : null,
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
}

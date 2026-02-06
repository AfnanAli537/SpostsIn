import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile_state.dart';
import 'package:sports_in/generated/l10n.dart';
import 'dart:io';

class AchievementEditScreen extends StatefulWidget {
  final Achievement? achievement;
  final String userId;

  const AchievementEditScreen({
    super.key,
    this.achievement,
    required this.userId,
  });

  @override
  State<AchievementEditScreen> createState() => _AchievementEditScreenState();
}

class _AchievementEditScreenState extends State<AchievementEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  DateTime? _selectedDate;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool get isEditMode => widget.achievement != null;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.achievement?.title ?? '';
    _descriptionController.text = widget.achievement?.subtitle ?? '';
    _imageUrlController.text = widget.achievement?.imageUrl ?? '';
    _selectedDate = widget.achievement?.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  InputDecoration _getFieldDecoration(ThemeData theme, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: theme.colorScheme.onSurface.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    ConfirmationDialog.show(
      context: context,
      title: 'Delete Achievement',
      message: 'Are you sure you want to delete this achievement?',
      onConfirm: () {
        context.read<ProfileBloc>().add(
          DeleteAchievement(achievementId: widget.achievement!.id),
        );
      },
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageUrlController.text = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveAchievement(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a date'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final bloc = context.read<ProfileBloc>();

    if (isEditMode) {
      bloc.add(
        UpdateAchievement(
          achievementId: widget.achievement!.id,
          title: _titleController.text.trim(),
          subtitle: _descriptionController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          date: _selectedDate!,
        ),
      );
    } else {
      bloc.add(
        CreateAchievement(
          title: _titleController.text.trim(),
          subtitle: _descriptionController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          date: _selectedDate!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is AchievementCreated || state is AchievementUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state is AchievementCreated 
                    ? 'Achievement created successfully' 
                    : 'Achievement updated successfully'),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
            Navigator.pop(context, true); // Returns to Detail/List Screen
          } else if (state is AchievementDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Achievement deleted successfully'),
                backgroundColor: Colors.red,
              ),
            );
            // Pop twice: once from Edit screen, once from Detail screen
            // This returns to the List screen or Profile screen
            Navigator.pop(context); // Pop Edit screen
            Navigator.pop(context, true); // Pop Detail screen with refresh flag
          }
        },
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            backgroundColor: colorScheme.surface,
            elevation: 0,
            centerTitle: true,
            title: Text(
              isEditMode ? 'Edit' : 'Add Achievement',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (isEditMode)
                TextButton(
                  onPressed: () => _showDeleteConfirmation(context),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D2B3D),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: _buildImagePreview(theme),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: TextButton(
                      onPressed: _pickImageFromGallery,
                      child: Text(
                        "Change Media",
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel("Date", theme),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        _selectedDate != null
                            ? _formatDate(_selectedDate!)
                            : "Select Date",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel("Title", theme),
                  TextFormField(
                    controller: _titleController,
                    decoration: _getFieldDecoration(
                      theme,
                      "National Championship",
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  _buildLabel("Description", theme),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: _getFieldDecoration(
                      theme,
                      "Explain your achievement...",
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.h),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _saveAchievement(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2B39),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    if (_selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.file(_selectedImage!, fit: BoxFit.cover),
      );
    }
    if (_imageUrlController.text.isNotEmpty &&
        !_imageUrlController.text.startsWith('/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          _imageUrlController.text,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
        ),
      );
    }
    return _buildPlaceholder(theme);
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo_outlined,
          size: 48.sp,
          color: Colors.white,
        ),
        SizedBox(height: 8.h),
        Text(
          'Add Achievement Photo',
          style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
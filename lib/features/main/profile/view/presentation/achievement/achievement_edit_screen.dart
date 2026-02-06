import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile_state.dart';
import 'package:sports_in/generated/l10n.dart';
import 'dart:io';

class AchievementEditScreen extends StatefulWidget {
  final Achievement? achievement; // null means create new
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
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

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
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
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

  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Achievement'),
        content: const Text(
            'Are you sure you want to delete this achievement? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(strings.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProfileBloc>().add(
                    DeleteAchievement(achievementId: widget.achievement!.id),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is AchievementCreated || state is AchievementUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isEditMode
                    ? 'Achievement updated successfully'
                    : 'Achievement created successfully'),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is AchievementDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Achievement deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        child: GestureDetector(
          onTap: _dismissKeyboard,
          child: Scaffold(
            appBar: AppBar(
              title: Text(isEditMode ? 'Edit Achievement' : 'Add Achievement'),
              actions: [
                if (isEditMode)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _showDeleteConfirmation(context),
                  )
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Image Section ---
                      GestureDetector(
                        onTap: _pickImageFromGallery,
                        child: Container(
                          height: 200.h,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: theme.colorScheme.outline.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: _buildImagePreview(theme),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Center(
                        child: Text(
                          'Tap image to select from gallery',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // --- Title Field ---
                      TextFormField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'National Championship',
                          prefixIcon: const Icon(Icons.emoji_events_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        maxLength: 60,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // --- Date Selection Field ---
                      InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(12.r),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Achievement Date',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate != null
                                    ? _formatDate(_selectedDate!)
                                    : 'Select when this happened',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: _selectedDate != null
                                      ? theme.colorScheme.onSurface
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // --- Description Field ---
                      TextFormField(
                        controller: _descriptionController,
                        focusNode: _descriptionFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Tell us more about this milestone...',
                          prefixIcon: const Icon(Icons.description_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        maxLines: 3,
                        maxLength: 200,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),

                      // --- Save Button ---
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          final isLoading = state is ProfileLoading;
                          return ElevatedButton(
                            onPressed: isLoading ? null : () => _saveAchievement(context),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  )
                                : Text(
                                    isEditMode ? 'Update Achievement' : 'Save Achievement',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    if (_selectedImage != null) {
      return Image.file(_selectedImage!, fit: BoxFit.cover);
    }
    if (_imageUrlController.text.isNotEmpty && !_imageUrlController.text.startsWith('/')) {
      return Image.network(
        _imageUrlController.text,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(theme),
      );
    }
    return _buildPlaceholder(theme);
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 48.sp, color: theme.colorScheme.primary),
        SizedBox(height: 8.h),
        Text('Add Achievement Photo', style: theme.textTheme.labelLarge),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
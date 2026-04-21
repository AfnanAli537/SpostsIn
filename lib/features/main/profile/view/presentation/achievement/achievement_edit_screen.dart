import 'dart:io';
import 'package:dotted_border/dotted_border.dart'; // Ensure this matches your ^3.1.0 version
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_state.dart';
import 'package:sports_in/generated/l10n.dart';

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

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _imageUrlController.text = image.path;
      });
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null) {
  //     setState(() => _selectedDate = picked);
  //   }
  // }
  Future<void> _selectDate(S strings) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        final theme = Theme.of(context);

        return Theme(
          data: theme.copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: theme.colorScheme.primary,
                    onPrimary: theme.colorScheme.onPrimary,
                    surface: theme.colorScheme.surface,
                    onSurface: theme.colorScheme.onSurface,
                  )
                : ColorScheme.light(
                    primary: theme.colorScheme.primary,
                    onPrimary: theme.colorScheme.onPrimary,
                    surface: theme.colorScheme.surface,
                    onSurface: theme.colorScheme.onSurface,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveAchievement(BuildContext context) {
    final string = S.of(context);
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      Fluttertoast.showToast(
        msg: string.please_select_date,
        backgroundColor: Colors.orange,
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
    ConfirmationDialog.show(
      context: context,
      title: S.of(context).deleteachievement,
      message: S.of(context).deleteachievementconfirmation,
      onConfirm: () {
        context.read<ProfileBloc>().add(
          DeleteAchievement(achievementId: widget.achievement!.id),
        );
      },
      confirmText: S.of(context).delete,
      cancelText: S.of(context).cancel,
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final string = S.of(context);

    return BlocProvider(
      create: (context) => getIt<ProfileBloc>(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is AchievementCreated) {
            Fluttertoast.showToast(
              msg: string.achievement_added_success,
              backgroundColor: Colors.green,
            );
            Navigator.pop(context, true);
          } else if (state is AchievementUpdated) {
            Fluttertoast.showToast(
              msg: string.achievement_updated_success,
              backgroundColor: Colors.green,
            );
            Navigator.pop(context, true);
          } else if (state is AchievementDeleted) {
            Fluttertoast.showToast(
              msg: string.achievementDeleted,
              backgroundColor: Colors.red,
            );
            Navigator.pop(context);
            Navigator.pop(context, true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              isEditMode
                  ? string.edit_achievement
                  : string.add_achievement_title,
              style: TextStyle(
                color: theme.onSurface,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              if (isEditMode)
                TextButton(
                  onPressed: () => _showDeleteConfirmation(context),
                  child: Text(
                    string.delete,
                    style: TextStyle(color: theme.error),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Fixed DottedBorder for v3.1.0 ---
                    GestureDetector(
                      onTap: _pickImageFromGallery,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: Colors.grey[400]!,
                          strokeWidth: 2.w,
                          dashPattern: const [20, 6],
                          radius: Radius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            height: 200.h,
                            width: double.infinity,
                            color: theme.surface,
                            child: _buildMediaPreview(theme, string),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    _buildLabel(string.date_label, theme),
                    GestureDetector(
                      onTap: () => _selectDate(string),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h, 
                        ),
                        decoration: BoxDecoration(
                          color: theme
                              .surface, 
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: theme.outline.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? _formatDate(_selectedDate!)
                                  : string.select_date_hint,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: _selectedDate != null
                                    ? Colors
                                          .black87 
                                    : Colors
                                          .grey[500],
                              ),
                            ),
                            Icon(
                              Icons
                                  .calendar_month, // Or use Icons.calendar_today to match exactly
                              color: Colors
                                  .grey[600], // Changed from theme.primary
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    _buildLabel(string.title_label, theme),
                    AuthTextField(
                      controller: _titleController,
                      hintText: string.title_hint,
                    ),
                    SizedBox(height: 20.h),

                    _buildLabel(string.description_label, theme),
                    AuthTextField(
                      controller: _descriptionController,
                      hintText: string.description_hint,
                      maxLines: 5,
                    ),
                    SizedBox(height: 40.h),

                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        final isLoading = state is ProfileLoading;
                        return CustomElevatedButton(
                          text: isEditMode
                              ? string.update_button
                              : string.save_achievement_button,
                          isLoading: isLoading,
                          onPressed: () => _saveAchievement(context),
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
    );
  }

  Widget _buildLabel(String text, ColorScheme theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: theme.onSurface,
        ),
      ),
    );
  }

  Widget _buildMediaPreview(ColorScheme theme, S string) {
    if (_selectedImage != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(_selectedImage!, fit: BoxFit.cover),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedImage = null;
                _imageUrlController.clear();
              }),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 20.sp),
              ),
            ),
          ),
        ],
      );
    }

    if (_imageUrlController.text.isNotEmpty &&
        !_imageUrlController.text.startsWith('/')) {
      return Image.network(_imageUrlController.text, fit: BoxFit.cover);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 60.sp, color: Colors.grey[600]),
        SizedBox(height: 12.h),
        Text(
          string.upload_photo_hint,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

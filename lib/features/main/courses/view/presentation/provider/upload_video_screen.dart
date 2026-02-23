import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class UploadVideoScreen extends StatefulWidget {
  final String courseId;
  final int existingLessonsCount;

  const UploadVideoScreen({
    super.key,
    required this.courseId,
    required this.existingLessonsCount,
  });

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  File? _selectedVideo;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (video != null) {
        final file = File(video.path);
        final fileSize = await file.length();
        
        // Check file size (500 MB limit)
        if (fileSize > 500 * 1024 * 1024) {
          if (mounted) {
            Fluttertoast.showToast(
              msg: 
              // S.of(context).fileTooLarge ?? 
              'File size exceeds 500MB',
              backgroundColor: Colors.red,
            );
          }
          return;
        }

        setState(() {
          _selectedVideo = file;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error picking video: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  void _uploadVideo() {
    // final string = S.of(context);

    if (!_formKey.currentState!.validate()) return;

    if (_selectedVideo == null) {
      Fluttertoast.showToast(
        msg: 
        // string.selectVideo ?? 
        'Please select a video',
        backgroundColor: Colors.orange,
      );
      return;
    }

    final duration = double.tryParse(_durationController.text);
    if (duration == null || duration <= 0) {
      Fluttertoast.showToast(
        msg: 
        // string.invalidDuration ?? 
        'Please enter a valid duration',
        backgroundColor: Colors.orange,
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Simulate upload progress
    _simulateUploadProgress();

    // Auto-calculate order (existingLessonsCount + 1)
    final order = widget.existingLessonsCount + 1;

    context.read<CoursesBloc>().add(
          CreateLesson(
            courseId: widget.courseId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            duration: duration, // ✅ IN MINUTES
            videoFile: _selectedVideo!,
            order: order, // Auto-calculated
          ),
        );
  }

  void _simulateUploadProgress() {
    // Simulate upload progress for UX
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _isUploading) {
        setState(() {
          _uploadProgress += 0.1;
          if (_uploadProgress < 0.9) {
            _simulateUploadProgress();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final string = S.of(context);

    return BlocListener<CoursesBloc, CoursesState>(
      listener: (context, state) {
        if (state is LessonCreated) {
          setState(() {
            _isUploading = false;
            _uploadProgress = 1.0;
          });
          Fluttertoast.showToast(
            msg: 
            // string.lessonUploaded ?? 
            'Lesson uploaded successfully',
            backgroundColor: Colors.green,
          );
          Navigator.pop(context, true);
        } else if (state is CoursesError) {
          setState(() {
            _isUploading = false;
            _uploadProgress = 0.0;
          });
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            // string.uploadLesson ?? 
          'Upload Lesson'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video picker
                  GestureDetector(
                    onTap: _isUploading ? null : _pickVideo,
                    child: Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                      ),
                      child: _selectedVideo != null
                          ? Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.video_file,
                                        size: 64.sp,
                                        color: theme.primary,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        _selectedVideo!.path.split('/').last,
                                        style: TextStyle(fontSize: 12.sp),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (!_isUploading)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _selectedVideo = null;
                                      }),
                                      child: Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 60.sp,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  // string.uploadVideo ?? 
                                  'Upload Video',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  // string.maxFileSize ?? 
                                  'Max 500MB',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Upload progress
                  if (_isUploading) ...[
                    LinearProgressIndicator(
                      value: _uploadProgress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                      minHeight: 8.h,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${(_uploadProgress * 100).toInt()}% ${
                        // string.uploaded ?? 
                      "uploaded"}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 24.h),
                  ],

                  // Title field
                  _buildLabel(
                    // string.lessonTitle ?? 
                  'Lesson Title', theme),
                  AuthTextField(
                    controller: _titleController,
                    hintText:
                    //  string.enterLessonTitle ?? 
                    'Enter lesson title',
                    // enabled: !_isUploading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 
                        // string.titleRequired ?? 
                        'Title is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Description field
                  _buildLabel(string.description ?? 'Description', theme),
                  AuthTextField(
                    controller: _descriptionController,
                    hintText: 
                    // string.enterDescription ??
                     'Enter description',
                    maxLines: 4,
                    // enabled: !_isUploading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 
                        // string.descriptionRequired ?? 
                        'Description is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Duration field (in SECONDS)
                  _buildLabel(
                    '${
                      // string.duration ??
                       "Duration"} (in seconds)',
                    theme,
                  ),
                  AuthTextField(
                    controller: _durationController,
                    hintText: 'Enter duration in seconds (e.g., 300)',
                    // keyboardType: TextInputType.number,
                    // enabled: !_isUploading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 
                        // string.durationRequired ?? 
                        'Duration is required';
                      }
                      final duration = double.tryParse(value);
                      if (duration == null || duration <= 0) {
                        return 
                        // string.invalidDuration ?? 
                        'Invalid duration';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Example: 300 for 5 minutes, 3600 for 1 hour',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Lesson order info
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: theme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20.sp,
                          color: theme.primary,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            '${
                              // string.lessonOrder ?? 
                            "Lesson order"}: ${widget.existingLessonsCount + 1}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: theme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Upload button
                  CustomElevatedButton(
                    text: _isUploading
                        ? (
                          // string.uploading ??
                           'Uploading...')
                        : (
                          // string.uploadLesson ?? 
                          'Upload Lesson'),
                    isLoading: _isUploading,
                    enabled: !_isUploading,
                    onPressed: _isUploading ? (){} : _uploadVideo,
                  ),
                ],
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
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: theme.onSurface,
        ),
      ),
    );
  }
}
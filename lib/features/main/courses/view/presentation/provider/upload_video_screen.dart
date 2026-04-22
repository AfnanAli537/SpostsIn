import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';

class UploadLessonScreen extends StatefulWidget {
  final String courseId;
  final int existingLessonsCount;

  const UploadLessonScreen({
    super.key,
    required this.courseId,
    required this.existingLessonsCount,
  });

  @override
  State<UploadLessonScreen> createState() => _UploadLessonScreenState();
}

class _UploadLessonScreenState extends State<UploadLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedVideo;
  double? _videoDuration; // in seconds
  final ImagePicker _picker = ImagePicker();
  bool _isExtracting = false;

  // Video info extractor
  final FlutterVideoInfo _videoInfo = FlutterVideoInfo();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showError(String errorKey) async {
    if (!mounted) return;
    final msg = await TranslateErrorHelper.translateErrorKeyAsync(
      context,
      errorKey,
    );
    if (mounted) {
      Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
    }
  }

  Future<void> _showWarning(String message) async {
    if (mounted) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.orange,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
    }
  }

  Future<void> _showInfo(String message) async {
    if (mounted) {
      Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.blue,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
    }
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
          await _showError('file_size_exceeds_limit');
          return;
        }

        setState(() {
          _selectedVideo = file;
          _videoDuration = null; // Reset duration
          _isExtracting = true;
        });

        await _extractVideoInfo(file);
      }
    } catch (e) {
      await _showError('error_picking_video');
      setState(() {
        _isExtracting = false;
      });
    }
  }

  /// Extract video metadata using flutter_video_info
  Future<void> _extractVideoInfo(File videoFile) async {
    try {
      // Get video info – returns a Map<String, dynamic> or null
      final info = await _videoInfo.getVideoInfo(videoFile.path);

      if (info == null) {
        throw Exception('Could not read video info');
      }

      // Duration is in milliseconds
      final durationMs = info.duration; // int
      if (durationMs == null || durationMs <= 0) {
        throw Exception('Invalid duration');
      }

      setState(() {
        _videoDuration = durationMs / 1000.0; // convert to seconds
        _isExtracting = false;
      });

      debugPrint('✅ Video duration extracted: $_videoDuration seconds');
    } catch (e) {
      debugPrint('❌ Error extracting video info: $e');
      await _showError('failed_to_read_video_duration');
      setState(() {
        _videoDuration = null;
        _isExtracting = false;
        _selectedVideo = null; // Clear the invalid video
      });
    }
  }

  Future<void> _uploadVideo() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedVideo == null) {
      await _showWarning(S.of(context).pleaseSelectVideo);
      return;
    }

    if (_videoDuration == null || _videoDuration! <= 0) {
      await _showWarning(S.of(context).invalidVideoDuration);
      return;
    }

    final order = widget.existingLessonsCount + 1;

    context.read<CoursesBloc>().add(
          CreateLesson(
            courseId: widget.courseId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            duration: _videoDuration!,
            videoFile: _selectedVideo!,
            order: order,
          ),
        );

    await _showInfo(S.of(context).uploadingInBackground);

    if (mounted) {
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    }
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.round());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final string = S.of(context);

    return BlocListener<CoursesBloc, CoursesState>(
      listener: (context, state) async {
        if (state is CoursesError) {
          await _showError(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(string.uploadLesson),
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
                    onTap: _isExtracting ? null : _pickVideo,
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

                                      if (_isExtracting) ...[
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                                          child: const CircularProgressIndicator(),
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          string.extractingDuration,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: theme.primary,
                                          ),
                                        ),
                                      ] else if (_videoDuration != null) ...[
                                        Container(
                                          margin: EdgeInsets.only(top: 8.h),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 14.sp,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                '${string.duration}: ${_formatDuration(_videoDuration!)}',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                      SizedBox(height: 8.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                                        child: Text(
                                          _selectedVideo!.path.split('/').last,
                                          style: TextStyle(fontSize: 12.sp),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Remove button
                                if (!_isExtracting)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        _selectedVideo = null;
                                        _videoDuration = null;
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
                                  string.uploadVideo,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  string.maxFileSize,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Title field
                  _buildLabel(string.lessonTitle, theme),
                  AuthTextField(
                    controller: _titleController,
                    hintText: string.enterLessonTitleHint,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return string.titleRequired;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Description field
                  _buildLabel(string.description, theme),
                  AuthTextField(
                    controller: _descriptionController,
                    hintText: string.enterDescriptionHint,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return string.descriptionRequired;
                      }
                      return null;
                    },
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
                            string.lessonOrderAndDuration(
                              (widget.existingLessonsCount + 1).toString(),
                              _videoDuration != null ? _formatDuration(_videoDuration!) : string.notDetected,
                            ),
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
                    text: string.uploadLesson,
                    enabled: !_isExtracting && _videoDuration != null,
                    onPressed: _uploadVideo,
                  ),

                  SizedBox(height: 12.h),

                  Center(
                    child: Text(
                      string.uploadWillContinue,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
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
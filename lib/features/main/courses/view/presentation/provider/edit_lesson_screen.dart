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
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class EditLessonScreen extends StatefulWidget {
  final LessonModel lesson;
  final String courseId;

  const EditLessonScreen({
    super.key,
    required this.lesson,
    required this.courseId,
  });

  @override
  State<EditLessonScreen> createState() => _EditLessonScreenState();
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  File? _newVideo; // New video file if user wants to replace
  double? _newVideoDuration; // Duration of new video
  final ImagePicker _picker = ImagePicker();
  bool _isExtracting = false;
  final FlutterVideoInfo _videoInfo = FlutterVideoInfo();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.lesson.title);
    _descriptionController = TextEditingController(text: widget.lesson.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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

        if (fileSize > 500 * 1024 * 1024) {
          if (mounted) {
            Fluttertoast.showToast(
              msg: 'File size exceeds 500MB',
              backgroundColor: Colors.red,
            );
          }
          return;
        }

        setState(() {
          _newVideo = file;
          _newVideoDuration = null;
          _isExtracting = true;
        });

        await _extractVideoInfo(file);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error picking video: $e',
        backgroundColor: Colors.red,
      );
      setState(() {
        _isExtracting = false;
      });
    }
  }

  Future<void> _extractVideoInfo(File videoFile) async {
    try {
      final info = await _videoInfo.getVideoInfo(videoFile.path);

      if (info == null) {
        throw Exception('Could not read video info');
      }

      final durationMs = info.duration;
      if (durationMs == null || durationMs <= 0) {
        throw Exception('Invalid duration');
      }

      setState(() {
        _newVideoDuration = durationMs / 1000.0;
        _isExtracting = false;
      });

      debugPrint('✅ Video duration extracted: $_newVideoDuration seconds');
    } catch (e) {
      debugPrint('❌ Error extracting video info: $e');
      Fluttertoast.showToast(
        msg: 'Failed to read video duration',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() {
        _newVideoDuration = null;
        _isExtracting = false;
        _newVideo = null;
      });
    }
  }

  Future<void> _updateLesson() async {
    if (!_formKey.currentState!.validate()) return;

    // Determine final duration and video
    final finalDuration = _newVideoDuration ?? widget.lesson.duration;
    final finalVideo = _newVideo ?? widget.lesson.videoUrl ?? '';

    context.read<CoursesBloc>().add(
      UpdateLesson(
        lessonId: widget.lesson.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        duration: finalDuration,
        order: widget.lesson.order,
        video: finalVideo, // File or URL
      ),
    );

    Fluttertoast.showToast(
      msg: 'Updating lesson...',
      backgroundColor: Colors.blue,
      toastLength: Toast.LENGTH_LONG,
    );

    if (mounted) {
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
      listener: (context, state) {
        if (state is CoursesError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Lesson'),
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
                  // Current or New Video
                  _buildVideoSection(theme),
                  SizedBox(height: 24.h),

                  // Title field
                  _buildLabel('Lesson Title', theme),
                  AuthTextField(
                    controller: _titleController,
                    hintText: 'Enter lesson title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Description field
                  _buildLabel(string.description, theme),
                  AuthTextField(
                    controller: _descriptionController,
                    hintText: 'Enter description',
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Lesson info
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: theme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20.sp,
                              color: theme.primary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Lesson order: ${widget.lesson.order}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: theme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Duration: ${_formatDuration(_newVideoDuration ?? widget.lesson.duration)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: _newVideo != null ? Colors.green : theme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Update button
                  CustomElevatedButton(
                    text: 'Update Lesson',
                    enabled: !_isExtracting,
                    onPressed: _updateLesson,
                  ),

                  SizedBox(height: 12.h),

                  if (_newVideo != null)
                    Center(
                      child: Text(
                        'New video will be uploaded',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green,
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

  Widget _buildVideoSection(ColorScheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Video',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: _isExtracting ? null : _pickVideo,
              icon: Icon(Icons.upload_file, size: 18.sp),
              label: Text(_newVideo != null ? 'Change Video' : 'Replace Video'),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _newVideo != null ? Colors.green : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: _buildVideoContent(theme),
        ),
      ],
    );
  }

  Widget _buildVideoContent(ColorScheme theme) {
    if (_isExtracting) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 8.h),
          Text(
            'Extracting duration...',
            style: TextStyle(fontSize: 12.sp, color: theme.primary),
          ),
        ],
      );
    }

    if (_newVideo != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_file, size: 40.sp, color: Colors.green),
            SizedBox(height: 8.h),
            Text(
              'New video selected',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_newVideoDuration != null) ...[
              SizedBox(height: 4.h),
              Text(
                _formatDuration(_newVideoDuration!),
                style: TextStyle(fontSize: 12.sp, color: Colors.green),
              ),
            ],
          ],
        ),
      );
    }

    // Show current video info
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam, size: 40.sp, color: theme.primary),
          SizedBox(height: 8.h),
          Text(
            'Current video',
            style: TextStyle(fontSize: 12.sp, color: theme.onSurface),
          ),
          SizedBox(height: 4.h),
          Text(
            _formatDuration(widget.lesson.duration),
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
        ],
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
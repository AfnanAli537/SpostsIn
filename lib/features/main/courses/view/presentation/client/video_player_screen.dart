import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class VideoPlayerScreen extends StatefulWidget {
  final LessonModel lesson;
  final List<LessonModel> allLessons;
  final String courseId;

  const VideoPlayerScreen({
    super.key,
    required this.lesson,
    required this.allLessons,
    required this.courseId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  Timer? _progressSaveTimer;
  Timer? _hideControlsTimer;
  bool _isControlsVisible = true;
  bool _isInitialized = false;
  bool _hasError = false;
  int? _nextLessonIndex;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _findNextLesson();
  }

  void _findNextLesson() {
    final currentIndex = widget.allLessons.indexWhere((l) => l.id == widget.lesson.id);
    if (currentIndex >= 0 && currentIndex < widget.allLessons.length - 1) {
      _nextLessonIndex = currentIndex + 1;
    }
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.lesson.videoUrl == null || widget.lesson.videoUrl!.isEmpty) {
        setState(() {
          _hasError = true;
        });
        return;
      }

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.lesson.videoUrl!),
      );

      await _controller.initialize();

      setState(() {
        _isInitialized = true;
      });

      // Seek to last watched position
      if (widget.lesson.watchedTimeInSeconds > 0) {
        await _controller.seekTo(
          Duration(seconds: widget.lesson.watchedTimeInSeconds),
        );
      }

      // Auto-play
      _controller.play();

      // Start progress saving timer (every 5 seconds)
      _startProgressSaveTimer();

      // Auto-hide controls
      _resetHideControlsTimer();

      // Listen for video completion
      _controller.addListener(_videoListener);
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration) {
      // Video completed
      _onVideoCompleted();
    }
  }

  void _startProgressSaveTimer() {
    _progressSaveTimer?.cancel();
    _progressSaveTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (_controller.value.isPlaying) {
          _saveProgress();
        }
      },
    );
  }

  void _saveProgress() {
    if (!_controller.value.isInitialized) return;

    final currentSeconds = _controller.value.position.inSeconds;
    final totalSeconds = _controller.value.duration.inSeconds;
    
    // ✅ Already in seconds! No conversion needed
    final watchedSeconds = currentSeconds.toDouble();
    final totalDurationSeconds = widget.lesson.duration;
    
    // Mark as watched if >= 95% complete
    final isWatched = watchedSeconds >= (totalDurationSeconds * 0.95);

    context.read<CoursesBloc>().add(
          UpdateLessonProgress(
            lessonId: widget.lesson.id,
            watchedTime: watchedSeconds, // ✅ IN SECONDS
            isWatched: isWatched,
          ),
        );
  }

  void _onVideoCompleted() {
    // Save final progress
    _saveProgress();

    // Show next lesson dialog if available
    if (_nextLessonIndex != null) {
      _showNextLessonDialog();
    }
  }

  void _showNextLessonDialog() {
    // final string = S.of(context);
    final nextLesson = widget.allLessons[_nextLessonIndex!];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          // string.lessonComplete ?? 
        'Lesson Complete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // string.nextLesson ?? 
            'Next Lesson:'),
            SizedBox(height: 8.h),
            Text(
              nextLesson.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to lessons list
            },
            child: Text(
              // string.backToLessons ?? 
            'Back to Lessons'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<CoursesBloc>(),
                    child: VideoPlayerScreen(
                      lesson: nextLesson,
                      allLessons: widget.allLessons,
                      courseId: widget.courseId,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              // string.playNext ?? 
            'Play Next'),
          ),
        ],
      ),
    );
  }

  void _resetHideControlsTimer() {
    _hideControlsTimer?.cancel();
    setState(() {
      _isControlsVisible = true;
    });
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _progressSaveTimer?.cancel();
    _hideControlsTimer?.cancel();
    _controller.removeListener(_videoListener);
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: Colors.white,
              ),
              SizedBox(height: 16.h),
              Text(
                // string.videoLoadError ?? 
                'Error loading video',
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(string.back),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _resetHideControlsTimer,
        child: Stack(
          children: [
            // Video player
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),

            // Controls overlay
            if (_isControlsVisible)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Top bar
                      _buildTopBar(theme, string),
                      const Spacer(),
                      // Center play/pause
                      _buildCenterControls(),
                      const Spacer(),
                      // Bottom controls
                      _buildBottomControls(theme),
                    ],
                  ),
                ),
              ),

            // Loading indicator
            if (_controller.value.isBuffering)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme, S string) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _saveProgress(); // Save before leaving
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lesson.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.lesson.formattedDuration,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Rewind 10s
        IconButton(
          icon: const Icon(Icons.replay_10, color: Colors.white, size: 36),
          onPressed: () {
            final newPosition = _controller.value.position - const Duration(seconds: 10);
            _controller.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
            _resetHideControlsTimer();
          },
        ),
        SizedBox(width: 32.w),
        // Play/Pause
        IconButton(
          icon: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 56,
          ),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
            _resetHideControlsTimer();
          },
        ),
        SizedBox(width: 32.w),
        // Forward 10s
        IconButton(
          icon: const Icon(Icons.forward_10, color: Colors.white, size: 36),
          onPressed: () {
            final newPosition = _controller.value.position + const Duration(seconds: 10);
            _controller.seekTo(
              newPosition > _controller.value.duration
                  ? _controller.value.duration
                  : newPosition,
            );
            _resetHideControlsTimer();
          },
        ),
      ],
    );
  }

  Widget _buildBottomControls(ThemeData theme) {
    return Column(
      children: [
        // Progress bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                _formatDuration(_controller.value.position),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Colors.red,
                    bufferedColor: Colors.white30,
                    backgroundColor: Colors.white12,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                _formatDuration(_controller.value.duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}
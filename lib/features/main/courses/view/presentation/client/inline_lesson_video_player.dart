import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';

class InlineLessonVideoPlayer extends StatefulWidget {
  final LessonModel lesson;
  final String courseId;
  final List<LessonModel> allLessons;
  final VoidCallback onBack;
  final Function(LessonModel) onNextLesson;
  final Function(LessonModel) onPreviousLesson;

  const InlineLessonVideoPlayer({
    super.key,
    required this.lesson,
    required this.courseId,
    required this.allLessons,
    required this.onBack,
    required this.onNextLesson,
    required this.onPreviousLesson,
  });

  @override
  State<InlineLessonVideoPlayer> createState() => _InlineLessonVideoPlayerState();
}

class _InlineLessonVideoPlayerState extends State<InlineLessonVideoPlayer> {
  BetterPlayerController? _controller;
  bool _isInitialized = false;
  String? _errorMessage;
  Timer? _progressSaveTimer;
  Timer? _controlsHideTimer;
  bool _showCustomControls = true; // ✅ For fading effect
  
  // ✅ Progress tracking
  double _lastSavedPosition = 0.0;
  double _currentPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _startProgressSaveTimer();
  }

  // ✅ Handle lesson changes
  @override
  void didUpdateWidget(InlineLessonVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.id != widget.lesson.id) {
      // Lesson changed, reinitialize player
      debugPrint('🔄 Lesson changed, reinitializing player');
      _controller?.dispose();
      _progressSaveTimer?.cancel();
      _lastSavedPosition = 0.0;
      _currentPosition = 0.0;
      _isInitialized = false;
      _errorMessage = null;
      _initializePlayer();
    }
  }

  // ✅ Check if there's a next lesson
  bool get hasNextLesson {
    final currentIndex = widget.allLessons.indexWhere((l) => l.id == widget.lesson.id);
    return currentIndex >= 0 && currentIndex < widget.allLessons.length - 1;
  }

  // ✅ Check if there's a previous lesson
  bool get hasPreviousLesson {
    final currentIndex = widget.allLessons.indexWhere((l) => l.id == widget.lesson.id);
    return currentIndex > 0;
  }

  // ✅ Play next lesson
  void _playNextLesson() {
    if (hasNextLesson) {
      final currentIndex = widget.allLessons.indexWhere((l) => l.id == widget.lesson.id);
      _saveProgressIfNeeded();
      _controller?.pause();
      widget.onNextLesson(widget.allLessons[currentIndex + 1]);
    }
  }

  // ✅ Play previous lesson
  void _playPreviousLesson() {
    if (hasPreviousLesson) {
      final currentIndex = widget.allLessons.indexWhere((l) => l.id == widget.lesson.id);
      _saveProgressIfNeeded();
      _controller?.pause();
      widget.onPreviousLesson(widget.allLessons[currentIndex - 1]);
    }
  }

  @override
  void dispose() {
    _saveProgressIfNeeded();
    _progressSaveTimer?.cancel();
    _controlsHideTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  // ✅ Show controls and hide after 3 seconds
  void _toggleControls() {
    setState(() {
      _showCustomControls = !_showCustomControls;
    });
    
    if (_showCustomControls) {
      _resetControlsHideTimer();
    }
  }

  void _resetControlsHideTimer() {
    _controlsHideTimer?.cancel();
    _controlsHideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller?.isPlaying() == true) {
        setState(() {
          _showCustomControls = false;
        });
      }
    });
  }

  // ✅ Initialize better player
  Future<void> _initializePlayer() async {
    try {
      debugPrint('🎬 Initializing video player for: ${widget.lesson.videoUrl}');
      
      final betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.lesson.videoUrl!,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
        ),
      );

      _controller = BetterPlayerController(
        BetterPlayerConfiguration(
          autoPlay: true,
          autoDetectFullscreenAspectRatio: true,
          autoDetectFullscreenDeviceOrientation: true,
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableSkips: true,
            enableFullscreen: true,
            enablePip: false,
            enablePlayPause: true,
            enableMute: true,
            enableProgressText: true,
            enableProgressBar: true,
            showControlsOnInitialize: true,
            controlBarHeight: 40,
            controlBarColor: Colors.black.withOpacity(0.5),
            iconsColor: Colors.white,
            progressBarPlayedColor: Colors.red,
            progressBarHandleColor: Colors.red,
            loadingWidget: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          errorBuilder: (context, errorMessage) {
            return _buildErrorView();
          },
        ),
        betterPlayerDataSource: betterPlayerDataSource,
      );

      // ✅ Seek to last watched position
      if (widget.lesson.watchedTime > 0) {
        debugPrint('⏩ Seeking to ${widget.lesson.watchedTime} seconds');
        await _controller?.setupDataSource(betterPlayerDataSource);
        await Future.delayed(const Duration(milliseconds: 500)); // Wait for setup
        _controller?.seekTo(Duration(seconds: widget.lesson.watchedTime.round()));
        _lastSavedPosition = widget.lesson.watchedTime;
        _currentPosition = widget.lesson.watchedTime;
      }

      // ✅ Listen to player events
      _controller?.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
          final position = event.parameters?['progress'] as Duration?;
          final duration = event.parameters?['duration'] as Duration?;
          
          if (position != null && duration != null) {
            _currentPosition = position.inSeconds.toDouble();
            
            // Check if video finished (≥90% watched)
            if (position >= duration * 0.9 && !widget.lesson.isWatched) {
              _markAsWatched();
            }
          }
        } else if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
          debugPrint('❌ Player error: ${event.parameters}');
          if (mounted) {
            setState(() {
              _errorMessage = 'Failed to play video';
              _isInitialized = false;
            });
          }
        } else if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          debugPrint('✅ Video initialized successfully');
          if (mounted) {
            setState(() {
              _isInitialized = true;
              _errorMessage = null;
            });
          }
        } else if (event.betterPlayerEventType == BetterPlayerEventType.play) {
          _resetControlsHideTimer();
        } else if (event.betterPlayerEventType == BetterPlayerEventType.pause) {
          _controlsHideTimer?.cancel();
          setState(() {
            _showCustomControls = true;
          });
        }
      });

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('❌ Error initializing video: $e');
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _errorMessage = 'Failed to load video';
        });
      }
    }
  }

  // ✅ Start auto-save timer (every 10 seconds)
  void _startProgressSaveTimer() {
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_controller?.isPlaying() == true) {
        _saveProgressIfNeeded();
      }
    });
  }

  // ✅ Save progress if position increased
  void _saveProgressIfNeeded() {
    if (_controller == null) return;
    
    final currentPos = _currentPosition;
    
    // Only save if we've progressed further than last save
    if (currentPos > _lastSavedPosition + 5) {
      debugPrint('💾 Saving progress: $currentPos seconds (was: $_lastSavedPosition)');
      
      final isWatched = currentPos >= widget.lesson.duration * 0.9;
      
      // ✅ Don't listen to state changes, just fire and forget
      context.read<CoursesBloc>().add(
        UpdateLessonProgress(
          lessonId: widget.lesson.id,
          watchedTime: currentPos,
          isWatched: isWatched,
          zoomScale: 1.0,
        ),
      );
      
      _lastSavedPosition = currentPos;
    }
  }

  // ✅ Mark lesson as watched (≥90% completion)
  void _markAsWatched() {
    if (!widget.lesson.isWatched) {
      debugPrint('✅ Marking lesson as watched');
      
      context.read<CoursesBloc>().add(
        UpdateLessonProgress(
          lessonId: widget.lesson.id,
          watchedTime: widget.lesson.duration,
          isWatched: true,
          zoomScale: 1.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isFullscreen = _controller?.isFullScreen ?? false;

    return Container(
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ Video Player (responsive to orientation)
          if (_errorMessage != null)
            _buildErrorView()
          else if (_isInitialized && _controller != null)
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: isLandscape 
                      ? MediaQuery.of(context).size.height 
                      : constraints.maxWidth * 9 / 16,
                  child: GestureDetector(
                    onTap: _toggleControls,
                    child: Stack(
                      children: [
                        // Video
                        Positioned.fill(
                          child: BetterPlayer(controller: _controller!),
                        ),
                        
                        // ✅ Custom controls (fading)
                        if (_showCustomControls && !isFullscreen)
                          AnimatedOpacity(
                            opacity: _showCustomControls ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: _buildCustomControls(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            )
          else
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          
          // ✅ Lesson Description (only in portrait, not in fullscreen)
          if (!isLandscape && 
              !isFullscreen &&
              widget.lesson.description != null && 
              widget.lesson.description!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              color: theme.colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lesson Description',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.lesson.description!,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ✅ Custom controls overlay
  Widget _buildCustomControls() {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Top gradient with back button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    iconSize: 28,
                    onPressed: () {
                      _saveProgressIfNeeded();
                      widget.onBack();
                    },
                  ),
                ),
              ),
            ),
          ),
          
          // ✅ Center next/previous buttons
          Positioned.fill(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Previous button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: hasPreviousLesson ? _playPreviousLesson : null,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: hasPreviousLesson 
                                ? Colors.white 
                                : Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.skip_previous,
                          color: hasPreviousLesson 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.3),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  
                  // Spacer
                  const SizedBox(width: 100),
                  
                  // Next button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: hasNextLesson ? _playNextLesson : null,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: hasNextLesson 
                                ? Colors.white 
                                : Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.skip_next,
                          color: hasNextLesson 
                              ? Colors.white 
                              : Colors.white.withOpacity(0.3),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Error view
  Widget _buildErrorView() {
    final theme = Theme.of(context);
    
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: widget.onBack,
                ),
              ),
            ),
            
            // Error message
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Video Playback Error',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage ?? 'Unknown error',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isInitialized = false;
                        });
                        _initializePlayer();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
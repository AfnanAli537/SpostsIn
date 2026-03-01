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
  bool _isFullscreen = false; 
  
  double _lastSavedPosition = 0.0;
  double _currentPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _startProgressSaveTimer();
  }

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
      _isFullscreen = false;
      _initializePlayer();
    }
  }

  bool get hasNextLesson {
    final currentIndex = widget.allLessons.indexWhere((l) => l.id == widget.lesson.id);
    return currentIndex >= 0 && currentIndex < widget.allLessons.length - 1;
  }

  bool get hasPreviousLesson {
    final currentIndex = widget.allLessons.indexWhere((l) => l.id == widget.lesson.id);
    return currentIndex > 0;
  }

  void _playNextLesson() {
    if (hasNextLesson) {
      final currentIndex = widget.allLessons.indexWhere((l) => l.id == widget.lesson.id);
      _saveProgressIfNeeded();
      _controller?.pause();
      widget.onNextLesson(widget.allLessons[currentIndex + 1]);
    }
  }

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
    _controller?.dispose();
    super.dispose();
  }


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

      if (widget.lesson.watchedTime > 0) {
        debugPrint('⏩ Seeking to ${widget.lesson.watchedTime} seconds');
        await _controller?.setupDataSource(betterPlayerDataSource);
        await Future.delayed(const Duration(milliseconds: 500));
        _controller?.seekTo(Duration(seconds: widget.lesson.watchedTime.round()));
        _lastSavedPosition = widget.lesson.watchedTime;
        _currentPosition = widget.lesson.watchedTime;
      }

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
        } else if (event.betterPlayerEventType == BetterPlayerEventType.openFullscreen) {
          debugPrint('📺 Entering fullscreen');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isFullscreen = true;
              });
            }
          });
        } else if (event.betterPlayerEventType == BetterPlayerEventType.hideFullscreen) {
          debugPrint('📱 Exiting fullscreen');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _isFullscreen = false;
              });
            }
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

  void _startProgressSaveTimer() {
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_controller?.isPlaying() == true) {
        _saveProgressIfNeeded();
      }
    });
  }

  void _saveProgressIfNeeded() {
    if (!mounted || _controller == null) return;
    
    final currentPos = _currentPosition;
    
    // Only save if we've progressed further than last save
    if (currentPos > _lastSavedPosition + 5) {
      debugPrint('💾 Saving progress: $currentPos seconds (was: $_lastSavedPosition)');
      
      final isWatched = currentPos >= widget.lesson.duration * 0.9;
      
      try {
        context.read<CoursesBloc>().add(
          UpdateLessonProgress(
            lessonId: widget.lesson.id,
            watchedTime: currentPos,
            isWatched: isWatched,
            zoomScale: 1.0,
          ),
        );
        
        _lastSavedPosition = currentPos;
      } catch (e) {
        debugPrint('⚠️ Could not save progress (widget disposed): $e');
      }
    }
  }

  void _markAsWatched() {
    if (!mounted || widget.lesson.isWatched) return;
    
    debugPrint('✅ Marking lesson as watched');
    
    try {
      context.read<CoursesBloc>().add(
        UpdateLessonProgress(
          lessonId: widget.lesson.id,
          watchedTime: widget.lesson.duration,
          isWatched: true,
          zoomScale: 1.0,
        ),
      );
    } catch (e) {
      debugPrint('⚠️ Could not mark as watched (widget disposed): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isFullscreen = _isFullscreen;

    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: BetterPlayer(controller: _controller!),
                        ),
                        
                        if (!isFullscreen)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: SafeArea(
                              child: Material(
                                color: Colors.black.withOpacity(0.5),
                                shape: const CircleBorder(),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                                  iconSize: 24,
                                  onPressed: () {
                                    _saveProgressIfNeeded();
                                    widget.onBack();
                                  },
                                ),
                              ),
                            ),
                          ),
                        
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: hasPreviousLesson ? _playPreviousLesson : null,
                                customBorder: const CircleBorder(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.skip_previous,
                                    color: hasPreviousLesson 
                                        ? Colors.white 
                                        : Colors.white.withOpacity(0.3),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: hasNextLesson ? _playNextLesson : null,
                                customBorder: const CircleBorder(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.skip_next,
                                    color: hasNextLesson 
                                        ? Colors.white 
                                        : Colors.white.withOpacity(0.3),
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
      ),
    );
  }


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
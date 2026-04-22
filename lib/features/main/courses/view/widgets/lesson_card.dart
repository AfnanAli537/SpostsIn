import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/generated/l10n.dart';

class LessonCard extends StatefulWidget {
  final LessonModel lesson;
  final bool isEnrolled;
  final bool isCurrentlyPlaying;
  final VoidCallback? onTap;
  final S string; // Added localization

  const LessonCard({
    Key? key,
    required this.lesson,
    required this.isEnrolled,
    required this.isCurrentlyPlaying,
    this.onTap,
    required this.string, // Required localization
  }) : super(key: key);

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPlay = widget.isEnrolled;
    final hasDescription =
        widget.lesson.description != null &&
        widget.lesson.description!.trim().isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: widget.isCurrentlyPlaying
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: widget.lesson.isWatched
              ? theme.colorScheme.primary.withOpacity(0.3)
              : (widget.isCurrentlyPlaying
                    ? theme.colorScheme.primary
                    : Colors.grey[300]!),
          width: widget.isCurrentlyPlaying ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Main card content
          InkWell(
            onTap: canPlay ? widget.onTap : null,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  _buildStatusIcon(theme),
                  SizedBox(width: 16.w),
                  Expanded(child: _buildContent(theme)),
                  !canPlay
                      ? Icon(
                          Icons.lock_outline,
                          size: 20.sp,
                          color: canPlay
                              ? theme.colorScheme.onSurface.withOpacity(0.5)
                              : Colors.grey[400],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),

          if (hasDescription)
            Column(
              children: [
                Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20.sp,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _isExpanded 
                              ? widget.string.hideDescription 
                              : widget.string.showDescription,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Description content (animated)
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: Text(
                      widget.lesson.description!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(ThemeData theme) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: widget.lesson.isWatched
            ? Colors.green.withOpacity(0.2)
            : theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.lesson.isWatched
            ? Icons.check_circle
            : Icons.play_circle_outline,
        color: widget.lesson.isWatched
            ? Colors.green
            : theme.colorScheme.primary,
        size: 32.sp,
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.string.lessonNumber(widget.lesson.order), // Localized
              style: TextStyle(
                fontSize: 12.sp,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.lesson.isWatched) 
              _buildLabel(widget.string.completed, Colors.green),
            if (widget.isCurrentlyPlaying)
              _buildLabel(widget.string.playing, theme.colorScheme.primary),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          widget.lesson.title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(Icons.access_time, size: 14.sp, color: Colors.grey[600]),
            SizedBox(width: 4.w),
            Text(
              _formatDuration(widget.lesson.duration),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            if (widget.lesson.progressPercentage > 0 &&
                !widget.lesson.isWatched) ...[
              SizedBox(width: 16.w),
              Text(
                widget.string.percentageWatched(
                  widget.lesson.progressPercentage.toInt().toString(),
                ), // Localized
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        if (widget.lesson.progressPercentage > 0 &&
            !widget.lesson.isWatched) ...[
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: widget.lesson.progressPercentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            minHeight: 4.h,
          ),
        ],
      ],
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final total = seconds.round();
    if (total < 60) return '${total}s';
    final minutes = total ~/ 60;
    final secs = total % 60;
    if (minutes < 60) return secs > 0 ? '${minutes}m ${secs}s' : '${minutes}m';
    final hours = minutes ~/ 60;
    final remMins = minutes % 60;
    return remMins > 0 ? '${hours}h ${remMins}m' : '${hours}h';
  }
}
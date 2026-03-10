import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';

class OwnerLessonCard extends StatefulWidget {
  final LessonModel lesson;
  final bool isCurrentlyPlaying;
  final VoidCallback? onTap;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final bool showDragHandle;

  const OwnerLessonCard({
    Key? key,
    required this.lesson,
    required this.isCurrentlyPlaying,
    this.onTap,
    required this.onUpdate,
    required this.onDelete,
    this.showDragHandle = false,
  }) : super(key: key);

  @override
  State<OwnerLessonCard> createState() => _OwnerLessonCardState();
}

class _OwnerLessonCardState extends State<OwnerLessonCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDescription = widget.lesson.description != null && 
                          widget.lesson.description!.trim().isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: widget.isCurrentlyPlaying
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: widget.isCurrentlyPlaying
              ? theme.colorScheme.primary
              : Colors.grey[300]!,
          width: widget.isCurrentlyPlaying ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Main card content
          InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
              bottomLeft: hasDescription ? Radius.zero : Radius.circular(12.r),
              bottomRight: hasDescription ? Radius.zero : Radius.circular(12.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  if (widget.showDragHandle) ...[
                    Icon(Icons.drag_handle, color: Colors.grey[600], size: 24.sp),
                    SizedBox(width: 12.w),
                  ],
                  _buildPlayIcon(theme),
                  SizedBox(width: 16.w),
                  Expanded(child: _buildInfo(theme)),
                  _buildPopupMenu(),
                ],
              ),
            ),
          ),

          // ✅ Expandable description section
          if (hasDescription)
            Column(
              children: [
                Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                          _isExpanded ? 'Hide Description' : 'Show Description',
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

  Widget _buildPlayIcon(ThemeData theme) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.play_circle_outline,
        color: theme.colorScheme.primary,
        size: 32.sp,
      ),
    );
  }

  Widget _buildInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lesson ${widget.lesson.order}',
          style: TextStyle(
            fontSize: 12.sp,
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
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
          ],
        ),
      ],
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, size: 20.sp),
      onSelected: (value) {
        if (value == 'update') {
          widget.onUpdate();
        } else if (value == 'delete') {
          widget.onDelete();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'update',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18.sp),
              SizedBox(width: 8.w),
              const Text('Update'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18.sp, color: Colors.red[700]),
              SizedBox(width: 8.w),
              Text('Delete', style: TextStyle(color: Colors.red[700])),
            ],
          ),
        ),
      ],
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
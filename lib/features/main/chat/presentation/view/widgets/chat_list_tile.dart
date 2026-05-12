import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_avatar.dart';

class ChatListTile extends StatelessWidget {
  final ChatModel chat;
  final String timeLabel;

  const ChatListTile({super.key, required this.chat, required this.timeLabel});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasUnread = chat.unreadCount > 0;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ChatAvatar(
            name: chat.title ?? 'Chat',
            imageUrl: chat.groupPhoto,
            size: 50.r,
            showOnline: chat.isOnline,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        chat.title ?? 'Chat',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: hasUnread
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      timeLabel,
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 11.sp,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        chat.lastMessage ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                    if (hasUnread)
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${chat.unreadCount}',
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
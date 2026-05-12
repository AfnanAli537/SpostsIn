import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/utils/helper/date_time_helper.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/presentation/view/chat_view.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_list_tile.dart';
import 'package:sports_in/generated/l10n.dart'; // S

class ChatListSection extends StatelessWidget {
  final List<ChatModel> chats;
  final bool loading;
  final bool loadingMore;

  const ChatListSection({
    super.key,
    required this.chats,
    required this.loading,
    required this.loadingMore,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final s = S.of(context);

    if (loading && chats.isEmpty) {
      return Expanded(
        child: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    if (chats.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            s.noChatsYet,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        itemCount: chats.length + (loadingMore ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, index) {
          if (loadingMore && index == chats.length) {
            return Padding(
              padding: EdgeInsets.all(8.r),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colorScheme.primary,
                ),
              ),
            );
          }

          final chat = chats[index];

          return GestureDetector(
            onTap: () async {
              final sharedPref = SharedPref(
                await SharedPreferences.getInstance(),
              );
              final currentUserId = sharedPref.getUserId()!;
              log('👤 currentUserId: $currentUserId');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ChatBloc>(),
                    child: ChatView(chat: chat, currentUserId: currentUserId),
                  ),
                ),
              );
            },
            child: ChatListTile(
              chat: chat,
              timeLabel: ChatTimeHelper.chatList(chat.lastMessageTime),
            ),
          );
        },
      ),
    );
  }
}
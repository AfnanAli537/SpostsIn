import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/utils/helper/date_time_helper.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/presentation/view/chat_view.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_list_tile.dart';

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
    if (loading && chats.isEmpty) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (chats.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No chats yet', style: TextStyle(color: Colors.grey)),
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
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final chat = chats[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ChatBloc>(),
                    child: ChatView(chat: chat),
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

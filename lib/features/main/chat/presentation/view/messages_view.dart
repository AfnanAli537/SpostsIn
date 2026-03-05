import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/core/utils/helper/date_time_helper.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_list_section.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/contacts_section.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/messages_header.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ChatBloc>();

    /// 1- load the chats
    /// 2- load the contacts
    /// 3- connect to the hub and register the callbacks for the incoming messages
    bloc
      ..add(LoadChatsEvent())
      ..add(LoadContactsEvent())
      ..add(HubConnectEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6FA),
      child: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (p, c) =>
            p.contacts != c.contacts ||
            p.contactsLoading != c.contactsLoading ||
            p.chats != c.chats ||
            p.chatsLoading != c.chatsLoading ||
            p.chatsLoadingMore != c.chatsLoadingMore ||
            p.searchQuery != c.searchQuery ||
            p.searchResult != c.searchResult,
        builder: (context, state) {
          // Decide which chats to show (normal vs search)
          final isSearching = (state.searchQuery ?? '').isNotEmpty;
          final chats = isSearching
              ? state.searchResult
                    .map(
                      (s) => ChatModel(
                        id: s.id,
                        title: s.title,
                        groupPhoto: s.imageUrl,
                        isGroup: s.type.toLowerCase() == 'group',
                        members: const [],
                        lastMessage: null,
                        lastMessageTime: null,
                        unreadCount: 0,
                        isOnline: s.isOnline,
                      ),
                    )
                    .toList()
              : state.chats;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MessagesHeader(
                controller: _searchController,
                onChanged: (v) =>
                    context.read<ChatBloc>().add(SearchChatsEvent(v)),
              ),
              SizedBox(height: 10.h),
              ContactsSection(
                loading: state.contactsLoading,
                contacts: state.contacts,
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Text(
                  isSearching ? "Search results" : "Inbox",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              ChatListSection(
                chats: chats,
                loading: state.chatsLoading,
                loadingMore: state.chatsLoadingMore,
                formatTime: DateTimeHelper.formatShortRelative,
              ),
            ],
          );
        },
      ),
    );
  }
}

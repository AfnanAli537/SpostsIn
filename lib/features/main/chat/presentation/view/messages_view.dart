// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_list_section.dart';
// import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
// import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';
// import 'package:sports_in/features/main/chat/presentation/view/widgets/contacts_section.dart';
// import 'package:sports_in/features/main/chat/presentation/view/widgets/messages_header.dart';
// import 'package:sports_in/features/main/chat/presentation/view/create_group_view.dart';
// import 'package:sports_in/features/main/chat_bot/presentation/view/chat_history_screen.dart';
// import 'package:sports_in/features/main/chat_bot/presentation/view/chatbot_onboarding_screen.dart';
// import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart';

// class MessagesView extends StatefulWidget {
//   const MessagesView({super.key});

//   @override
//   State<MessagesView> createState() => _MessagesViewState();
// }

// class _MessagesViewState extends State<MessagesView> {
//   final _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     final bloc = context.read<ChatBloc>();
//     bloc
//       ..add(LoadChatsEvent())
//       ..add(LoadContactsEvent())
//       ..add(HubConnectEvent());
//   }

//   Future<void> _handleChatbotNavigation() async {
//     final prefs = await SharedPreferences.getInstance();
//     final bool hasSeenOnboarding =
//         prefs.getBool('has_seen_chatbot_onboarding') ?? false;

//     if (!mounted) return;

//     // ✅ Grab the existing ChatbotBloc from the current context BEFORE pushing
//     final chatbotBloc = context.read<ChatbotBloc>();

//     if (hasSeenOnboarding) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => BlocProvider<ChatbotBloc>.value(
//             value: chatbotBloc, // ✅ pass the existing instance, don't create new
//             child: const ChatHistoryScreen(),
//           ),
//         ),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => BlocProvider<ChatbotBloc>.value(
//             value: chatbotBloc, // ✅ onboarding also needs the bloc for the next screen
//             child: const ChatbotOnboardingScreen(),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       floatingActionButton: Padding(
//         padding: EdgeInsets.only(bottom: 90.h),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // FloatingActionButton(
//             //   heroTag: 'chatbot_fab',
//             //   onPressed: _handleChatbotNavigation,
//             //   child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
//             // ),
//             FloatingActionButton(
//   heroTag: 'chatbot_fab',
//   backgroundColor: Colors.grey,
//   onPressed: _handleChatbotNavigation,
//   child: Padding(
//     padding: EdgeInsets.all(6.r),
//     child: Image.asset(
//       'assets/images/chatbot_robot.png',
//       fit: BoxFit.contain,
//     ),
//   ),
// ),
//             SizedBox(height: 12.h),
//             FloatingActionButton(
//               heroTag: 'main_create_group_fab',
//               onPressed: () => showCreateGroupBottomSheet(context),
//               child: const Icon(Icons.add),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         color: const Color(0xFFF4F6FA),
//         child: BlocBuilder<ChatBloc, ChatState>(
//           buildWhen: (p, c) =>
//               p.contacts != c.contacts ||
//               p.contactsLoading != c.contactsLoading ||
//               p.chats != c.chats ||
//               p.chatsLoading != c.chatsLoading ||
//               p.chatsLoadingMore != c.chatsLoadingMore ||
//               p.searchQuery != c.searchQuery ||
//               p.searchResult != c.searchResult ||
//               p.hubConnected != c.hubConnected ||
//               p.hubReconnecting != c.hubReconnecting ||
//               p.hubError != c.hubError,
//           builder: (context, state) {
//             final showHubBanner = !state.hubConnected || state.hubReconnecting;
//             final isSearching = (state.searchQuery ?? '').isNotEmpty;
//             final chats = isSearching
//                 ? state.searchResult
//                     .map(
//                       (s) => ChatModel(
//                         id: s.id,
//                         title: s.title,
//                         groupPhoto: s.imageUrl,
//                         isGroup: s.type.toLowerCase() == 'group',
//                         members: const [],
//                         lastMessage: null,
//                         lastMessageTime: null,
//                         unreadCount: 0,
//                         isOnline: s.isOnline,
//                       ),
//                     )
//                     .toList()
//                 : state.chats;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (showHubBanner) _SignalRStatusBanner(state: state),
//                 MessagesHeader(
//                   controller: _searchController,
//                   onChanged: (v) =>
//                       context.read<ChatBloc>().add(SearchChatsEvent(v)),
//                 ),
//                 SizedBox(height: 10.h),
//                 ContactsSection(
//                   loading: state.contactsLoading,
//                   contacts: state.contacts,
//                 ),
//                 SizedBox(height: 10.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 18.w),
//                   child: Text(
//                     isSearching ? "Search results" : "Inbox",
//                     style: TextStyle(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 ChatListSection(
//                   chats: chats,
//                   loading: state.chatsLoading,
//                   loadingMore: state.chatsLoadingMore,
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class _SignalRStatusBanner extends StatelessWidget {
//   const _SignalRStatusBanner({required this.state});
//   final ChatState state;

//   @override
//   Widget build(BuildContext context) {
//     final isReconnecting = state.hubReconnecting;
//     final hasError = (state.hubError ?? '').isNotEmpty;

//     return Material(
//       color: isReconnecting
//           ? Colors.orange.shade100
//           : (hasError ? Colors.red.shade100 : Colors.orange.shade100),
//       child: SafeArea(
//         bottom: false,
//         child: InkWell(
//           onTap: () {
//             if (!isReconnecting) {
//               context.read<ChatBloc>().add(HubConnectEvent());
//             }
//           },
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//             child: Row(
//               children: [
//                 if (isReconnecting)
//                   SizedBox(
//                     width: 18.w,
//                     height: 18.h,
//                     child: const CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 else
//                   Icon(
//                     hasError ? Icons.cloud_off_rounded : Icons.wifi_off_rounded,
//                     size: 20.sp,
//                     color: hasError
//                         ? Colors.red.shade800
//                         : Colors.orange.shade800,
//                   ),
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: Text(
//                     isReconnecting
//                         ? 'Reconnecting…'
//                         : (hasError
//                             ? 'Connection failed. Tap to retry'
//                             : 'Disconnected. Tap to reconnect'),
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       color: hasError
//                           ? Colors.red.shade900
//                           : Colors.orange.shade900,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 if (!isReconnecting)
//                   Text(
//                     'Retry',
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.w600,
//                       color: hasError
//                           ? Colors.red.shade800
//                           : Colors.orange.shade800,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_list_section.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/contacts_section.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/messages_header.dart';
import 'package:sports_in/features/main/chat/presentation/view/create_group_view.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view/chat_history_screen.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view/chatbot_onboarding_screen.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart';
import 'package:sports_in/generated/l10n.dart'; // S

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
    bloc
      ..add(LoadChatsEvent())
      ..add(LoadContactsEvent())
      ..add(HubConnectEvent());
  }

  Future<void> _handleChatbotNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding =
        prefs.getBool('has_seen_chatbot_onboarding') ?? false;

    if (!mounted) return;

    final chatbotBloc = context.read<ChatbotBloc>();

    if (hasSeenOnboarding) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider<ChatbotBloc>.value(
            value: chatbotBloc,
            child: const ChatHistoryScreen(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider<ChatbotBloc>.value(
            value: chatbotBloc,
            child: const ChatbotOnboardingScreen(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return  Scaffold(
      
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 90.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'chatbot_fab',
                  backgroundColor: Colors.grey ,
                  onPressed: _handleChatbotNavigation,
                  child: Padding(
                    padding: EdgeInsets.all(6.r),
                    child: Image.asset(
                      'assets/images/chatbot_robot.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                FloatingActionButton(
                  heroTag: 'main_create_group_fab',
                  backgroundColor: colorScheme.primary,
                  onPressed: () => showCreateGroupBottomSheet(context),
                  child: Icon(Icons.add, color: colorScheme.onPrimary),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          color: colorScheme.background,
          child: BlocBuilder<ChatBloc, ChatState>(
            buildWhen: (p, c) =>
                p.contacts != c.contacts ||
                p.contactsLoading != c.contactsLoading ||
                p.chats != c.chats ||
                p.chatsLoading != c.chatsLoading ||
                p.chatsLoadingMore != c.chatsLoadingMore ||
                p.searchQuery != c.searchQuery ||
                p.searchResult != c.searchResult ||
                p.hubConnected != c.hubConnected ||
                p.hubReconnecting != c.hubReconnecting ||
                p.hubError != c.hubError,
            builder: (context, state) {
              final s = S.of(context);
              final showHubBanner = !state.hubConnected || state.hubReconnecting;
              final isSearching = (state.searchQuery ?? '').isNotEmpty;
              final chats = isSearching
                  ? state.searchResult
                      .map(
                        (sr) => ChatModel(
                          id: sr.id,
                          title: sr.title,
                          groupPhoto: sr.imageUrl,
                          isGroup: sr.type.toLowerCase() == 'group',
                          members: const [],
                          lastMessage: null,
                          lastMessageTime: null,
                          unreadCount: 0,
                          isOnline: sr.isOnline,
                        ),
                      )
                      .toList()
                  : state.chats;
      
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHubBanner) _SignalRStatusBanner(state: state),
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
                      isSearching ? s.searchResults : s.inbox,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ChatListSection(
                    chats: chats,
                    loading: state.chatsLoading,
                    loadingMore: state.chatsLoadingMore,
                  ),
                ],
              );
            },
          ),
        ),
      );
  }
}

class _SignalRStatusBanner extends StatelessWidget {
  const _SignalRStatusBanner({required this.state});
  final ChatState state;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isReconnecting = state.hubReconnecting;
    final hasError = (state.hubError ?? '').isNotEmpty;

    final bannerColor = hasError
        ? colorScheme.errorContainer
        : Colors.orange.shade100;
    final contentColor = hasError
        ? colorScheme.onErrorContainer
        : Colors.orange.shade900;
    final iconColor = hasError
        ? colorScheme.error
        : Colors.orange.shade800;

    return Material(
      color: isReconnecting ? Colors.orange.shade100 : bannerColor,
      child: SafeArea(
        bottom: false,
        child: InkWell(
          onTap: () {
            if (!isReconnecting) {
              context.read<ChatBloc>().add(HubConnectEvent());
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                if (isReconnecting)
                  SizedBox(
                    width: 18.w,
                    height: 18.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: iconColor,
                    ),
                  )
                else
                  Icon(
                    hasError
                        ? Icons.cloud_off_rounded
                        : Icons.wifi_off_rounded,
                    size: 20.sp,
                    color: iconColor,
                  ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    isReconnecting
                        ? s.reconnecting
                        : (hasError ? s.connectionFailed : s.disconnected),
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 13.sp,
                      color: contentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (!isReconnecting)
                  Text(
                    s.retry,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
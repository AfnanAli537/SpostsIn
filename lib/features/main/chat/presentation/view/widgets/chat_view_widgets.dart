// part of '../chat_view.dart';

// class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const _ChatAppBar({required this.chat});

//   final ChatModel chat;

//   /// True if [typingInfo] applies to this chat (1:1 = other user; group = member).
//   bool _isTypingInThisChat(ChatModel c, TypingInfo? typing) {
//     if (typing == null || !typing.isTyping) return false;
//     if (c.isGroup) {
//       return c.members.any((m) => m.userId == typing.userId);
//     }
//     return c.id == typing.userId;
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChatBloc, ChatState>(
//       buildWhen: (p, c) => p.typingInfo != c.typingInfo || p.chats != c.chats,
//       builder: (context, state) {
//         // Use live chat from state for isOnline (updates when hub sends UserStatusChanged)
//         ChatModel? liveChat;
//         try {
//           liveChat = state.chats.firstWhere((c) => c.id == chat.id);
//         } catch (_) {}
//         final isOnline = !chat.isGroup && (liveChat?.isOnline ?? chat.isOnline);

//         return AppBar(
//           backgroundColor: const Color(0xFFF4F6FA),
//           elevation: 0,
//           surfaceTintColor: Colors.transparent,
//           leadingWidth: 40,
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios_rounded,
//               size: 18,
//               color: Colors.black87,
//             ),
//             onPressed: () => Navigator.pop(context),
//           ),
//           titleSpacing: 0,
//           title: Row(
//             children: [
//               ChatAvatar(
//                 imageUrl: chat.groupPhoto,
//                 name: chat.title ?? 'Chat',
//                 size: 38,
//                 showOnline: isOnline,
//               ),
//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     chat.title ?? 'Chat',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   BlocBuilder<ChatBloc, ChatState>(
//                     buildWhen: (p, c) => p.typingInfo != c.typingInfo,
//                     builder: (_, s) {
//                       if (_isTypingInThisChat(chat, s.typingInfo)) {
//                         return const Text(
//                           'typing...',
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.blue,
//                             fontStyle: FontStyle.italic,
//                           ),
//                         );
//                       }
//                       if (!chat.isGroup && isOnline) {
//                         return const Text(
//                           'Online',
//                           style: TextStyle(
//                             fontSize: 11,
//                             color: Colors.green,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         );
//                       }
//                       return const SizedBox.shrink();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           bottom: const PreferredSize(
//             preferredSize: Size.fromHeight(1),
//             child: ColoredBox(
//               color: Color(0xFFE0E4EE),
//               child: SizedBox(height: 1),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _TypingIndicator extends StatelessWidget {
//   const _TypingIndicator({required this.userName});

//   final String userName;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, bottom: 4),
//       child: Text(
//         '$userName is typing...',
//         style: const TextStyle(
//           fontSize: 12,
//           color: Colors.blue,
//           fontStyle: FontStyle.italic,
//         ),
//       ),
//     );
//   }
// }

// class _MessageBubble extends StatelessWidget {
//   const _MessageBubble({
//     required this.message,
//     required this.currentUserId,
//     required this.isGroupChat,
//     required this.isEditing,
//     required this.editController,
//     required this.onLongPress,
//     required this.onSaveEdit,
//     required this.onCancelEdit,
//     required this.timeText,
//   });

//   final MessageModel message;
//   final String currentUserId;
//   final bool isGroupChat;
//   final bool isEditing;
//   final TextEditingController editController;
//   final VoidCallback? onLongPress;
//   final VoidCallback onSaveEdit;
//   final VoidCallback onCancelEdit;
//   final String timeText;

//   @override
//   Widget build(BuildContext context) {
//     final isMe = message.senderId == currentUserId;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         mainAxisAlignment: isMe
//             ? MainAxisAlignment.end
//             : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           if (!isMe) ...[
//             ChatAvatar(
//               imageUrl: message.senderAvatar,
//               name: message.senderName.isNotEmpty ? message.senderName : 'User',
//               size: 28,
//             ),
//             const SizedBox(width: 8),
//           ],
//           Flexible(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.72,
//               ),
//               child: isEditing
//                   ? _EditMessageBubble(
//                       controller: editController,
//                       onSave: onSaveEdit,
//                       onCancel: onCancelEdit,
//                     )
//                   : _NormalMessageBubble(
//                       message: message,
//                       isGroupChat: isGroupChat,
//                       isMe: isMe,
//                       timeText: timeText,
//                       onLongPress: onLongPress,
//                     ),
//             ),
//           ),
//           if (isMe) const SizedBox(width: 4),
//         ],
//       ),
//     );
//   }
// }

// class _NormalMessageBubble extends StatelessWidget {
//   const _NormalMessageBubble({
//     required this.message,
//     required this.isGroupChat,
//     required this.isMe,
//     required this.timeText,
//     required this.onLongPress,
//   });

//   final MessageModel message;
//   final bool isGroupChat;
//   final bool isMe;
//   final String timeText;
//   final VoidCallback? onLongPress;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPress: onLongPress,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           gradient: isMe
//               ? const LinearGradient(
//                   colors: [Color(0xFF2E5BFF), Color(0xFF3B3DBF)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 )
//               : null,
//           color: isMe ? null : Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(18),
//             topRight: const Radius.circular(18),
//             bottomLeft: Radius.circular(isMe ? 18 : 4),
//             bottomRight: Radius.circular(isMe ? 4 : 18),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: isMe
//                   ? const Color(0xFF2E5BFF).withOpacity(0.25)
//                   : Colors.black.withOpacity(0.06),
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             if (isGroupChat && !isMe)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 child: Text(
//                   message.senderName,
//                   style: const TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             Text(
//               message.content,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isMe ? Colors.white : Colors.black87,
//                 height: 1.45,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (message.isEdited)
//                   Text(
//                     'edited ',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: isMe ? Colors.white60 : Colors.grey,
//                     ),
//                   ),
//                 Text(
//                   timeText,
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: isMe ? Colors.white70 : Colors.grey,
//                   ),
//                 ),
//                 if (isMe) ...[
//                   const SizedBox(width: 3),
//                   _buildStatusIcon(message),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Message status from bloc/hub; updated by [ChatBloc._onHubMessageStatusChanged] (single message)
//   /// and [ChatBloc._onHubConversationSeen] (all my messages seen). Status: 1 → one check (white),
//   /// 2 → two checks (white), 3 → two checks (blue/seen), default → one check. Icon size centralized below.
//   Widget _buildStatusIcon(MessageModel message) {
//     const double kStatusIconSize = 14.0;
//     final status = message.status ?? 1;

//     switch (status) {
//       case 1: // sent
//         return Icon(
//           Icons.check_rounded,
//           size: kStatusIconSize,
//           color: Colors.white70,
//         );
//       case 2: // delivered
//         return Icon(
//           Icons.done_all_rounded,
//           size: kStatusIconSize,
//           color: Colors.white70,
//         );
//       case 3: // seen
//         return const Icon(
//           Icons.done_all_rounded,
//           size: kStatusIconSize,
//           color: Colors.lightBlueAccent,
//         );
//       default:
//         return Icon(
//           Icons.check_rounded,
//           size: kStatusIconSize,
//           color: Colors.white70,
//         );
//     }
//   }
// }

// class _EditMessageBubble extends StatelessWidget {
//   const _EditMessageBubble({
//     required this.controller,
//     required this.onSave,
//     required this.onCancel,
//   });

//   final TextEditingController controller;
//   final VoidCallback onSave;
//   final VoidCallback onCancel;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: controller,
//             autofocus: true,
//             style: const TextStyle(fontSize: 14, color: Colors.black87),
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 14,
//                 vertical: 10,
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: Colors.blue, width: 1.5),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(14),
//                 borderSide: const BorderSide(color: Colors.blue, width: 2),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         GestureDetector(
//           onTap: onSave,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Text(
//               'Save',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 6),
//         GestureDetector(
//           onTap: onCancel,
//           child: Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFFEEF0F5),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.close_rounded,
//               size: 14,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _MessageInputBar extends StatelessWidget {
//   const _MessageInputBar({
//     required this.controller,
//     required this.isSending,
//     required this.onChanged,
//     required this.onSend,
//   });

//   final TextEditingController controller;
//   final bool isSending;
//   final ValueChanged<String> onChanged;
//   final VoidCallback onSend;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         border: Border(top: BorderSide(color: Color(0xFFEEF0F5))),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: controller,
//               onChanged: onChanged,
//               onSubmitted: (_) => onSend(),
//               style: const TextStyle(fontSize: 14, color: Colors.black87),
//               decoration: InputDecoration(
//                 hintText: 'Type a message...',
//                 hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
//                 filled: true,
//                 fillColor: const Color(0xFFF7F8FC),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 11,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: const BorderSide(color: Color(0xFFEEF0F5)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: const BorderSide(color: Colors.blue, width: 1.5),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 4),
//           ValueListenableBuilder<TextEditingValue>(
//             valueListenable: controller,
//             builder: (_, value, __) {
//               final hasText = value.text.trim().isNotEmpty;

//               return GestureDetector(
//                 onTap: isSending ? null : onSend,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: hasText
//                         ? const LinearGradient(
//                             colors: [Color(0xFF2E5BFF), Color(0xFF3B3DBF)],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           )
//                         : null,
//                     color: hasText ? null : const Color(0xFFEEF0F5),
//                     boxShadow: hasText
//                         ? [
//                             BoxShadow(
//                               color: const Color(0xFF2E5BFF).withOpacity(0.35),
//                               blurRadius: 10,
//                               offset: const Offset(0, 4),
//                             ),
//                           ]
//                         : null,
//                   ),
//                   child: isSending
//                       ? const Padding(
//                           padding: EdgeInsets.all(12),
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : Icon(
//                           Icons.send_rounded,
//                           size: 18,
//                           color: hasText ? Colors.white : Colors.grey,
//                         ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _OptionTile extends StatelessWidget {
//   const _OptionTile({
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Row(
//           children: [
//             Icon(icon, color: color, size: 20),
//             const SizedBox(width: 14),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// SignalR connection banner shown at top of chat when disconnected or reconnecting.
// class _ChatSignalRBanner extends StatelessWidget {
//   const _ChatSignalRBanner({required this.hubReconnecting, this.hubError});

//   final bool hubReconnecting;
//   final String? hubError;

//   @override
//   Widget build(BuildContext context) {
//     final hasError = (hubError ?? '').isNotEmpty;

//     return Material(
//       color: hubReconnecting
//           ? Colors.orange.shade100
//           : (hasError ? Colors.red.shade100 : Colors.orange.shade100),
//       child: InkWell(
//         onTap: () {
//           if (!hubReconnecting) {
//             context.read<ChatBloc>().add(HubConnectEvent());
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//           child: Row(
//             children: [
//               if (hubReconnecting)
//                 const SizedBox(
//                   width: 18,
//                   height: 18,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               else
//                 Icon(
//                   hasError ? Icons.cloud_off_rounded : Icons.wifi_off_rounded,
//                   size: 20,
//                   color: hasError
//                       ? Colors.red.shade800
//                       : Colors.orange.shade800,
//                 ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   hubReconnecting
//                       ? 'Reconnecting…'
//                       : (hasError
//                             ? 'Connection failed. Tap to retry'
//                             : 'Disconnected. Tap to reconnect'),
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: hasError
//                         ? Colors.red.shade900
//                         : Colors.orange.shade900,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               if (!hubReconnecting)
//                 Text(
//                   'Retry',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: hasError
//                         ? Colors.red.shade800
//                         : Colors.orange.shade800,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



part of '../chat_view.dart';

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppBar({required this.chat});

  final ChatModel chat;

  bool _isTypingInThisChat(ChatModel c, TypingInfo? typing) {
    if (typing == null || !typing.isTyping) return false;
    if (c.isGroup) return c.members.any((m) => m.userId == typing.userId);
    return c.id == typing.userId;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final s = S.of(context);

    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (p, c) => p.typingInfo != c.typingInfo || p.chats != c.chats,
      builder: (context, state) {
        ChatModel? liveChat;
        try {
          liveChat = state.chats.firstWhere((c) => c.id == chat.id);
        } catch (_) {}
        final isOnline = !chat.isGroup && (liveChat?.isOnline ?? chat.isOnline);

        return AppBar(
          backgroundColor: colorScheme.surface,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leadingWidth: 40,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 18.sp,
              color: colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              ChatAvatar(
                imageUrl: chat.groupPhoto,
                name: chat.title ?? s.chat,
                size: 38.r,
                showOnline: isOnline,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.title ?? s.chat,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  BlocBuilder<ChatBloc, ChatState>(
                    buildWhen: (p, c) => p.typingInfo != c.typingInfo,
                    builder: (_, st) {
                      if (_isTypingInThisChat(chat, st.typingInfo)) {
                        return Text(
                          s.typing,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colorScheme.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }
                      if (!chat.isGroup && isOnline) {
                        return Text(
                          s.online,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: ColoredBox(
              color: colorScheme.outlineVariant,
              child: SizedBox(height: 1.h),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Padding(
      padding: EdgeInsets.only(left: 20.w, bottom: 4.h),
      child: Text(
        s.typingWithName(userName),
        style: TextStyle(
          fontSize: 12.sp,
          color: colorScheme.primary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.currentUserId,
    required this.isGroupChat,
    required this.isEditing,
    required this.editController,
    required this.onLongPress,
    required this.onSaveEdit,
    required this.onCancelEdit,
    required this.timeText,
  });

  final MessageModel message;
  final String currentUserId;
  final bool isGroupChat;
  final bool isEditing;
  final TextEditingController editController;
  final VoidCallback? onLongPress;
  final VoidCallback onSaveEdit;
  final VoidCallback onCancelEdit;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == currentUserId;

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            ChatAvatar(
              imageUrl: message.senderAvatar,
              name:
                  message.senderName.isNotEmpty ? message.senderName : 'User',
              size: 28.r,
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              child: isEditing
                  ? _EditMessageBubble(
                      controller: editController,
                      onSave: onSaveEdit,
                      onCancel: onCancelEdit,
                    )
                  : _NormalMessageBubble(
                      message: message,
                      isGroupChat: isGroupChat,
                      isMe: isMe,
                      timeText: timeText,
                      onLongPress: onLongPress,
                    ),
            ),
          ),
          if (isMe) SizedBox(width: 4.w),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _NormalMessageBubble extends StatelessWidget {
  const _NormalMessageBubble({
    required this.message,
    required this.isGroupChat,
    required this.isMe,
    required this.timeText,
    required this.onLongPress,
  });

  final MessageModel message;
  final bool isGroupChat;
  final bool isMe;
  final String timeText;
  final VoidCallback? onLongPress;

  Widget _buildStatusIcon(MessageModel msg, ColorScheme colorScheme) {
    const double kStatusIconSize = 14.0;
    final status = msg.status ?? 1;

    switch (status) {
      case 1:
        return Icon(
          Icons.check_rounded,
          size: kStatusIconSize,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
      case 2:
        return Icon(
          Icons.done_all_rounded,
          size: kStatusIconSize,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
      case 3:
        return Icon(
          Icons.done_all_rounded,
          size: kStatusIconSize,
          color: Colors.lightBlueAccent,
        );
      default:
        return Icon(
          Icons.check_rounded,
          size: kStatusIconSize,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final s = S.of(context);

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: isMe
              ? LinearGradient(
                  colors: [
                    colorScheme.primary,
                    Colors.grey.withOpacity(0.9)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMe ? null : colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
            bottomRight: Radius.circular(isMe ? 4.r : 18.r),
          ),
          boxShadow: [
            BoxShadow(
              color: isMe
                  ? colorScheme.primary.withOpacity(0.25)
                  : colorScheme.onSurface.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isGroupChat && !isMe)
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            Text(
              message.content,
              style: textTheme.bodyMedium?.copyWith(
                color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
                height: 1.45,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.isEdited)
                  Text(
                    '${s.edited} ',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isMe
                          ? colorScheme.onPrimary.withOpacity(0.8)
                          : colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                Text(
                  timeText,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isMe
                        ? colorScheme.onPrimary.withOpacity(0.7)
                        : colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                if (isMe) ...[
                  SizedBox(width: 3.w),
                  _buildStatusIcon(message, colorScheme),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _EditMessageBubble extends StatelessWidget {
  const _EditMessageBubble({
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(
              fontSize: 14.sp,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 10.h,
              ),
              filled: true,
              fillColor: colorScheme.surface,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 1.5.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2.w,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: onSave,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              s.edit,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        GestureDetector(
          onTap: onCancel,
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.close_rounded,
              size: 14.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MessageInputBar extends StatelessWidget {
  const _MessageInputBar({
    required this.controller,
    required this.isSending,
    required this.onChanged,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isSending;
  final ValueChanged<String> onChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        // border: Border(
        //   top: BorderSide(color: colorScheme.outlineVariant),
        // ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
              onSubmitted: (_) => onSend(),
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: s.typeAMessage,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurface,
                ),
                filled: true,
              
                fillColor: colorScheme.surfaceVariant.withOpacity(0.4),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 11.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.5.w,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              final hasText = value.text.trim().isNotEmpty;

              return GestureDetector(
                onTap: isSending ? null : onSend,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: hasText
                        ? LinearGradient(
                            colors: [
                              colorScheme.primary,
                             Colors.grey.withOpacity(0.5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: hasText ? null : colorScheme.surfaceVariant,
                    boxShadow: hasText
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: isSending
                      ? Padding(
                          padding: EdgeInsets.all(12.r),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 18.sp,
                          color: hasText
                              ? colorScheme.onPrimary
                              : colorScheme.onError,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20.sp),
            SizedBox(width: 14.w),
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ChatSignalRBanner extends StatelessWidget {
  const _ChatSignalRBanner({required this.hubReconnecting, this.hubError});

  final bool hubReconnecting;
  final String? hubError;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final s = S.of(context);
    final hasError = (hubError ?? '').isNotEmpty;

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
      color: hubReconnecting ? Colors.orange.shade100 : bannerColor,
      child: InkWell(
        onTap: () {
          if (!hubReconnecting) {
            context.read<ChatBloc>().add(HubConnectEvent());
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Row(
            children: [
              if (hubReconnecting)
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
                  hubReconnecting
                      ? s.reconnecting
                      : (hasError ? s.connectionFailed : s.disconnected),
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    color: contentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (!hubReconnecting)
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
    );
  }
}
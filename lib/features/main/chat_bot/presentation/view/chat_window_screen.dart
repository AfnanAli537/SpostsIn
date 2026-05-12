import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view/widgets/chat_bubble.dart';
import 'package:sports_in/generated/l10n.dart';

class ChatWindowScreen extends StatefulWidget {
  const ChatWindowScreen({super.key});

  static const routeName = '/chat-window';

  @override
  State<ChatWindowScreen> createState() => _ChatWindowScreenState();
}

class _ChatWindowScreenState extends State<ChatWindowScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String sessionId) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<ChatbotBloc>().add(
          SendMessageEvent(question: text, sessionId: sessionId),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          // backgroundColor: Colors.white,
          elevation: 0.5,
          // leading: const BackButton(color: Color(0xFF1A1A2E)),
          leading:  BackButton(color:  Theme.of(context).colorScheme.primary),
      
          title: Row(
            children: [
              Image.asset(
                'assets/images/chatbot_robot.png',
                width: 36.w,
                height: 36.h,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).sportsinTitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      // color: const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    S.of(context).onlineStatus,
                    style: TextStyle(
                      color: const Color(0xFF4CAF50),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: BlocConsumer<ChatbotBloc, ChatbotState>(
          listener: (context, state) {
            if (state is SendingMessage || state is MessageSent) {
              _scrollToBottom();
            }
            if (state is SendingMessage) {
              setState(() => _isSending = true);
            } else {
              setState(() => _isSending = false);
            }
            if (state is SendMessageError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            List<ChatMessage> messages = [];
            String sessionId = context.read<ChatbotBloc>().currentSessionId;
      
            if (state is MessagesLoaded) {
              messages = state.messages;
              sessionId = state.sessionId;
            } else if (state is SendingMessage) {
              messages = state.messages;
            } else if (state is MessageSent) {
              messages = state.messages;
              sessionId = state.sessionId;
            } else if (state is SendMessageError) {
              messages = state.messages;
            }
      
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty && state is MessagesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : messages.isEmpty
                          ? Center(
                              child: Text(
                                S.of(context).sayHello,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.sp,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              itemCount: messages.length + (_isSending ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == messages.length && _isSending) {
                                  return const _TypingIndicator();
                                }
                                final msg = messages[index];
                                return ChatBubble(message: msg);
                              },
                            ),
                ),
                _InputBar(
                  controller: _controller,
                  isSending: _isSending,
                  onSend: () => _sendMessage(sessionId),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 12.w, 24.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: S.of(context).writeMessageHint,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                filled: true,
                // fillColor: const Color(0xFFF5F7FA),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: isSending ? null : onSend,
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: isSending ? Colors.grey : Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h, right: 60.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SizedBox(
          width: 40.w,
          child: const LinearProgressIndicator(
            backgroundColor: Color(0xFFE0E0E0),
            color: Color(0xFF1A1A2E),
          ),
        ),
      ),
    );
  }
}
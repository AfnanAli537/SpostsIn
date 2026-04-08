import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view/widgets/chat_bubble.dart';


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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Color(0xFF1A1A2E)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF1A1A2E),
              child: const Text(
                'S',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'SportsIn',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '● Online',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        // actions: const [
        //   Icon(Icons.more_horiz, color: Color(0xFF1A1A2E)),
        //   SizedBox(width: 12),
        // ],
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
              // ─── Messages List ─────────────────────────────────────────
              Expanded(
                child: messages.isEmpty && state is MessagesLoading
                    ? const Center(child: CircularProgressIndicator())
                    : messages.isEmpty
                        ? const Center(
                            child: Text(
                              'Say hello to SportsIn! 👋',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            itemCount: messages.length +
                                (_isSending ? 1 : 0), // +1 for typing indicator
                            itemBuilder: (context, index) {
                              if (index == messages.length && _isSending) {
                                return const _TypingIndicator();
                              }
                              final msg = messages[index];
                              return ChatBubble(message: msg);
                            },
                          ),
              ),

              // ─── Input Bar ─────────────────────────────────────────────
              _InputBar(
                controller: _controller,
                isSending: _isSending,
                onSend: () => _sendMessage(sessionId),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Input Bar ────────────────────────────────────────────────────────────────
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
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 24),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Write your message',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF5F7FA),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isSending ? null : onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSending ? Colors.grey : const Color(0xFF1A1A2E),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Typing Indicator ─────────────────────────────────────────────────────────
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 60),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: const SizedBox(
          width: 40,
          child: LinearProgressIndicator(
            backgroundColor: Color(0xFFE0E0E0),
            color: Color(0xFF1A1A2E),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';
import 'package:sports_in/features/main/chat_bot/presentation/chat_window_screen.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart';
import 'package:sports_in/features/main/chat_bot/presentation/widgets/session_tile.dart';


class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  static const routeName = '/chat-history';

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatbotBloc>().add(LoadSessionsEvent());
  }

  void _openChat(BuildContext context, {String sessionId = ''}) {
    if (sessionId.isNotEmpty) {
      context.read<ChatbotBloc>().add(SelectSessionEvent(sessionId: sessionId));
    } else {
      context.read<ChatbotBloc>().add(StartNewChatEvent());
    }
    Navigator.pushNamed(context, ChatWindowScreen.routeName,
        arguments: sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1A1A2E)),
        title: const Text(
          'SportsIn',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<ChatbotBloc, ChatbotState>(
        listener: (context, state) {
          if (state is SessionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is SessionDeleted || state is SessionRenamed) {
            // Sessions already refreshed in bloc
          }
        },
        builder: (context, state) {
          if (state is SessionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ChatSession> sessions = [];
          if (state is SessionsLoaded) sessions = state.sessions;
          if (state is SessionDeleted) sessions = state.sessions;
          if (state is SessionRenamed) sessions = state.sessions;

          // Split into active (last 24h) and ended
          final now = DateTime.now();
          final active = sessions
              .where((s) => now.difference(s.createdAt).inHours < 24)
              .toList();
          final ended = sessions
              .where((s) => now.difference(s.createdAt).inHours >= 24)
              .toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              if (active.isNotEmpty) ...[
                _SectionLabel(label: 'Active Chats'),
                const SizedBox(height: 8),
                ...active.map((s) => SessionTile(
                      session: s,
                      onTap: () => _openChat(context, sessionId: s.sessionId),
                      onDelete: () => context.read<ChatbotBloc>().add(
                            DeleteSessionEvent(sessionId: s.sessionId),
                          ),
                      onRename: (name) => context.read<ChatbotBloc>().add(
                            RenameSessionEvent(
                                sessionId: s.sessionId, newName: name),
                          ),
                    )),
                const SizedBox(height: 16),
              ],
              if (ended.isNotEmpty) ...[
                _SectionLabel(label: 'Ended Chats'),
                const SizedBox(height: 8),
                ...ended.map((s) => SessionTile(
                      session: s,
                      onTap: () => _openChat(context, sessionId: s.sessionId),
                      onDelete: () => context.read<ChatbotBloc>().add(
                            DeleteSessionEvent(sessionId: s.sessionId),
                          ),
                      onRename: (name) => context.read<ChatbotBloc>().add(
                            RenameSessionEvent(
                                sessionId: s.sessionId, newName: name),
                          ),
                    )),
                const SizedBox(height: 16),
              ],
              if (sessions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Text(
                      'No chats yet.\nStart a new conversation!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      // ─── Bottom Button ───────────────────────────────────────────────────
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () => _openChat(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A2E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Start Another Chat With SportsIn',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 0.4,
      ),
    );
  }
}
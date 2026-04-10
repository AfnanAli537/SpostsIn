import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view/chat_window_screen.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view/widgets/session_tile.dart';
import 'package:sports_in/generated/l10n.dart';

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
    _loadSessions();
  }

  void _loadSessions() {
    context.read<ChatbotBloc>().add(LoadSessionsEvent());
  }

  void _openChat(BuildContext context, {String sessionId = ''}) {
    if (sessionId.isNotEmpty) {
      context.read<ChatbotBloc>().add(SelectSessionEvent(sessionId: sessionId));
    } else {
      context.read<ChatbotBloc>().add(StartNewChatEvent());
    }

    final chatbotBloc = context.read<ChatbotBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<ChatbotBloc>.value(
          value: chatbotBloc,
          child: const ChatWindowScreen(),
        ),
      ),
    ).then((_) {
      if (mounted) _loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        // backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        // leading: const BackButton(color: Color(0xFF1A1A2E)),
        leading:  BackButton(color: Theme.of(context).colorScheme.primary),

        title: Row(
          children: [
            Image.asset(
              'assets/images/chatbot_robot.png',
              width: 36.w,
              height: 36.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8.w),
            Text(
              S.of(context).sportsinTitle,
              style: TextStyle(
                // color: const Color(0xFF1A1A2E),
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ],
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
        },
        buildWhen: (_, current) =>
            current is SessionsLoading ||
            current is SessionsLoaded ||
            current is SessionDeleted ||
            current is SessionRenamed ||
            current is SessionsError,
        builder: (context, state) {
          if (state is SessionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ChatSession> sessions = [];
          if (state is SessionsLoaded) sessions = state.sessions;
          if (state is SessionDeleted) sessions = state.sessions;
          if (state is SessionRenamed) sessions = state.sessions;

          final now = DateTime.now();
          final active = sessions
              .where((s) => now.difference(s.createdAt).inHours < 24)
              .toList();
          final ended = sessions
              .where((s) => now.difference(s.createdAt).inHours >= 24)
              .toList();

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            children: [
              if (active.isNotEmpty) ...[
                _SectionLabel(label: S.of(context).activeChats),
                SizedBox(height: 8.h),
                ...active.map((s) => SessionTile(
                      session: s,
                      onTap: () => _openChat(context, sessionId: s.sessionId),
                      onDelete: () => context
                          .read<ChatbotBloc>()
                          .add(DeleteSessionEvent(sessionId: s.sessionId)),
                      onRename: (name) => context.read<ChatbotBloc>().add(
                            RenameSessionEvent(
                                sessionId: s.sessionId, newName: name),
                          ),
                    )),
                SizedBox(height: 16.h),
              ],
              if (ended.isNotEmpty) ...[
                _SectionLabel(label: S.of(context).endedChats),
                SizedBox(height: 8.h),
                ...ended.map((s) => SessionTile(
                      session: s,
                      onTap: () => _openChat(context, sessionId: s.sessionId),
                      onDelete: () => context
                          .read<ChatbotBloc>()
                          .add(DeleteSessionEvent(sessionId: s.sessionId)),
                      onRename: (name) => context.read<ChatbotBloc>().add(
                            RenameSessionEvent(
                                sessionId: s.sessionId, newName: name),
                          ),
                    )),
                SizedBox(height: 16.h),
              ],
              if (sessions.isEmpty && state is SessionsLoaded)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: Text(
                      S.of(context).noChatsYet,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
        child: SizedBox(
          height: 52.h,
          child: ElevatedButton(
            onPressed: () => _openChat(context),
            style: ElevatedButton.styleFrom(
              // backgroundColor: const Color(0xFF1A1A2E),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor:  Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
            child: Text(
              S.of(context).startAnotherChat,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp),
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
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 0.4,
      ),
    );
  }
}
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:injectable/injectable.dart';
// import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';
// import 'package:sports_in/features/main/chat_bot/data/repo/chatbot_repo.dart';

// part 'chatbot_event.dart';
// part 'chatbot_state.dart';


// @injectable
// class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
//   final ChatbotRepository _repository;

//   /// Local cache of messages for the current open session
//   final List<ChatMessage> _currentMessages = [];
//   String _currentSessionId = '';

//   ChatbotBloc({required ChatbotRepository repository})
//       : _repository = repository,
//         super(ChatbotInitial()) {
//     on<LoadSessionsEvent>(_onLoadSessions);
//     on<SelectSessionEvent>(_onSelectSession);
//     on<DeleteSessionEvent>(_onDeleteSession);
//     on<RenameSessionEvent>(_onRenameSession);
//     on<LoadMessagesEvent>(_onLoadMessages);
//     on<SendMessageEvent>(_onSendMessage);
//     on<StartNewChatEvent>(_onStartNewChat);
//   }

//   ///✅ ─── Load Sessions ──────────────────────────────────────────────────────
//   Future<void> _onLoadSessions(
//     LoadSessionsEvent event,
//     Emitter<ChatbotState> emit,
//   ) async {
//     emit(SessionsLoading());
//     final result = await _repository.getSessions();
//     result.fold(
//       (error) => emit(SessionsError(message: error.message)),
//       (sessions) => emit(SessionsLoaded(sessions: sessions)),
//     );
//   }

//   ///✅ ─── Select Session (load its messages) ────────────────────────────────
//   Future<void> _onSelectSession(
//     SelectSessionEvent event,
//     Emitter<ChatbotState> emit,
//   ) async {
//     _currentSessionId = event.sessionId;
//     add(LoadMessagesEvent(sessionId: event.sessionId));
//   }

//   ///✅ ─── Delete Session ─────────────────────────────────────────────────────
//   Future<void> _onDeleteSession(
//     DeleteSessionEvent event,
//     Emitter<ChatbotState> emit,
//   ) async {
//     final result = await _repository.deleteSession(sessionId: event.sessionId);
//     result.fold(
//       (error) => emit(SessionsError(message: error.message)),
//       (_) async {
//         final sessionsResult = await _repository.getSessions();
//         sessionsResult.fold(
//           (error) => emit(SessionsError(message: error.message)),
//           (sessions) => emit(SessionDeleted(sessions: sessions)),
//         );
//       },
//     );
//   }

//   ///✅ ─── Rename Session ─────────────────────────────────────────────────────
//   Future<void> _onRenameSession(
//     RenameSessionEvent event,
//     Emitter<ChatbotState> emit,
//   ) async {
//     final result = await _repository.renameSession(
//       sessionId: event.sessionId,
//       newName: event.newName,
//     );
//     result.fold(
//       (error) => emit(SessionsError(message: error.message)),
//       (_) async {
//         final sessionsResult = await _repository.getSessions();
//         sessionsResult.fold(
//           (error) => emit(SessionsError(message: error.message)),
//           (sessions) => emit(SessionRenamed(sessions: sessions)),
//         );
//       },
//     );
//   }

//   ///✅ ─── Load Messages ──────────────────────────────────────────────────────
//   Future<void> _onLoadMessages(
//     LoadMessagesEvent event,
//     Emitter<ChatbotState> emit,
//   ) async {
//     emit(MessagesLoading());
//     final result = await _repository.getMessages(sessionId: event.sessionId);
//     result.fold(
//       (error) => emit(MessagesError(message: error.message)),
//       (messages) {
//         _currentMessages
//           ..clear()
//           ..addAll(messages);
//         emit(MessagesLoaded(
//           sessionId: event.sessionId,
//           messages: List.unmodifiable(_currentMessages),
//         ));
//       },
//     );
//   }

//   ///✅ ─── Send Message ───────────────────────────────────────────────────────
//   Future<void> _onSendMessage(
//     SendMessageEvent event,
//     Emitter<ChatbotState> emit,
//   ) async {
//     // Optimistically add user message to the list
//     _currentMessages.add(ChatMessage(
//       role: 'User',
//       content: event.question,
//       timestamp: DateTime.now(),
//     ));
//     emit(SendingMessage(messages: List.unmodifiable(_currentMessages)));

//     final result = await _repository.ask(
//       question: event.question,
//       sessionId: event.sessionId,
//     );

//     result.fold(
//       (error) => emit(SendMessageError(
//         message: error.message,
//         messages: List.unmodifiable(_currentMessages),
//       )),
//       (response) {
//         _currentSessionId = response.sessionId;
//         _currentMessages.add(ChatMessage(
//           role: 'AI',
//           content: response.answer,
//           timestamp: DateTime.now(),
//         ));
//         emit(MessageSent(
//           sessionId: response.sessionId,
//           messages: List.unmodifiable(_currentMessages),
//         ));
//       },
//     );
//   }

//   ///✅ ─── Start New Chat ─────────────────────────────────────────────────────
//   void _onStartNewChat(
//     StartNewChatEvent event,
//     Emitter<ChatbotState> emit,
//   ) {
//     _currentMessages.clear();
//     _currentSessionId = '';
//     emit(MessagesLoaded(sessionId: '', messages: const []));
//   }

//   String get currentSessionId => _currentSessionId;
// }



import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';
import 'package:sports_in/features/main/chat_bot/data/repo/chatbot_repo.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

@injectable
class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotRepository _repository;

  final List<ChatMessage> _currentMessages = [];
  String _currentSessionId = '';

  ChatbotBloc({required ChatbotRepository repository})
      : _repository = repository,
        super(ChatbotInitial()) {
    on<LoadSessionsEvent>(_onLoadSessions);
    on<SelectSessionEvent>(_onSelectSession);
    on<DeleteSessionEvent>(_onDeleteSession);
    on<RenameSessionEvent>(_onRenameSession);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<StartNewChatEvent>(_onStartNewChat);
  }

  ///✅ ─── Load Sessions ──────────────────────────────────────────────────────
  Future<void> _onLoadSessions(
    LoadSessionsEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(SessionsLoading());
    final result = await _repository.getSessions();
    result.fold(
      (error) => emit(SessionsError(message: error.message)),
      (sessions) => emit(SessionsLoaded(sessions: sessions)),
    );
  }

  ///✅ ─── Select Session ─────────────────────────────────────────────────────
  Future<void> _onSelectSession(
    SelectSessionEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    _currentSessionId = event.sessionId;
    add(LoadMessagesEvent(sessionId: event.sessionId));
  }

  ///✅ ─── Delete Session ─────────────────────────────────────────────────────
  Future<void> _onDeleteSession(
    DeleteSessionEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    // ✅ Step 1: delete
    final deleteResult =
        await _repository.deleteSession(sessionId: event.sessionId);

    // ✅ Step 2: on success, fetch fresh list and emit — no nested async in fold
    await deleteResult.fold(
      (error) async => emit(SessionsError(message: error.message)),
      (_) async {
        final sessionsResult = await _repository.getSessions();
        sessionsResult.fold(
          (error) => emit(SessionsError(message: error.message)),
          (sessions) => emit(SessionDeleted(sessions: sessions)),
        );
      },
    );
  }

  ///✅ ─── Rename Session ─────────────────────────────────────────────────────
  Future<void> _onRenameSession(
    RenameSessionEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    // ✅ Step 1: rename
    final renameResult = await _repository.renameSession(
      sessionId: event.sessionId,
      newName: event.newName,
    );

    // ✅ Step 2: on success, fetch fresh list and emit — no nested async in fold
    await renameResult.fold(
      (error) async => emit(SessionsError(message: error.message)),
      (_) async {
        final sessionsResult = await _repository.getSessions();
        sessionsResult.fold(
          (error) => emit(SessionsError(message: error.message)),
          (sessions) => emit(SessionRenamed(sessions: sessions)),
        );
      },
    );
  }

  ///✅ ─── Load Messages ──────────────────────────────────────────────────────
  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(MessagesLoading());
    final result = await _repository.getMessages(sessionId: event.sessionId);
    result.fold(
      (error) => emit(MessagesError(message: error.message)),
      (messages) {
        _currentMessages
          ..clear()
          ..addAll(messages);
        emit(MessagesLoaded(
          sessionId: event.sessionId,
          messages: List.unmodifiable(_currentMessages),
        ));
      },
    );
  }

  ///✅ ─── Send Message ───────────────────────────────────────────────────────
  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    _currentMessages.add(ChatMessage(
      role: 'User',
      content: event.question,
      timestamp: DateTime.now(),
    ));
    emit(SendingMessage(messages: List.unmodifiable(_currentMessages)));

    final result = await _repository.ask(
      question: event.question,
      sessionId: event.sessionId,
    );

    result.fold(
      (error) => emit(SendMessageError(
        message: error.message,
        messages: List.unmodifiable(_currentMessages),
      )),
      (response) {
        _currentSessionId = response.sessionId;
        _currentMessages.add(ChatMessage(
          role: 'AI',
          content: response.answer,
          timestamp: DateTime.now(),
        ));
        emit(MessageSent(
          sessionId: response.sessionId,
          messages: List.unmodifiable(_currentMessages),
        ));
      },
    );
  }

  ///✅ ─── Start New Chat ─────────────────────────────────────────────────────
  void _onStartNewChat(
    StartNewChatEvent event,
    Emitter<ChatbotState> emit,
  ) {
    _currentMessages.clear();
    _currentSessionId = '';
    emit(MessagesLoaded(sessionId: '', messages: const []));
  }

  String get currentSessionId => _currentSessionId;
}
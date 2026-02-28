import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/main/chat/data/interfaces/chat_interface.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';

@LazySingleton(as: ChatInterface)
class ChatRemoteDataSourceImpl implements ChatInterface {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl({required this.apiClient});

  DioException _badResponse(Response response) => DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

  // ─── Get All Chats ───────────────────────────────────────────────────────────

  @override
  Future<PaginatedChatsResponse> getAllChats({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiClient.get(
        Endpoints.getAllChats,
        params: {'pageNumber': pageNumber, 'pageSize': pageSize},
      );

      log('📦 getAllChats status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List data = response.data;

return PaginatedChatsResponse(
  items: data.map((e) => ChatModel.fromJson(e)).toList(),
  totalCount: data.length,
  pageNumber: 1,
  pageSize: data.length,
  totalPages: 1,
  hasNextPage: false,
  hasPreviousPage: false,
);
        // return PaginatedChatsResponse.fromJson(
        //   response.data ,
        // );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Get Contacts ─────────────────────────────────────────────────────────────

  @override
  Future<PaginatedContactsResponse> getContacts() async {
    try {
      final response = await apiClient.get(
        Endpoints.getContacts,
      );

      log('📦 getContacts status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return PaginatedContactsResponse.fromJson(
          response.data ,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Search Chats ─────────────────────────────────────────────────────────────

  @override
  Future<PaginatedChatsResponse> chatSearch({
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiClient.get(
        Endpoints.chatSearch,
        params: {
          'searchTerm': searchTerm,
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );

      log('📦 chatSearch status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return PaginatedChatsResponse.fromJson(
          response.data ,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Send Message ─────────────────────────────────────────────────────────────

 @override
  Future<MessageModel> sendMessage({
    required String content,
    String? receiverId,
    String? groupId,
    String? attachmentFile,
  }) async {
    try {
      assert(
        receiverId != null || groupId != null,
        'Either receiverId or groupId must be provided',
      );

      final formData = FormData.fromMap({
        'Content': content,
        if (receiverId != null) 'ReceiverId': receiverId,
        if (groupId != null) 'GroupId': groupId,
        if (attachmentFile != null)
          'Attachment': await MultipartFile.fromFile(attachmentFile),
      });

      final response = await apiClient.post(
        Endpoints.sendMessage,
        data: formData,
      );

//       log('📦 sendMessage status: ${response.statusCode}');
// if (response.statusCode != null &&
//     response.statusCode! >= 200 &&
//     response.statusCode! < 300) {
//   return;
// }


     if (response.statusCode == 200 || response.statusCode == 201) {
        return MessageModel.fromJson(response.data );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Get Message History ──────────────────────────────────────────────────────
@override
Future<PaginatedMessagesResponse> getAllMessages({
  String? targetUserId,
  String? groupId,
  int page = 1,
}) async {
  assert(
    targetUserId != null || groupId != null,
    'Either targetUserId or groupId must be provided',
  );

  try {
    final response = await apiClient.get(
      Endpoints.getAllMessages,
      params: {
        if (targetUserId != null) 'targetUserId': targetUserId,
        if (groupId != null) 'groupId': groupId,
        'page': page,
      },
    );

    log('📦 getAllMessages status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List data = response.data;

      return PaginatedMessagesResponse(
        items: data.map((e) => MessageModel.fromJson(e)).toList(),
        totalCount: data.length,
        pageNumber: 1,
        pageSize: data.length,
        totalPages: 1,
        hasNextPage: false,
        hasPreviousPage: false,
      );
    }

    throw ApiErrorHandler.handleDioError(_badResponse(response));
  } on DioException catch (e) {
    throw ApiErrorHandler.handleDioError(e);
  }
}

  // @override
  // Future<PaginatedMessagesResponse> getAllMessages({
  //   String? targetUserId,
  //   String? groupId,
  //   int page = 1,
  // }) async {
  //   assert(
  //     targetUserId != null || groupId != null,
  //     'Either targetUserId or groupId must be provided',
  //   );

  //   try {
  //     final response = await apiClient.get(
  //       Endpoints.getAllMessages,
  //       params: {
  //         if (targetUserId != null) 'targetUserId': targetUserId,
  //         if (groupId != null) 'groupId': groupId,
  //         'page': page,
  //       },
  //     );

  //     log('📦 getAllMessages status: ${response.statusCode}');

  //     if (response.statusCode == 200) {
  //       return PaginatedMessagesResponse.fromJson(
  //         response.data ,
  //       );
  //     }

  //     throw ApiErrorHandler.handleDioError(_badResponse(response));
  //   } on DioException catch (e) {
  //     throw ApiErrorHandler.handleDioError(e);
  //   }
  // }

  // ─── Create Group ─────────────────────────────────────────────────────────────
  // API body: Title* (string), Description (string), GroupPhoto (binary), MemberIds* (array<string>)

  @override
  Future<ChatModel> createGroup({
    required String title,
    required List<String> memberIds,
    String? description,
    String? groupPhoto,
  }) async {
    try {
      final formData = FormData.fromMap({
        'Title': title,
        'MemberIds': memberIds,
        if (description != null) 'Description': description,
        if (groupPhoto != null)
          'GroupPhoto': await MultipartFile.fromFile(groupPhoto),
      });

      final response = await apiClient.post(
        Endpoints.createGroup,
        data: formData,
      );

      log('📦 createGroup status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatModel.fromJson(response.data );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Edit Message ─────────────────────────────────────────────────────────────

  @override
  Future<MessageModel> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    try {
      final url = Endpoints.editMessage.replaceFirst('{id}', messageId);

      final response = await apiClient.put(
        url,
        data: {'content': newContent},
      );

      log('📦 editMessage status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return MessageModel.fromJson(response.data );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ─── Delete Message ───────────────────────────────────────────────────────────

  @override
  Future<void> deleteMessage({required String messageId}) async {
    try {
      final url = Endpoints.deleteMessage.replaceFirst('{id}', messageId);
      final response = await apiClient.delete(url);

      log('📦 deleteMessage status: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiErrorHandler.handleDioError(_badResponse(response));
      }

      log('✅ Message deleted successfully');
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}
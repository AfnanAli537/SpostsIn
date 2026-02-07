import 'package:sports_in/features/main/home/data/model/comment_model.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';

abstract class PostsRepository {
  Future<List<PostModel>> getAllPosts({
    required int pageNumber,
     int pageSize,
  });

  Future<void> likePost({ required String postId});
  Future<void> addComment({ required String postId,required  String text});
  Future<void> uploadPost({
    required String title,
    required String description,
     String? mediaUrl,
    required String sport,
  });
   Future<void> editComment({ required String commentId, required String text});
      Future<Map<String, dynamic>> getLikes({required String postId,required int pageNumber,
     int pageSize,});
      Future<PaginatedCommentsResponse> getComments({
    required String postId,
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<void> deleteComment({required String postId, required String commentId});
}

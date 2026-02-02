import 'package:sports_in/features/main/home/data/model/post_model.dart';

abstract class PostsRepository {
  Future<List<PostModel>> getAllPosts({
    required int pageNumber,
     int pageSize,
  });

  Future<void> likePost({ required String postId});
  Future<void> addComment({ required String postId,required  String comment});
  Future<void> uploadPost({
    required String title,
    required String description,
     String? mediaUrl,
    required String sport,
  });
   Future<void> editComment({ required String commentId, required String comment});
   Future<void> deleteComment({ required String commentId});
      Future<Map<String, dynamic>> getLikes({required String postId,required int pageNumber,
     int pageSize,});
}

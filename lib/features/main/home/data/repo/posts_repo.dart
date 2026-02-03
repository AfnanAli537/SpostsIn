import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/home/data/interface/post_interface.dart';
import 'package:sports_in/features/main/home/data/model/comment_model.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';

@lazySingleton
class PostsRepositoryImpl  {
  final PostsRepository repo;

  PostsRepositoryImpl(this.repo);

  
  Future<List<PostModel>> getAllPosts({
    required int pageNumber,
    required int pageSize,
  }) {
    return repo.getAllPosts(
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }


  Future<PostModel> likePost({required String postId}) {
    return repo.likePost(postId:postId);
  }

  Future<void> addComment({required String postId,required String text}) {
    return repo.addComment(postId:postId, text:text);
  }


  Future<void> uploadPost({
    required String title,
    required String description,
     String? mediaUrl,
    required String sport,
  }) {
    return repo.uploadPost(
      title: title,
      description: description,
      mediaUrl: mediaUrl ,
      sport:sport,
    );
  }
     Future<void> editComment({ required String commentId, required String comment}){
      return repo.editComment(commentId: commentId, text: comment);}
   Future<void> deleteComment({ required String commentId, required String postId}){
    return repo.deleteComment(postId:postId,commentId: commentId);}
   Future<Map<String, dynamic>> getLikes({required String postId, required int pageNumber,
     int pageSize= 20,}){
   return repo.getLikes(postId: postId, pageNumber: pageNumber);
    }
        Future<PaginatedCommentsResponse> getComments({
    required String postId,
    int pageNumber = 1,
    int pageSize = 10,
  }){
    return repo.getComments(postId: postId);
  }
}

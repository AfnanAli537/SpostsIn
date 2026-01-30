import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/home/data/interface/post_interface.dart';
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


  Future<void> likePost(String postId) {
    return repo.likePost(postId:postId);
  }

  Future<void> addComment(String postId, String comment) {
    return repo.addComment(postId:postId, comment:comment);
  }


  Future<void> uploadPost({
    required String title,
    required String description,
    required String mediaUrl,
  }) {
    return repo.uploadPost(
      title: title,
      description: description,
      mediaUrl: mediaUrl,
    );
  }
     Future<void> editComment({ required String commentId, required String comment}){
      return repo.editComment(commentId: commentId, comment: comment);}
   Future<void> deleteComment({ required String commentId}){
    return repo.deleteComment(commentId: commentId);}
}

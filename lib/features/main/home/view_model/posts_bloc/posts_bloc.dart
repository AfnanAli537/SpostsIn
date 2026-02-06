import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/home/data/model/author_model.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepositoryImpl postRepo;
  final int pageSize;

  PostsBloc({required this.postRepo, this.pageSize = 10})
    : super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<LikePost>(_onLikePost);
    on<UploadPost>(_onUploadPost);
  }

  final List<PostModel> _posts = [];
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isFetching = false;

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
    if (_isFetching || !_hasNextPage) return;
    _isFetching = true;

    try {
      if (_currentPage == 1) {
        emit(PostsLoading());
        await Future.delayed(const Duration(seconds: 2));
      }
      final fetchedPosts = await postRepo.getAllPosts(
        pageNumber: _currentPage,
        pageSize: pageSize,
      );

      _posts.addAll(fetchedPosts);
      _hasNextPage = fetchedPosts.length == pageSize;
      _currentPage++;

      emit(PostsLoaded(posts: List.from(_posts), hasNextPage: _hasNextPage));
    } catch (e) {
      emit(PostsError('Failed to fetch posts: ${e.toString()}'));
    } finally {
      _isFetching = false;
    }
  }


  Future<void> _onLikePost(LikePost event, Emitter<PostsState> emit) async {
    final currentState = state;

    // تأكد إن الـ state فيه posts
    if (currentState is! PostsLoaded) return;

    try {
      // 1️⃣ Optimistic Update (حدث الـ UI فوراً)
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          // اقلب الـ like status
          final newIsLiked = !post.isLikedByCurrentUser;
          final newLikesCount = newIsLiked
              ? post.likesCount + 1
              : post.likesCount - 1;

          return PostModel(
            id: post.id,
            title: post.title,
            description: post.description,
            isActive: post.isActive,
            mediaUrl: post.mediaUrl,
            createdAt: post.createdAt,
            author: post.author,
            likesCount:newLikesCount,
            commentsCount: post.commentsCount,
            isLikedByCurrentUser: newIsLiked,
          );
        }
        return post;
      }).toList();

      // حدث الـ state
      emit(
        PostsLoaded(posts: updatedPosts, hasNextPage: currentState.hasNextPage),
      );
      log("==========================like done/removed");
print("🔥 Like API called");
      // 2️⃣ اعمل الـ API call
      await postRepo.likePost(postId: event.postId);
    } catch (e) {
      // 3️⃣ لو فيه error، ارجع للـ state القديم
      print('❌ Like failed: $e');

      final revertedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          // ارجع للـ state الأصلي
          final originalIsLiked = !post.isLikedByCurrentUser;
          final originalLikesCount = originalIsLiked
              ? post.likesCount + 1
              : post.likesCount - 1;

          return PostModel(
            isActive: post.isActive,
            title: post.title,
            id: post.id,
            author: post.author,
            description: post.description,
            mediaUrl: post.mediaUrl,
            createdAt: post.createdAt,
            isLikedByCurrentUser: originalIsLiked,
            likesCount: originalLikesCount,
            commentsCount: post.commentsCount,
          );
        }
        return post;
      }).toList();

      emit(
        PostsLoaded(
          posts: revertedPosts,
          hasNextPage: currentState.hasNextPage,
        ),
      );
    }
  }


  void _onUploadPost(UploadPost event, Emitter<PostsState> emit) async {
    log("hello there==================================");
    /// validate
    if (event.title.isEmpty ||
        event.description.isEmpty ||
        event.sport.isEmpty) {
      emit(PostsError("Please fill all fields"));
      return;
    }

    final currentUser = AuthorModel(
      userId: 'current_user_id',
      fullName: 'Current User',
      profilePictureUrl: null,
    );

    /// optimistic UI (يظهر فوراً)
    final newPost = PostModel(
      id: DateTime.now().toString(),
      title: event.title,
      description: event.description,
      mediaUrl: event.mediaUrl,
      createdAt: DateTime.now(),
      isActive: true,
      author: currentUser,
      likesCount: 0,
      commentsCount: 0,
      isLikedByCurrentUser: false,
    );

    _posts.insert(0, newPost);

    emit(PostsLoaded(posts: List.from(_posts), hasNextPage: _hasNextPage));

    try {
      await postRepo.uploadPost(
        title: event.title,
        description: event.description,
        sport: event.sport,
        mediaUrl: event.mediaUrl,
      );
    } catch (e) {
      /// rollback لو فشل
      _posts.removeWhere((p) => p.id == newPost.id);

      emit(PostsError("Failed to upload post"));
    }
  }


}

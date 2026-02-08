import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/home/data/model/author_model.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepositoryImpl postRepo;
  final int pageSize;
  final prefs = getIt<SharedPref>();

  PostsBloc({required this.postRepo, this.pageSize = 10})
    : super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<LikePost>(_onLikePost);
    on<UploadPost>(_onUploadPost);
    on<LoadMorePosts>(_onLoadMorePosts);
  }

  final List<PostModel> _posts = [];
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isFetching = false;

Future<void> _onFetchPosts(
  FetchPosts event,
  Emitter<PostsState> emit,
) async {
  try {
    emit(PostsLoading());

    _posts.clear();
    _currentPage = 1;
    _hasNextPage = true;

    final fetchedPosts = await postRepo.getAllPosts(
      pageNumber: 1,
      pageSize: pageSize,
    );

    _posts.addAll(fetchedPosts);
    _hasNextPage = fetchedPosts.length == pageSize;

    emit(
      PostsLoaded(
        posts: List.from(_posts),
        hasNextPage: _hasNextPage,
      ),
    );
  } catch (e) {
    emit(PostsError('Failed to fetch posts: ${e.toString()}'));
  }
}

Future<void> _onLoadMorePosts(
  LoadMorePosts event,
  Emitter<PostsState> emit,
) async {
  if (_isFetching || !_hasNextPage) return;

  _isFetching = true;

  final currentState = state;
  if (currentState is! PostsLoaded) return;

  try {
    emit(PostsLoadingMore(currentState.posts));

    final nextPage = _currentPage + 1;

    final fetchedPosts = await postRepo.getAllPosts(
      pageNumber: nextPage,
      pageSize: pageSize,
    );

    _posts.addAll(fetchedPosts);

    _currentPage = nextPage;
    _hasNextPage = fetchedPosts.length == pageSize;

    emit(
      PostsLoaded(
        posts: List.from(_posts),
        hasNextPage: _hasNextPage,
      ),
    );
  } catch (e) {
    emit(PostsError('Failed to load more posts: ${e.toString()}'));
  } finally {
    _isFetching = false;
  }
}

  // Future<void> _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
  //   if (_isFetching || !_hasNextPage) return;
  //   _isFetching = true;

  //   try {
  //     if (_currentPage == 1) {
  //       emit(PostsLoading());
  //       await Future.delayed(const Duration(seconds: 2));
  //     }
  //     final fetchedPosts = await postRepo.getAllPosts(
  //       pageNumber: _currentPage,
  //       pageSize: pageSize,
  //     );

  //     _posts.addAll(fetchedPosts);
  //     _hasNextPage = fetchedPosts.length == pageSize;
  //     _currentPage++;

  //     emit(PostsLoaded(posts: List.from(_posts), hasNextPage: _hasNextPage));
  //   } catch (e) {
  //     emit(PostsError('Failed to fetch posts: ${e.toString()}'));
  //   } finally {
  //     _isFetching = false;
  //   }
  // }

  Future<void> _onLikePost(LikePost event, Emitter<PostsState> emit) async {
    final currentState = state;
    if (currentState is! PostsLoaded) return;

    try {
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
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
            likesCount: newLikesCount,
            commentsCount: post.commentsCount,
            isLikedByCurrentUser: newIsLiked,
          );
        }
        return post;
      }).toList();
      emit(
        PostsLoaded(posts: updatedPosts, hasNextPage: currentState.hasNextPage),
      );
      log("==========================like done/removed");
      log("🔥 Like API called");
      await postRepo.likePost(postId: event.postId);
    } catch (e) {
      log('❌ Like failed: $e');
      final revertedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
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
    log("Upload Post Started ==================================");

    if (event.title.isEmpty ||
        event.description.isEmpty ||
        event.sport.isEmpty) {
      emit(PostsError("Please fill all fields"));
      return;
    }
    final userData = await prefs.getUserFromPrefs();

    final currentUser = AuthorModel(
      userId: userData!.userId!,
      fullName: "${userData.name!.firstName} ${userData.name!.secondName}",
      profilePictureUrl: null,
    );

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final newPost = PostModel(
      id: tempId,
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
    emit(
      PostsLoaded(
        posts: List.from(_posts),
        hasNextPage: _hasNextPage,
        isUploading: true,
      ),
    );

    try {
      log("Sending request to backend...");
      await postRepo.uploadPost(
        title: event.title,
        description: event.description,
        sport: event.sport,
        mediaUrl: event.mediaUrl,
      );
      final uploadedPost = PostModel(
        id: userData.userId!,
        title: event.title,
        description: event.description,
        isActive: true,
        mediaUrl: event.mediaUrl,
        createdAt: DateTime.now(),
        author: currentUser,
        likesCount: 0,
        commentsCount: 0,
        isLikedByCurrentUser: false,
      );

      final index = _posts.indexWhere((p) => p.id == tempId);
      if (index != -1) {
        _posts[index] = uploadedPost;
      }
      emit(
        PostsLoaded(
          posts: List.from(_posts),
          hasNextPage: _hasNextPage,
          isUploading: false,
        ),
      );

      emit(PostsUploadSuccess());
      await Future.delayed(const Duration(milliseconds: 100));
      emit(PostsLoaded(posts: List.from(_posts), hasNextPage: _hasNextPage));
    } catch (e) {
      log("Upload failed: ${e.toString()}");
      _posts.removeWhere((p) => p.id == tempId);

      emit(PostsLoaded(posts: List.from(_posts), hasNextPage: _hasNextPage));

      emit(PostsError("Failed to upload post: ${e.toString()}"));
    }
  }
}

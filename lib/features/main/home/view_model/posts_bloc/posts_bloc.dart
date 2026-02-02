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

  PostsBloc({required this.postRepo, this.pageSize = 10}) : super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<LikePost>(_onLikePost);
    on<AddComment>(_onAddComment);
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
      // if (_currentPage == 1) emit(PostsLoading());
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

  void _onLikePost(LikePost event, Emitter<PostsState> emit) async {
    final index = _posts.indexWhere((post) => post.id == event.postId);
    if (index != -1) {
      final post = _posts[index];
      post.isLikedByCurrentUser = !post.isLikedByCurrentUser;
      post.likesCount += post.isLikedByCurrentUser ? 1 : -1;

      emit(PostsLoaded(posts: List.from(_posts), hasNextPage: _hasNextPage));

      // Optional: call API
      try {
        await postRepo.likePost(event.postId);
      } catch (_) {}
    }
  }

  void _onAddComment(AddComment event, Emitter<PostsState> emit) async {
    final index = _posts.indexWhere((post) => post.id == event.postId);
    if (index != -1) {
      _posts[index].commentsCount += 1;
      emit(PostsLoaded(posts: List.from(_posts), hasNextPage: _hasNextPage));

      // Optional: call API
      try {
        await postRepo.addComment(event.postId, event.comment);
      } catch (_) {}
    }
  }

  void _onUploadPost(UploadPost event, Emitter<PostsState> emit) async {
    // You should get current user info from your auth repository
    final currentUser = AuthorModel(
      userId: 'current_user_id',
      fullName: 'Current User',
      profilePictureUrl: null,
    );

    final newPost = PostModel(
      id: DateTime.now().toString(),
      title: event.title,
      description: event.description,
      mediaUrl: event.mediaUrl ?? '',
      createdAt: DateTime.now(),
      isActive: true,
      author: currentUser,
      likesCount: 0,
      commentsCount: 0,
      isLikedByCurrentUser: false,
    );

    _posts.insert(0, newPost);
    emit(PostsLoaded(posts: List.from(_posts), hasNextPage: _hasNextPage));

    // Optional: call API
    try {
      await postRepo.uploadPost(
        title: event.title,
        description: event.description,
        mediaUrl: event.mediaUrl ?? '',
      );
    } catch (_) {}
  }
}

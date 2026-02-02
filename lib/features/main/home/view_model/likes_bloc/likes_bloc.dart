import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/home/data/model/user_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';

part 'likes_event.dart';
part 'likes_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  final PostsRepositoryImpl postRepo;

  LikesBloc({required this.postRepo}) : super(LikesInitial()) {
    on<FetchLikes>(_onFetchLikes);
  }
Future<void> _onFetchLikes(FetchLikes event, Emitter<LikesState> emit) async {
  try {
    if (event.isRefresh || event.page == 1) {
      emit(LikesLoading());
      
      final result = await postRepo.getLikes(
        postId: event.postId,
        pageNumber: 1,
      );

      // ✅ Extract from map
      final likes = result['likes'] as List<UserLists>;
      final hasNextPage = result['hasNextPage'] as bool;

      emit(LikesLoaded(
        likes: likes,
        hasMore: hasNextPage,
        currentPage: 1,
      ));
    } else {
      final currentState = state;
      if (currentState is LikesLoaded) {
        emit(LikesLoadingMore(currentState.likes));

        final result = await postRepo.getLikes(
          postId: event.postId,
          pageNumber: event.page,
        );

        // ✅ Extract from map
        final newLikes = result['likes'] as List<UserLists>;
        final hasNextPage = result['hasNextPage'] as bool;
        final allLikes = [...currentState.likes, ...newLikes];

        emit(LikesLoaded(
          likes: allLikes,
          hasMore: hasNextPage,
          currentPage: event.page,
        ));
      }
    }
  } catch (e) {
    emit(LikesError('Failed to fetch likes: ${e.toString()}'));
  }
}
}

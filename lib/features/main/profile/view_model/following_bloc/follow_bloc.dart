// followers_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
part 'follow_event.dart';
part 'follow_state.dart';


@injectable
class FollowingBloc extends Bloc<FollowingEvent, FollowingState> {
  final ProfileRepo _repository;
  String? _userId;
  int _page = 1;
  bool _hasNext = true;
  bool _isFetching = false;
  final List<UserContactItem> _items = [];

  FollowingBloc(this._repository) : super(FollowingInitial()) {
    on<LoadFollowing>(_onLoadFollowing);
    on<LoadMoreFollowing>(_onLoadMore);
  }

  Future<void> _onLoadFollowing(LoadFollowing event, Emitter<FollowingState> emit) async {
    try {
      emit(FollowingLoading());
      _userId = event.userId;
      _page = 1;
      _hasNext = true;
      _items.clear();

      final result = await _repository.getFollowing(
        userId: event.userId,
        pageNumber: 1,
        pageSize: 20,
      );
      _items.addAll(result.items);
      _hasNext = result.hasNextPage;
      emit(FollowingLoaded(items: List.from(_items), hasNextPage: _hasNext, currentPage: 1));
    } catch (e) {
      emit(FollowingError(e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreFollowing event, Emitter<FollowingState> emit) async {
    final currentState = state;
    if (currentState is! FollowingLoaded) return;
    if (!_hasNext || _isFetching) return;
    _isFetching = true;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = _page + 1;
      final result = await _repository.getFollowing(
        userId: _userId!,
        pageNumber: nextPage,
        pageSize: 20,
      );
      _items.addAll(result.items);
      _page = nextPage;
      _hasNext = result.hasNextPage;
      emit(FollowingLoaded(items: List.from(_items), hasNextPage: _hasNext, currentPage: _page, isLoadingMore: false));
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
      emit(FollowingError('Failed to load more'));
    } finally {
      _isFetching = false;
    }
  }
}
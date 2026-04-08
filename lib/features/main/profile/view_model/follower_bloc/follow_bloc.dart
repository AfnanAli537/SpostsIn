// followers_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
part 'follow_event.dart';
part 'follow_state.dart';


@injectable
class FollowersBloc extends Bloc<FollowersEvent, FollowersState> {
  final ProfileRepo _repository;
  String? _userId;
  int _page = 1;
  bool _hasNext = true;
  bool _isFetching = false;
  final List<UserContactItem> _items = [];

  FollowersBloc(this._repository) : super(FollowersInitial()) {
    on<LoadFollowers>(_onLoadFollowers);
    on<LoadMoreFollowers>(_onLoadMore);
  }

  Future<void> _onLoadFollowers(LoadFollowers event, Emitter<FollowersState> emit) async {
    try {
      emit(FollowersLoading());
      _userId = event.userId;
      _page = 1;
      _hasNext = true;
      _items.clear();

      final result = await _repository.getFollowers(
        userId: event.userId,
        pageNumber: 1,
        pageSize: 20,
      );
      _items.addAll(result.items);
      _hasNext = result.hasNextPage;
      emit(FollowersLoaded(items: List.from(_items), hasNextPage: _hasNext, currentPage: 1));
    } catch (e) {
      emit(FollowersError(e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreFollowers event, Emitter<FollowersState> emit) async {
    final currentState = state;
    if (currentState is! FollowersLoaded) return;
    if (!_hasNext || _isFetching) return;
    _isFetching = true;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = _page + 1;
      final result = await _repository.getFollowers(
        userId: _userId!,
        pageNumber: nextPage,
        pageSize: 20,
      );
      _items.addAll(result.items);
      _page = nextPage;
      _hasNext = result.hasNextPage;
      emit(FollowersLoaded(items: List.from(_items), hasNextPage: _hasNext, currentPage: _page, isLoadingMore: false));
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
      emit(FollowersError('Failed to load more'));
    } finally {
      _isFetching = false;
    }
  }
}
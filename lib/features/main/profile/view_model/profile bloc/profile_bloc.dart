import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo _repository;

  ProfileBloc(this._repository) : super(ProfileInitial()) {
    on<LoadMyProfile>(_onLoadMyProfile);
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ToggleFollow>(_onToggleFollow);
    on<SendConnectionRequest>(_onSendConnectionRequest);
    on<RemoveContact>(_onRemoveContact);

    on<LoadAchievements>(_onLoadAchievements);
    on<CreateAchievement>(_onCreateAchievement);
    on<UpdateAchievement>(_onUpdateAchievement);
    on<DeleteAchievement>(_onDeleteAchievement);

    on<LoadPosts>(_onLoadPosts);
    on<LoadOpportunities>(_onLoadOpportunities);
    on<LoadCourses>(_onLoadCourses);
    on<LoadInterests>(_onLoadInterests);
  }

  // ── Profile Loaders ──────────────────────────────────────────────────────────

  Future<void> _onLoadMyProfile(
    LoadMyProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final profile = await _repository.getMyProfile();
      emit(ProfileLoaded(profile: profile, isOwnProfile: true));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final profile = await _repository.getUserProfile(event.userId);
      emit(ProfileLoaded(profile: profile, isOwnProfile: false));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final updatedProfile = await _repository.updateProfile(event.updateData);
      emit(ProfileUpdated(profile: updatedProfile));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(ProfileLoaded(profile: updatedProfile, isOwnProfile: true));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  // ── Follow ───────────────────────────────────────────────────────────────────

  Future<void> _onToggleFollow(
    ToggleFollow event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final isMainProfile = event.userId == currentState.profile.id;

    if (isMainProfile) {
      final currentlyFollowing = currentState.profile.isFollowing;
      final updatedProfile =
          currentState.profile.copyWith(isFollowing: !currentlyFollowing);

      emit(ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile));

      try {
        await _repository.toggleFollow(event.userId);
        emit(ProfileActionSuccess(
          message: currentlyFollowing
              ? 'Unfollowed successfully!'
              : 'Following successfully!',
        ));
        emit(ProfileLoaded(
            profile: updatedProfile,
            isOwnProfile: currentState.isOwnProfile));
      } catch (e) {
        emit(ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile));
        emit(const ProfileActionError(
            message: 'Failed to update follow status'));
      }
    } else {
      // Interest item follow toggle
      final idx = currentState.profile.interests
          .indexWhere((i) => i.id == event.userId);
      if (idx == -1) return;

      final old = currentState.profile.interests[idx];
      final updatedInterests =
          List<Interest>.from(currentState.profile.interests);
      updatedInterests[idx] = old.copyWith(isFollowing: !old.isFollowing);

      final updatedProfile =
          currentState.profile.copyWith(interests: updatedInterests);
      emit(ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile));

      try {
        await _repository.toggleFollow(event.userId);
        emit(ProfileActionSuccess(
          message: old.isFollowing
              ? 'Unfollowed successfully!'
              : 'Following successfully!',
        ));
        emit(ProfileLoaded(
            profile: updatedProfile,
            isOwnProfile: currentState.isOwnProfile));
      } catch (e) {
        emit(ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile));
        emit(const ProfileActionError(
            message: 'Failed to update follow status'));
      }
    }
  }

  // ── Connection ───────────────────────────────────────────────────────────────

  /// Fired when the user taps Connect (connectionStatus is null).
  /// Optimistically sets connectionStatus → "Pending".
  /// Works for both the main profile button and interest list items.
  Future<void> _onSendConnectionRequest(
    SendConnectionRequest event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final isInterest = event.receiverId != currentState.profile.id;

    if (!isInterest) {
      // Main profile
      final updated =
          currentState.profile.copyWith(connectionStatus: 'Pending');
      emit(ProfileLoaded(
          profile: updated, isOwnProfile: currentState.isOwnProfile));

      try {
        await _repository.sendConnectionRequest(event.receiverId);
        emit(const ProfileActionSuccess(message: 'Connection request sent!'));
        emit(ProfileLoaded(
            profile: updated, isOwnProfile: currentState.isOwnProfile));
      } catch (e) {
        emit(ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile));
        emit(const ProfileActionError(
            message: 'Failed to send connection request'));
      }
    } else {
      // Interest item
      final idx = currentState.profile.interests
          .indexWhere((i) => i.id == event.receiverId);
      if (idx == -1) return;

      final updatedInterests =
          List<Interest>.from(currentState.profile.interests);
      updatedInterests[idx] =
          updatedInterests[idx].copyWith(connectionStatus: 'Pending');

      final updatedProfile =
          currentState.profile.copyWith(interests: updatedInterests);
      emit(ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile));

      try {
        await _repository.sendConnectionRequest(event.receiverId);
        emit(const ProfileActionSuccess(message: 'Connection request sent!'));
        emit(ProfileLoaded(
            profile: updatedProfile,
            isOwnProfile: currentState.isOwnProfile));
      } catch (e) {
        emit(ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile));
        emit(const ProfileActionError(
            message: 'Failed to send connection request'));
      }
    }
  }

  /// Fired when the user taps "Remove Contact" (connectionStatus is "Accepted").
  /// Optimistically sets connectionStatus → null.
  /// Works for both the main profile button and interest list items.
  Future<void> _onRemoveContact(
    RemoveContact event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    final isInterest = event.targetId != currentState.profile.id;

    if (!isInterest) {
      // Main profile
      final updated =
          currentState.profile.copyWith(clearConnectionStatus: true);
      emit(ProfileLoaded(
          profile: updated, isOwnProfile: currentState.isOwnProfile));

      try {
        await _repository.removeContact(event.targetId);
        emit(const ProfileActionSuccess(message: 'Contact removed'));
        emit(ProfileLoaded(
            profile: updated, isOwnProfile: currentState.isOwnProfile));
      } catch (e) {
        emit(ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile));
        emit(const ProfileActionError(message: 'Failed to remove contact'));
      }
    } else {
      // Interest item
      final idx = currentState.profile.interests
          .indexWhere((i) => i.id == event.targetId);
      if (idx == -1) return;

      final updatedInterests =
          List<Interest>.from(currentState.profile.interests);
      updatedInterests[idx] =
          updatedInterests[idx].copyWith(clearConnectionStatus: true);

      final updatedProfile =
          currentState.profile.copyWith(interests: updatedInterests);
      emit(ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile));

      try {
        await _repository.removeContact(event.targetId);
        emit(const ProfileActionSuccess(message: 'Contact removed'));
        emit(ProfileLoaded(
            profile: updatedProfile,
            isOwnProfile: currentState.isOwnProfile));
      } catch (e) {
        emit(ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile));
        emit(const ProfileActionError(message: 'Failed to remove contact'));
      }
    }
  }

  // ── Achievement Handlers ─────────────────────────────────────────────────────

  Future<void> _onLoadAchievements(
    LoadAchievements event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final achievements = await _repository.getAchievements(
          userId: event.userId, page: event.page, size: event.size);
      emit(AchievementsLoaded(
          achievements: achievements,
          hasMore: achievements.length >= event.size));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onCreateAchievement(
    CreateAchievement event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final achievement = await _repository.createAchievement(
          title: event.title,
          subtitle: event.subtitle,
          imageUrl: event.imageUrl,
          date: event.date);
      emit(AchievementCreated(achievement: achievement));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onUpdateAchievement(
    UpdateAchievement event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final achievement = await _repository.updateAchievement(
          achievementId: event.achievementId,
          title: event.title,
          subtitle: event.subtitle,
          imageUrl: event.imageUrl,
          date: event.date);
      emit(AchievementUpdated(achievement: achievement));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onDeleteAchievement(
    DeleteAchievement event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      await _repository.deleteAchievement(event.achievementId);
      emit(AchievementDeleted(achievementId: event.achievementId));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  // ── Posts ────────────────────────────────────────────────────────────────────

  Future<void> _onLoadPosts(
      LoadPosts event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      final posts = await _repository.getPosts(
          userId: event.userId, page: event.page, pageSize: event.size);
      emit(PostsLoaded(posts: posts, hasMore: posts.length >= event.size));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  // ── Opportunities ────────────────────────────────────────────────────────────

  Future<void> _onLoadOpportunities(
    LoadOpportunities event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final opportunities = await _repository.getOpportunities(
          userId: event.userId, page: event.page, pageSize: event.pageSize);
      emit(OpportunitiesLoaded(
          opportunities: opportunities,
          hasMore: opportunities.length >= event.pageSize));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  // ── Courses ──────────────────────────────────────────────────────────────────

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final courses = await _repository.getCourses(
          userId: event.userId, page: event.page, pageSize: event.pageSize);
      emit(CoursesLoaded(
          courses: courses, hasMore: courses.length >= event.pageSize));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  // ── Interests ────────────────────────────────────────────────────────────────

  Future<void> _onLoadInterests(
    LoadInterests event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final interests = await _repository.getInterests(
          userId: event.userId, page: event.page, pageSize: event.pageSize);
      emit(InterestsLoaded(
          interests: interests, hasMore: interests.length >= event.pageSize));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }
}
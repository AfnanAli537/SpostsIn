import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import '../data/repo/profile_repo.dart';
import '../model/profile_model.dart';
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
    on<ToggleConnect>(_onToggleConnect);

    // Achievement handlers
    on<LoadAchievements>(_onLoadAchievements);
    on<CreateAchievement>(_onCreateAchievement);
    on<UpdateAchievement>(_onUpdateAchievement);
    on<DeleteAchievement>(_onDeleteAchievement);

    // Other section handlers
    on<LoadPosts>(_onLoadPosts);
    on<LoadOpportunities>(_onLoadOpportunities);
    on<LoadCourses>(_onLoadCourses);
    on<LoadInterests>(_onLoadInterests);
  }

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

  // Future<void> _onUpdateProfile(
  //   UpdateProfile event,
  //   Emitter<ProfileState> emit,
  // ) async {
  //   try {
  //     emit(ProfileLoading());
  //     final updatedProfile = await _repository.updateProfile(event.updateData);

  //     // ✅ FIXED: Only emit ProfileUpdated - let the screen handle navigation
  //     // The ProfileUpdated state will trigger Navigator.pop in the edit screen
  //     // Then the profile screen underneath will remain in its current state
  //     emit(ProfileUpdated(profile: updatedProfile));

  //     // ✅ OPTION 1: Add a small delay before emitting ProfileLoaded
  //     // This gives time for Navigator.pop to execute
  //     await Future.delayed(const Duration(milliseconds: 100));
  //     final currentState = state;
  //     if (currentState is ProfileLoaded) {
  //     emit(ProfileLoaded(profile: updatedProfile, isOwnProfile: true));
  //     }
  //     // ✅ OPTION 2 (RECOMMENDED): Don't emit ProfileLoaded here at all
  //     // Instead, let the profile screen reload itself when it becomes visible
  //     // Remove the above two lines and just keep emit(ProfileUpdated(...))

  //   } catch (e) {
  //     emit(ProfileError(message: e.toString()));

  //     final currentState = state;
  //     if (currentState is ProfileLoaded) {
  //       emit(
  //         ProfileLoaded(
  //           profile: currentState.profile,
  //           isOwnProfile: currentState.isOwnProfile,
  //         ),
  //       );
  //     }
  //   }
  // }
  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final updatedProfile = await _repository.updateProfile(event.updateData);

      // ✅ Only emit ProfileUpdated - the screen will pop
      // The profile screen that's underneath will reload itself
      emit(ProfileUpdated(profile: updatedProfile));
      await Future.delayed(const Duration(milliseconds: 100));

      final currentState = state;
      if (currentState is ProfileLoaded) {
         emit(ProfileLoaded(profile: updatedProfile, isOwnProfile: true));

      }
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onToggleFollow(
    ToggleFollow event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    // Check if toggling main profile or an interest
    final isMainProfile = event.userId == currentState.profile.id;

    if (isMainProfile) {
      // Toggle main profile
      final currentlyFollowing = currentState.profile.isFollowing;

      // Optimistic update
      final updatedProfile = currentState.profile.copyWith(
        isFollowing: !currentlyFollowing,
      );
      emit(
        ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile,
        ),
      );

      try {
        await _repository.toggleFollow(event.userId);
        emit(
          ProfileActionSuccess(
            message: currentlyFollowing
                ? 'Unfollowed successfully!'
                : 'Following successfully!',
          ),
        );
        emit(
          ProfileLoaded(
            profile: updatedProfile,
            isOwnProfile: currentState.isOwnProfile,
          ),
        );
      } catch (e) {
        // Revert on error
        emit(
          ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile,
          ),
        );
        emit(ProfileActionError(message: 'Failed to update follow status'));
      }
    } else {
      // Toggle interest
      final interestIndex = currentState.profile.interests.indexWhere(
        (interest) => interest.id == event.userId,
      );

      if (interestIndex == -1) return;

      final currentlyFollowing =
          currentState.profile.interests[interestIndex].isFollowing;

      // Optimistic update
      final updatedInterests = List<Interest>.from(
        currentState.profile.interests,
      );
      updatedInterests[interestIndex] = Interest(
        id: updatedInterests[interestIndex].id,
        name: updatedInterests[interestIndex].name,
        role: updatedInterests[interestIndex].role,
        profileImage: updatedInterests[interestIndex].profileImage,
        isConnected: updatedInterests[interestIndex].isConnected,
        isFollowing: !currentlyFollowing,
      );

      final updatedProfile = currentState.profile.copyWith(
        interests: updatedInterests,
      );

      emit(
        ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile,
        ),
      );

      try {
        await _repository.toggleFollow(event.userId);
        emit(
          ProfileActionSuccess(
            message: currentlyFollowing
                ? 'Unfollowed successfully!'
                : 'Following successfully!',
          ),
        );
        emit(
          ProfileLoaded(
            profile: updatedProfile,
            isOwnProfile: currentState.isOwnProfile,
          ),
        );
      } catch (e) {
        // Revert on error
        emit(
          ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile,
          ),
        );
        emit(ProfileActionError(message: 'Failed to update follow status'));
      }
    }
  }

  Future<void> _onToggleConnect(
    ToggleConnect event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    // Check if toggling main profile or an interest
    final isMainProfile = event.userId == currentState.profile.id;

    if (isMainProfile) {
      // Toggle main profile
      final currentlyConnected = currentState.profile.isConnected;

      // Optimistic update
      final updatedProfile = currentState.profile.copyWith(
        isConnected: !currentlyConnected,
      );
      emit(
        ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile,
        ),
      );

      try {
        await _repository.toggleConnect(event.userId);
        emit(
          ProfileActionSuccess(
            message: currentlyConnected
                ? 'Disconnected successfully!'
                : 'Connected successfully!',
          ),
        );
        emit(
          ProfileLoaded(
            profile: updatedProfile,
            isOwnProfile: currentState.isOwnProfile,
          ),
        );
      } catch (e) {
        // Revert on error
        emit(
          ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile,
          ),
        );
        emit(ProfileActionError(message: 'Failed to update connection status'));
      }
    } else {
      // Toggle interest
      final interestIndex = currentState.profile.interests.indexWhere(
        (interest) => interest.id == event.userId,
      );

      if (interestIndex == -1) return;

      final currentlyConnected =
          currentState.profile.interests[interestIndex].isConnected;

      // Optimistic update
      final updatedInterests = List<Interest>.from(
        currentState.profile.interests,
      );
      updatedInterests[interestIndex] = Interest(
        id: updatedInterests[interestIndex].id,
        name: updatedInterests[interestIndex].name,
        role: updatedInterests[interestIndex].role,
        profileImage: updatedInterests[interestIndex].profileImage,
        isConnected: !currentlyConnected,
        isFollowing: updatedInterests[interestIndex].isFollowing,
      );

      final updatedProfile = currentState.profile.copyWith(
        interests: updatedInterests,
      );

      emit(
        ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile,
        ),
      );

      try {
        await _repository.toggleConnect(event.userId);
        emit(
          ProfileActionSuccess(
            message: currentlyConnected
                ? 'Disconnected successfully!'
                : 'Connected successfully!',
          ),
        );
        emit(
          ProfileLoaded(
            profile: updatedProfile,
            isOwnProfile: currentState.isOwnProfile,
          ),
        );
      } catch (e) {
        // Revert on error
        emit(
          ProfileLoaded(
            profile: currentState.profile,
            isOwnProfile: currentState.isOwnProfile,
          ),
        );
        emit(ProfileActionError(message: 'Failed to update connection status'));
      }
    }
  }

  // Achievement Handlers
  Future<void> _onLoadAchievements(
    LoadAchievements event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final achievements = await _repository.getAchievements(
        userId: event.userId,
        page: event.page,
        size: event.size,
      );

      final hasMore = achievements.length >= event.size;

      emit(AchievementsLoaded(achievements: achievements, hasMore: hasMore));
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
        date: event.date,
      );
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
        date: event.date,
      );
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

  // Posts Handler
  Future<void> _onLoadPosts(LoadPosts event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      final posts = await _repository.getPosts(
        userId: event.userId,
        page: event.page,
        pageSize: event.size,
      );
      final hasMore = posts.length >= event.size;
      emit(PostsLoaded(posts: posts, hasMore: hasMore));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  // Opportunities Handler
  Future<void> _onLoadOpportunities(
    LoadOpportunities event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final opportunities = await _repository.getOpportunities(
        userId: event.userId,
        page: event.page,
        pageSize: event.pageSize,
      );

      final hasMore = opportunities.length >= event.pageSize;
      emit(OpportunitiesLoaded(opportunities: opportunities, hasMore: hasMore));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  // Courses Handler
  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final courses = await _repository.getCourses(
        userId: event.userId,
        page: event.page,
        pageSize: event.pageSize,
      );

      final hasMore = courses.length >= event.pageSize;
      emit(CoursesLoaded(courses: courses, hasMore: hasMore));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  // Interests Handler
  Future<void> _onLoadInterests(
    LoadInterests event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final interests = await _repository.getInterests(
        userId: event.userId,
        page: event.page,
        pageSize: event.pageSize,
      );

      final hasMore = interests.length >= event.pageSize;
      emit(InterestsLoaded(interests: interests, hasMore: hasMore));
    } catch (e) {
      emit(ProfileError(message: e is ApiException ? e.message : e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../data/repo/profile_repo.dart';
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
      emit(ProfileError(message: e.toString()));
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
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final profile = await _repository.updateProfile(event.updateData);
      emit(ProfileUpdated(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onToggleFollow(
    ToggleFollow event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _repository.toggleFollow(event.userId);
      // You might want to reload the profile here
      // Or emit a specific state for follow toggled
      final currentState = state;
      if (currentState is ProfileLoaded) {
        final updatedProfile = currentState.profile.copyWith(
          isFollowing: !currentState.profile.isFollowing,
        );
        emit(ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile,
        ));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> _onToggleConnect(
    ToggleConnect event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _repository.toggleConnect(event.userId);
      final currentState = state;
      if (currentState is ProfileLoaded) {
        final updatedProfile = currentState.profile.copyWith(
          isConnected: !currentState.profile.isConnected,
        );
        emit(ProfileLoaded(
          profile: updatedProfile,
          isOwnProfile: currentState.isOwnProfile,
        ));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
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
      
      // Check if there are more achievements
      // Typically, if we get less than size, there are no more
      final hasMore = achievements.length >= event.size;
      
      emit(AchievementsLoaded(
        achievements: achievements,
        hasMore: hasMore,
      ));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
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
      emit(ProfileError(message: e.toString()));
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
      emit(ProfileError(message: e.toString()));
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
      emit(ProfileError(message: e.toString()));
    }
  }

  // Posts Handler
  Future<void> _onLoadPosts(
    LoadPosts event,
    Emitter<ProfileState> emit,
  ) async {
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
      emit(ProfileError(message: e.toString()));
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
      emit(OpportunitiesLoaded(
        opportunities: opportunities,
        hasMore: hasMore,
      ));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
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
      emit(ProfileError(message: e.toString()));
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
      emit(ProfileError(message: e.toString()));
    }
  }
}
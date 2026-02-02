import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../model/profile_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo profileRepo;

  ProfileModel? _currentProfile;
  bool _isOwnProfile = false;

  ProfileBloc(this.profileRepo) : super(ProfileInitial()) {
    on<LoadMyProfile>(_onLoadMyProfile);
    on<LoadUserProfile>(_onLoadUserProfile);
    on<ToggleFollowUser>(_onToggleFollowUser);
    on<ToggleConnectUser>(_onToggleConnectUser);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadMyProfile(
    LoadMyProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepo.getMyProfile();
      _currentProfile = profile;
      _isOwnProfile = true;
      emit(ProfileLoaded(profile: profile, isOwnProfile: true));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepo.getUserProfile(event.userId);
      _currentProfile = profile;
      _isOwnProfile = false;
      emit(ProfileLoaded(profile: profile, isOwnProfile: false));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
Future<void> _onToggleFollowUser(
  ToggleFollowUser event,
  Emitter<ProfileState> emit,
) async {
  if (_currentProfile == null) return;

  // Check if toggling the main profile or an interest
  final isMainProfile = event.userId == _currentProfile!.id;
  
  if (isMainProfile) {
    // ========== Toggle Main Profile Follow ==========
    final currentlyFollowing = _currentProfile!.isFollowing;
    
    // Optimistic update for main profile
    final optimisticProfile = _currentProfile!.copyWith(
      isFollowing: !currentlyFollowing,
    );
    
    _currentProfile = optimisticProfile;
    emit(ProfileLoaded(profile: optimisticProfile, isOwnProfile: _isOwnProfile));

    // Background API call
    try {
      await profileRepo.toggleFollow(event.userId);
      emit(ProfileActionSuccess(
        currentlyFollowing ? 'Unfollowed successfully!' : 'Following successfully!',
      ));
      emit(ProfileLoaded(profile: optimisticProfile, isOwnProfile: _isOwnProfile));
    } catch (e) {
      // Revert on error
      final revertedProfile = _currentProfile!.copyWith(
        isFollowing: currentlyFollowing,
      );
      _currentProfile = revertedProfile;
      emit(ProfileActionError('Failed to update follow status'));
      emit(ProfileLoaded(profile: revertedProfile, isOwnProfile: _isOwnProfile));
    }
  } else {
    // ========== Toggle Interest Follow ==========
    final interestIndex = _currentProfile!.interests.indexWhere(
      (interest) => interest.id == event.userId,
    );

    if (interestIndex == -1) return; // Interest not found

    final currentlyFollowing = _currentProfile!.interests[interestIndex].isFollowing;

    // Optimistic update for interest
    final updatedInterests = List<Interest>.from(_currentProfile!.interests);
    updatedInterests[interestIndex] = Interest(
      id: updatedInterests[interestIndex].id,
      name: updatedInterests[interestIndex].name,
      role: updatedInterests[interestIndex].role,
      profileImage: updatedInterests[interestIndex].profileImage,
      isConnected: updatedInterests[interestIndex].isConnected,
      isFollowing: !currentlyFollowing, // Toggle
    );

    final optimisticProfile = _currentProfile!.copyWith(
      interests: updatedInterests,
    );
    
    _currentProfile = optimisticProfile;
    emit(ProfileLoaded(profile: optimisticProfile, isOwnProfile: _isOwnProfile));

    // Background API call
    try {
      await profileRepo.toggleFollow(event.userId);
      emit(ProfileActionSuccess(
        currentlyFollowing ? 'Unfollowed successfully!' : 'Following successfully!',
      ));
      emit(ProfileLoaded(profile: optimisticProfile, isOwnProfile: _isOwnProfile));
    } catch (e) {
      // Revert on error
      final revertedInterests = List<Interest>.from(_currentProfile!.interests);
      revertedInterests[interestIndex] = Interest(
        id: revertedInterests[interestIndex].id,
        name: revertedInterests[interestIndex].name,
        role: revertedInterests[interestIndex].role,
        profileImage: revertedInterests[interestIndex].profileImage,
        isConnected: revertedInterests[interestIndex].isConnected,
        isFollowing: currentlyFollowing, // Revert
      );

      final revertedProfile = _currentProfile!.copyWith(
        interests: revertedInterests,
      );
      
      _currentProfile = revertedProfile;
      emit(ProfileActionError('Failed to update follow status'));
      emit(ProfileLoaded(profile: revertedProfile, isOwnProfile: _isOwnProfile));
    }
  }
}

Future<void> _onToggleConnectUser(
  ToggleConnectUser event,
  Emitter<ProfileState> emit,
) async {
  if (_currentProfile == null) return;

  // Check if toggling the main profile or an interest
  final isMainProfile = event.userId == _currentProfile!.id;
  
  if (isMainProfile) {
    // ========== Toggle Main Profile Connect ==========
    final currentlyConnected = _currentProfile!.isConnected;
    
    // Optimistic update for main profile
    final optimisticProfile = _currentProfile!.copyWith(
      isConnected: !currentlyConnected,
    );
    
    _currentProfile = optimisticProfile;
    emit(ProfileLoaded(profile: optimisticProfile, isOwnProfile: _isOwnProfile));

    // Background API call
    try {
      await profileRepo.toggleConnect(event.userId);
      emit(ProfileActionSuccess(
        currentlyConnected ? 'Disconnected successfully!' : 'Connected successfully!',
      ));
      emit(ProfileLoaded(profile: optimisticProfile, isOwnProfile: _isOwnProfile));
    } catch (e) {
      // Revert on error
      final revertedProfile = _currentProfile!.copyWith(
        isConnected: currentlyConnected,
      );
      _currentProfile = revertedProfile;
      emit(ProfileActionError('Failed to update connection status'));
      emit(ProfileLoaded(profile: revertedProfile, isOwnProfile: _isOwnProfile));
    }
  } else {
    // ========== Toggle Interest Connect ==========
    final interestIndex = _currentProfile!.interests.indexWhere(
      (interest) => interest.id == event.userId,
    );

    if (interestIndex == -1) return; // Interest not found

    final currentlyConnected = _currentProfile!.interests[interestIndex].isConnected;

    // Optimistic update for interest
    final updatedInterests = List<Interest>.from(_currentProfile!.interests);
    updatedInterests[interestIndex] = Interest(
      id: updatedInterests[interestIndex].id,
      name: updatedInterests[interestIndex].name,
      role: updatedInterests[interestIndex].role,
      profileImage: updatedInterests[interestIndex].profileImage,
      isConnected: !currentlyConnected, // Toggle
      isFollowing: updatedInterests[interestIndex].isFollowing,
    );

    final optimisticProfile = _currentProfile!.copyWith(
      interests: updatedInterests,
    );
    
    _currentProfile = optimisticProfile;
    emit(ProfileLoaded(profile: optimisticProfile, isOwnProfile: _isOwnProfile));

    // Background API call
    try {
      await profileRepo.toggleConnect(event.userId);
      emit(ProfileActionSuccess(
        currentlyConnected ? 'Disconnected successfully!' : 'Connected successfully!',
      ));
      emit(ProfileLoaded(profile: optimisticProfile, isOwnProfile: _isOwnProfile));
    } catch (e) {
      // Revert on error
      final revertedInterests = List<Interest>.from(_currentProfile!.interests);
      revertedInterests[interestIndex] = Interest(
        id: revertedInterests[interestIndex].id,
        name: revertedInterests[interestIndex].name,
        role: revertedInterests[interestIndex].role,
        profileImage: revertedInterests[interestIndex].profileImage,
        isConnected: currentlyConnected, // Revert
        isFollowing: revertedInterests[interestIndex].isFollowing,
      );

      final revertedProfile = _currentProfile!.copyWith(
        interests: revertedInterests,
      );
      
      _currentProfile = revertedProfile;
      emit(ProfileActionError('Failed to update connection status'));
      emit(ProfileLoaded(profile: revertedProfile, isOwnProfile: _isOwnProfile));
    }
  }
}

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (_currentProfile == null) return;

    emit(ProfileLoading());
    try {
      final updatedProfile = await profileRepo.updateProfile(event.updateData);
      _currentProfile = updatedProfile;
      emit(ProfileLoaded(profile: updatedProfile, isOwnProfile: true));
      emit(ProfileActionSuccess('Profile updated successfully'));
      emit(ProfileLoaded(profile: updatedProfile, isOwnProfile: true));
    } catch (e) {
      emit(ProfileActionError(e.toString()));
      emit(ProfileLoaded(profile: _currentProfile!, isOwnProfile: _isOwnProfile));
    }
  }

}
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repo/profile_repo.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileBloc)
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileBloc(this._profileRepo) : super(ProfileInitial()) {
    on<LoadMyProfile>(_onLoadMyProfile);
    on<LoadUserProfile>(_onLoadUserProfile);
    on<FollowUser>(_onFollowUser);
    on<UnfollowUser>(_onUnfollowUser);
    on<ConnectWithUser>(_onConnectWithUser);
    on<DisconnectFromUser>(_onDisconnectFromUser);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadMyProfile(
    LoadMyProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepo.getMyProfile();
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
      final profile = await _profileRepo.getUserProfile(event.userId);
      emit(ProfileLoaded(profile: profile, isOwnProfile: false));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onFollowUser(
    FollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(ProfileActionLoading(
      profile: currentState.profile,
      action: 'follow',
    ));

    try {
      await _profileRepo.followUser(event.userId);
      final updatedProfile = await _profileRepo.getUserProfile(event.userId);
      emit(ProfileLoaded(
        profile: updatedProfile,
        isOwnProfile: currentState.isOwnProfile,
      ));
      emit(ProfileActionSuccess(
        profile: updatedProfile,
        message: 'User followed successfully',
      ));
    } catch (e) {
      emit(ProfileActionError(
        profile: currentState.profile,
        message: e.toString(),
      ));
      emit(ProfileLoaded(
        profile: currentState.profile,
        isOwnProfile: currentState.isOwnProfile,
      ));
    }
  }

  Future<void> _onUnfollowUser(
    UnfollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(ProfileActionLoading(
      profile: currentState.profile,
      action: 'unfollow',
    ));

    try {
      await _profileRepo.unfollowUser(event.userId);
      final updatedProfile = await _profileRepo.getUserProfile(event.userId);
      emit(ProfileLoaded(
        profile: updatedProfile,
        isOwnProfile: currentState.isOwnProfile,
      ));
      emit(ProfileActionSuccess(
        profile: updatedProfile,
        message: 'User unfollowed successfully',
      ));
    } catch (e) {
      emit(ProfileActionError(
        profile: currentState.profile,
        message: e.toString(),
      ));
      emit(ProfileLoaded(
        profile: currentState.profile,
        isOwnProfile: currentState.isOwnProfile,
      ));
    }
  }

  Future<void> _onConnectWithUser(
    ConnectWithUser event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(ProfileActionLoading(
      profile: currentState.profile,
      action: 'connect',
    ));

    try {
      await _profileRepo.connectWithUser(event.userId);
      final updatedProfile = await _profileRepo.getUserProfile(event.userId);
      emit(ProfileLoaded(
        profile: updatedProfile,
        isOwnProfile: currentState.isOwnProfile,
      ));
      emit(ProfileActionSuccess(
        profile: updatedProfile,
        message: 'Connected successfully',
      ));
    } catch (e) {
      emit(ProfileActionError(
        profile: currentState.profile,
        message: e.toString(),
      ));
      emit(ProfileLoaded(
        profile: currentState.profile,
        isOwnProfile: currentState.isOwnProfile,
      ));
    }
  }

  Future<void> _onDisconnectFromUser(
    DisconnectFromUser event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(ProfileActionLoading(
      profile: currentState.profile,
      action: 'disconnect',
    ));

    try {
      await _profileRepo.disconnectFromUser(event.userId);
      final updatedProfile = await _profileRepo.getUserProfile(event.userId);
      emit(ProfileLoaded(
        profile: updatedProfile,
        isOwnProfile: currentState.isOwnProfile,
      ));
      emit(ProfileActionSuccess(
        profile: updatedProfile,
        message: 'Disconnected successfully',
      ));
    } catch (e) {
      emit(ProfileActionError(
        profile: currentState.profile,
        message: e.toString(),
      ));
      emit(ProfileLoaded(
        profile: currentState.profile,
        isOwnProfile: currentState.isOwnProfile,
      ));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(ProfileActionLoading(
      profile: currentState.profile,
      action: 'update',
    ));

    try {
      final updatedProfile = await _profileRepo.updateProfile(event.updateData);
      emit(ProfileLoaded(
        profile: updatedProfile,
        isOwnProfile: true,
      ));
      emit(ProfileActionSuccess(
        profile: updatedProfile,
        message: 'Profile updated successfully',
      ));
    } catch (e) {
      emit(ProfileActionError(
        profile: currentState.profile,
        message: e.toString(),
      ));
      emit(ProfileLoaded(
        profile: currentState.profile,
        isOwnProfile: currentState.isOwnProfile,
      ));
    }
  }
}
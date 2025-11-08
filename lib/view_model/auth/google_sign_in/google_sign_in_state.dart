part of 'google_sign_in_bloc.dart';

sealed class GoogleSignInState extends Equatable {
  const GoogleSignInState();
  
  @override
  List<Object> get props => [];
}

class GoogleSignInInitial extends GoogleSignInState {}

class GoogleSignInLoading extends GoogleSignInState {}

class GoogleSignInSuccess extends GoogleSignInState {
  final LoginResponse userData;
  const GoogleSignInSuccess(this.userData);
}

class GoogleSignInFailure extends GoogleSignInState {
  final String errorKey;
  const GoogleSignInFailure(this.errorKey);
}

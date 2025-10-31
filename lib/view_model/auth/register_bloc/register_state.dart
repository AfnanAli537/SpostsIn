// File: lib/blocs/auth/signup/signup_state.dart

part of 'register_bloc.dart';

abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final String userName;
  final UserType userType;
  final String? token;

  RegisterSuccessState({
    required this.userName,
    required this.userType,
    this.token,
  });
}

class RegisterFailureState extends RegisterState {
  final String error;

  RegisterFailureState(this.error);
}
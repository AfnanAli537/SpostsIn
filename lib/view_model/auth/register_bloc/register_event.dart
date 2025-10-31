// File: lib/blocs/auth/signup/signup_event.dart

part of 'register_bloc.dart';

abstract class RegisterEvent {}

class RegisterSubmittedEvent extends RegisterEvent {
  final UserType userType;
  final String email;
  final String password;
  final String confirmPassword;
  final Map<String, dynamic> userData;

  RegisterSubmittedEvent({
    required this.userType,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.userData,
  });
}

class RegisterResetEvent extends RegisterEvent {}

class InitialRegisterScreenEvent extends RegisterEvent {}
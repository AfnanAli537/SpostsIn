part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;
  LoginButtonPressed({required this.context, required this.email, required this.password});
}

class CheckLoginStatus extends LoginEvent {}

class LogoutRequested extends LoginEvent {}
class GoogleSignInRequested extends LoginEvent{}
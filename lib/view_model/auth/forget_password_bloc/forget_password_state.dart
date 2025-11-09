part of 'forget_password_bloc.dart';

@immutable
sealed class ForgetPasswordBlocState {}

class ForgotPasswordInitial extends ForgetPasswordBlocState {}

class ForgotPasswordLoading extends ForgetPasswordBlocState {}

class OtpSentSuccess extends ForgetPasswordBlocState {
  final String email;
  OtpSentSuccess({required this.email});
}

class OtpVerifiedSuccess extends ForgetPasswordBlocState {
  final String email;
  final String otp;
  OtpVerifiedSuccess({required this.otp, required this.email});
}

class PasswordResetSuccess extends ForgetPasswordBlocState {}

class ForgotPasswordFailure extends ForgetPasswordBlocState {
  final String message;
  ForgotPasswordFailure({ required this.message});
}

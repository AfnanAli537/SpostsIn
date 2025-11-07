part of 'forget_password_bloc.dart';

@immutable
sealed class ForgetPasswordBlocState {}

class ForgotPasswordInitial extends ForgetPasswordBlocState {}

class ForgotPasswordLoading extends ForgetPasswordBlocState {}

class OtpSentSuccess extends ForgetPasswordBlocState {
  final String email;
  OtpSentSuccess(this.email);
}

class OtpVerifiedSuccess extends ForgetPasswordBlocState {
  final String email;
  OtpVerifiedSuccess(this.email);
}

class PasswordResetSuccess extends ForgetPasswordBlocState {}

class ForgotPasswordFailure extends ForgetPasswordBlocState {
  final String message;
  ForgotPasswordFailure(this.message);
}

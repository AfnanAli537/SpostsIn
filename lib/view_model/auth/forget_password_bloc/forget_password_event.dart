part of 'forget_password_bloc.dart';

@immutable
sealed class ForgetPasswordBlocEvent {}

class SendOtpEvent extends ForgetPasswordBlocEvent {
  final String email;
  SendOtpEvent(this.email);
}

class VerifyOtpEvent extends ForgetPasswordBlocEvent {
  final String email;
  final String otp;
  VerifyOtpEvent(this.email, this.otp);
}

class ResetPasswordEvent extends ForgetPasswordBlocEvent {
  final String email;
  final String newPassword;
  final String confirmPassword;
  ResetPasswordEvent(this.email, this.newPassword, this.confirmPassword);
}

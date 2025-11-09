part of 'forget_password_bloc.dart';

@immutable
sealed class ForgetPasswordBlocEvent {}

class SendOtpEvent extends ForgetPasswordBlocEvent {
  final String email;
  SendOtpEvent({required this.email});
}

class VerifyOtpEvent extends ForgetPasswordBlocEvent {
  final String email;
  final String otp;
  VerifyOtpEvent({required this.email,required this.otp});
}

class ResetPasswordEvent extends ForgetPasswordBlocEvent {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  ResetPasswordEvent({required this.otp, required this.email,required this.newPassword,required this.confirmPassword});
}

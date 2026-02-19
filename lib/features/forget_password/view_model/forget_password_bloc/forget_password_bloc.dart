import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/forget_password/data/repo/forget_password_repo.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgetPasswordBlocEvent, ForgetPasswordBlocState> {
  final ForgetPasswordRepo authRepo;

  ForgotPasswordBloc(this.authRepo) : super(ForgotPasswordInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<ForgetPasswordBlocState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final success = await authRepo.sendOtp(event.email);
      if (success) emit(OtpSentSuccess(email: event.email));
    } catch (e) {
      emit(ForgotPasswordFailure(
        message: e is ApiException ? e.message : e.toString(),
      ));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<ForgetPasswordBlocState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final verified = await authRepo.verifyOtp(event.email, event.otp);
      if (verified) emit(OtpVerifiedSuccess(email: event.email, otp: event.otp));
    } catch (e) {
      emit(ForgotPasswordFailure(
        message: e is ApiException ? e.message : e.toString(),
      ));
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<ForgetPasswordBlocState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final reset = await authRepo.resetPassword(
        event.email,
        event.otp,
        event.newPassword,
        event.confirmPassword,
      );
      if (reset) emit(PasswordResetSuccess());
    } catch (e) {
      emit(ForgotPasswordFailure(
        message: e is ApiException ? e.message : e.toString(),
      ));
    }
  }
}
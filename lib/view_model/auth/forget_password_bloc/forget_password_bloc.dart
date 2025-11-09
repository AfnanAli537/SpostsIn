// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:sports_in/data/repo/auth_repo.dart'; 
part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgetPasswordBlocEvent, ForgetPasswordBlocState> {
  final AuthRepo authRepo;

  ForgotPasswordBloc(this.authRepo) : super(ForgotPasswordInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  Future<void> _onSendOtp(
      SendOtpEvent event, Emitter<ForgetPasswordBlocState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      final success = await authRepo.sendOtp(event.email);
      if (success) {
        emit(OtpSentSuccess(email:event.email));
      } 
    } 
    on DioException catch (e) {
    emit(ForgotPasswordFailure(
      message: "${e.message}  :${e.error }",
    ));
  } catch (e) {
      emit(ForgotPasswordFailure(message: e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event, Emitter<ForgetPasswordBlocState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      final verified = await authRepo.verifyOtp(event.email, event.otp);
      if (verified) {
        emit(OtpVerifiedSuccess( email:event.email,otp: event.otp));
      } 
    } 
       on DioException catch (e) {
    emit(ForgotPasswordFailure(
      message: "${e.message}  :${e.error }",
    ));
  }catch (e) {
      emit(ForgotPasswordFailure(message:e.toString()));
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<ForgetPasswordBlocState> emit) async {
    emit(ForgotPasswordLoading());
    try {
      final reset = await authRepo.resetPassword(
        event.email,
        event.otp,
        event.newPassword,
        event.confirmPassword,
      );
      if (reset) {
        emit(PasswordResetSuccess());
      } 
    } 
       on DioException catch (e) {
    emit(ForgotPasswordFailure(
      message: "${e.message}  :${e.error }",
    ));
  }catch (e) {
      emit(ForgotPasswordFailure(message:  e.toString()));
    }
  }
}

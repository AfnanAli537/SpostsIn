import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/register/data/repo/register_repo.dart';
import 'package:sports_in/features/register/models/user_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterRepo repository;

  RegistrationBloc(this.repository) : super(RegistrationInitial()) {
    on<SubmitRegistrationEvent>(_onSubmitRegistration);
    on<VerifyRegistrationOtpEvent>(_onVerifyRegistrationOtp);
    on<CompleteRegistrationEvent>(_onCompleteRegistration);
    on<ResetValidationEvent>((event, emit) => emit(RegistrationInitial()));
  }

  // Step 1: Send OTP to email
  Future<void> _onSubmitRegistration(
    SubmitRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    final user = event.userData;

    try {
      emit(RegistrationLoading());
            debugPrint("user email: ${user.email}");

      // Send OTP to email
      final otpSent = await repository.sendRegistrationOtp(user.email);

      if (otpSent) {
        emit(RegistrationOtpSent(
          email: user.email,
          userData: user,
        ));
      debugPrint("OTP sent successfully for email: ${user.email}");
      } else {
        emit(const RegistrationError(errorKey: 'otpSendFailed'));
      }
    } on ApiException catch (apiError) {
      debugPrint("API Exception: ${apiError.message} [${apiError.key}]");

      emit(RegistrationError(
        errorKey: apiError.key,
        fallbackMessage: apiError.message,
      ));
    } catch (e) {
      debugPrint("Unexpected exception in BLoC: $e");

      emit(const RegistrationError(
        errorKey: 'unexpectedError',
        fallbackMessage: 'An unexpected error occurred',
      ));
    }
  }

  // Step 2: Verify OTP
  Future<void> _onVerifyRegistrationOtp(
    VerifyRegistrationOtpEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(RegistrationLoading());
      
      final verified = await repository.verifyRegistrationOtp(
        event.email,
        event.otp,
      );

      if (verified) {
        // After verification, proceed to complete registration
        add(CompleteRegistrationEvent(
          userData: event.userData,
          otp: event.otp,
        ));
      } else {
        emit(const RegistrationError(errorKey: 'otpVerificationFailed'));
      }
    } on ApiException catch (apiError) {
      debugPrint("API Exception: ${apiError.message} [${apiError.key}]");

      emit(RegistrationError(
        errorKey: apiError.key,
        fallbackMessage: apiError.message,
      ));
    } catch (e) {
      debugPrint("Unexpected exception in BLoC: $e");

      emit(const RegistrationError(
        errorKey: 'unexpectedError',
        fallbackMessage: 'An unexpected error occurred',
      ));
    }
  }

  // Step 3: Complete registration after OTP verification
  Future<void> _onCompleteRegistration(
    CompleteRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(RegistrationLoading());
      
      final success = await repository.register(event.userData);

      if (success) {
        emit(const RegistrationSuccess(messageKey: 'registrationSuccessful'));
      } else {
        emit(const RegistrationError(errorKey: 'registrationFailed'));
      }
    } on ApiException catch (apiError) {
      debugPrint("API Exception: ${apiError.message} [${apiError.key}]");

      emit(RegistrationError(
        errorKey: apiError.key,
        fallbackMessage: apiError.message,
      ));
    } catch (e) {
      debugPrint("Unexpected exception in BLoC: $e");

      emit(const RegistrationError(
        errorKey: 'unexpectedError',
        fallbackMessage: 'An unexpected error occurred',
      ));
    }
  }
}
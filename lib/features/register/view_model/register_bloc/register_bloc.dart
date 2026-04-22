import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/register/data/repo/register_repo.dart';
import 'package:sports_in/features/register/data/models/certification_model.dart';
import 'package:sports_in/features/register/data/models/user_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final RegisterRepo repository;

  RegistrationBloc(this.repository) : super(RegistrationInitial()) {
    on<SubmitRegistrationEvent>(_onSubmitRegistration);
    on<VerifyRegistrationOtpEvent>(_onVerifyRegistrationOtp);
    on<CompleteRegistrationEvent>(_onCompleteRegistration);
    on<ResetValidationEvent>((event, emit) => emit(RegistrationInitial()));
    on<LoadCertificationsEvent>(_onLoadCertifications);
  }

  Future<void> _onSubmitRegistration(
    SubmitRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(RegistrationLoading());
      final otpSent = await repository.sendRegistrationOtp(event.userData.email);
      if (otpSent) {
        emit(RegistrationOtpSent(email: event.userData.email, userData: event.userData));
      } else {
        emit(const RegistrationError(message: 'otpSendFailed'));
      }
    } catch (e) {
      emit(RegistrationError(message: e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onVerifyRegistrationOtp(
    VerifyRegistrationOtpEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      emit(RegistrationLoading());
      final verified = await repository.verifyRegistrationOtp(event.email, event.otp);
      if (verified) {
        add(CompleteRegistrationEvent(userData: event.userData, otp: event.otp));
      } else {
        emit(const RegistrationError(message: 'otpVerificationFailed'));
      }
    } catch (e) {
      emit(RegistrationError(message: e is ApiException ? e.message : e.toString()));
    }
  }

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
        emit(const RegistrationError(message: 'registrationFailed'));
      }
    } catch (e) {
      emit(RegistrationError(message: e is ApiException ? e.message : e.toString()));
    }
  }
  Future<void> _onLoadCertifications(
  LoadCertificationsEvent event,
  Emitter<RegistrationState> emit,
) async {
  try {
    final certifications = await repository.getCertifications();
    emit(RegistrationCertificationsLoaded(certifications));
  } catch (e) {
    emit(RegistrationCertificationsError(e.toString()));
  }
}
}
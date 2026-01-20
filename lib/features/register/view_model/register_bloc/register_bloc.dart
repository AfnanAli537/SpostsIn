import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/register/models/user_model.dart';
import 'package:sports_in/data/repo/auth_repo.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepo repository;

  RegistrationBloc(this.repository) : super(RegistrationInitial()) {
    on<SubmitRegistrationEvent>(_onSubmitRegistration);
    on<ResetValidationEvent>((event, emit) => emit(RegistrationInitial()));
  }

  Future<void> _onSubmitRegistration(
    SubmitRegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) async {
    final user = event.userData;

    try {
      emit(RegistrationLoading());
      final success = await repository.registerUser(user);

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
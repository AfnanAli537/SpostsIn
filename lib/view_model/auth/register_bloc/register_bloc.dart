// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:sports_in/data/models/user_model.dart';
// import 'package:sports_in/data/repo/auth_repo.dart';

// part 'register_event.dart';
// part 'register_state.dart';

// class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
//   final AuthRepo repository;

//   RegistrationBloc(this.repository) : super(RegistrationInitial()) {
//     on<SubmitRegistrationEvent>(_onSubmitRegistration);
//     on<ResetValidationEvent>((event, emit) => emit(RegistrationInitial()));
//   }
// Future<void> _onSubmitRegistration(
//   SubmitRegistrationEvent event,
//   Emitter<RegistrationState> emit,
// ) async {
//   final user = event.userData;

//   try {
//     emit(RegistrationLoading());
//     final success = await repository.registerUser(user);
//     if (success) {
//       emit(const RegistrationSuccess(message: "Registration successful!"));
//     } else {
//       emit(const RegistrationError("Registration failed. Please try again."));
//     }
//   } catch (e) {
//     debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> api error >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//     emit(RegistrationError(e.toString()));
//   }
// }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/data/models/user_model.dart';
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
        // Emit success with a key that UI will translate
        emit(const RegistrationSuccess(messageKey: 'registrationSuccessful'));
      } else {
        emit(const RegistrationError(errorKey: 'registrationFailed'));
      }
    } on ApiException catch (apiError) {
      debugPrint("API Exception: ${apiError.message} [${apiError.key}]");

      // Emit error with the key and the raw message as fallback
      emit(RegistrationError(
        errorKey: apiError.key,
        fallbackMessage: apiError.message,
      ));
    } catch (e) {
      debugPrint("Unexpected exception in BLoC: $e");

      // This should rarely happen now, but handle it gracefully
      emit(const RegistrationError(
        errorKey: 'unexpectedError',
        fallbackMessage: 'An unexpected error occurred',
      ));
    }
  }
}
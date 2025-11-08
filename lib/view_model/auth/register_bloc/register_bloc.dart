import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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
  // final localizations = S.current;

  // final validationError = _validateUserData(user, localizations);
  // if (validationError != null) {
  //   emit(RegistrationValidationError(validationError));
  //   return;
  // }

  try {
    emit(RegistrationLoading());
    final success = await repository.registerUser(user);
    if (success) {
      emit(const RegistrationSuccess(message: "Registration successful!"));
    } else {
      emit(const RegistrationError("Registration failed. Please try again."));
    }
  } catch (e) {
    debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> api error >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    emit(RegistrationError(e.toString()));
  }
}
}
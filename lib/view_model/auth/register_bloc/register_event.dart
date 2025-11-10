part of 'register_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class SubmitRegistrationEvent extends RegistrationEvent {
  final UserModel userData;

  const SubmitRegistrationEvent({
    required this.userData,
  });

  @override
  List<Object?> get props => [userData];
}

class ResetValidationEvent extends RegistrationEvent {
  const ResetValidationEvent();
}
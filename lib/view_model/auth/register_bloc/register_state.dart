part of 'register_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String? message;
  
  const RegistrationSuccess({this.message});
  
  @override
  List<Object?> get props => [message];
}

class RegistrationValidationError extends RegistrationState {
  final String message;

  const RegistrationValidationError(this.message);

  @override
  List<Object?> get props => [message];
}

class RegistrationError extends RegistrationState {
  final String message;

  const RegistrationError(this.message);

  @override
  List<Object?> get props => [message];
}

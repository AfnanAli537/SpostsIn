// part of 'register_bloc.dart';

// abstract class RegistrationState extends Equatable {
//   const RegistrationState();

//   @override
//   List<Object?> get props => [];
// }

// class RegistrationInitial extends RegistrationState {}

// class RegistrationLoading extends RegistrationState {}

// class RegistrationSuccess extends RegistrationState {
//   final String? message;
  
//   const RegistrationSuccess({this.message});
  
//   @override
//   List<Object?> get props => [message];
// }

// class RegistrationValidationError extends RegistrationState {
//   final String message;

//   const RegistrationValidationError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// class RegistrationError extends RegistrationState {
//   final String message;

//   const RegistrationError(this.message);

//   @override
//   List<Object?> get props => [message];
// }
part of 'register_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
  
  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String messageKey;
  final String? fallbackMessage;

  const RegistrationSuccess({
    required this.messageKey,
    this.fallbackMessage,
  });

  @override
  List<Object?> get props => [messageKey, fallbackMessage];
}

class RegistrationError extends RegistrationState {
  final String errorKey;
  final String? fallbackMessage;

  const RegistrationError({
    required this.errorKey,
    this.fallbackMessage,
  });

  @override
  List<Object?> get props => [errorKey, fallbackMessage];
}
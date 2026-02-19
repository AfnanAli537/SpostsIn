part of 'register_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
  
  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

// New state for OTP sent
class RegistrationOtpSent extends RegistrationState {
  final String email;
  final UserModel userData; // Store user data to complete registration after OTP verification

  const RegistrationOtpSent({
    required this.email,
    required this.userData,
  });

  @override
  List<Object?> get props => [email, userData];
}

// New state for OTP verified
class RegistrationOtpVerified extends RegistrationState {
  final UserModel userData;
  final String otp;

  const RegistrationOtpVerified({
    required this.userData,
    required this.otp,
  });

  @override
  List<Object?> get props => [userData, otp];
}

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
  final String message;
  const RegistrationError({required this.message});

  @override
  List<Object?> get props => [message];
}
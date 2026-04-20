part of 'register_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

// Modified to send OTP instead of direct registration
class SubmitRegistrationEvent extends RegistrationEvent {
  final UserModel userData;

  const SubmitRegistrationEvent({
    required this.userData,
  });

  @override
  List<Object?> get props => [userData];
}

// New event to verify OTP
class VerifyRegistrationOtpEvent extends RegistrationEvent {
  final String email;
  final String otp;
  final UserModel userData;

  const VerifyRegistrationOtpEvent({
    required this.email,
    required this.otp,
    required this.userData,
  });

  @override
  List<Object?> get props => [email, otp, userData];
}

// New event to complete registration after OTP verification
class CompleteRegistrationEvent extends RegistrationEvent {
  final UserModel userData;
  final String otp;

  const CompleteRegistrationEvent({
    required this.userData,
    required this.otp,
  });

  @override
  List<Object?> get props => [userData, otp];
}

class ResetValidationEvent extends RegistrationEvent {
  const ResetValidationEvent();
}
class LoadCertificationsEvent extends RegistrationEvent {
  const LoadCertificationsEvent();
}
// part of 'register_bloc.dart';

// abstract class RegistrationEvent extends Equatable {
//   const RegistrationEvent();
// }

// class SubmitRegistrationEvent extends RegistrationEvent {
//   final UserModel userData;
//   final dynamic localizations; // S type from generated/l10n.dart

//   const SubmitRegistrationEvent({
//     required this.userData,
//     required this.localizations,
//   });

//   @override
//   List<Object?> get props => [userData, localizations];
// }

// class ResetValidationEvent extends RegistrationEvent {
//   const ResetValidationEvent();

//   @override
//   List<Object?> get props => [];
// }
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
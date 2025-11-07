import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/data/data_sources/register_lists.dart';
import 'package:sports_in/data/models/user_model.dart';
import 'package:sports_in/data/repo/auth_repo.dart';
import 'package:sports_in/core/utils/validators/regex.dart'; 
import 'package:sports_in/generated/l10n.dart'; 

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
  final localizations = S.current;

  final validationError = _validateUserData(user, localizations);
  if (validationError != null) {
    emit(RegistrationValidationError(validationError));
    return;
  }

  emit(RegistrationLoading());

  try {
    final success = await repository.registerUser(user);

    if (success) {
      emit(const RegistrationSuccess(message: "Registration successful!"));
    } else {
      emit(const RegistrationError("Registration failed. Please try again."));
    }
  } catch (e) {
    emit(RegistrationError(e.toString()));
  }
}


  /// ✅ Centralized validation logic (using Validators class)
  String? _validateUserData(UserModel user, S localizations) {
    // --- Type-specific Validations ---
    switch (user.userType) {
      case UserType.player:
        return _validatePlayerData(user, localizations);
      case UserType.coach:
      case UserType.scout:
        return _validateCoachAndScoutData(user, localizations);
      case UserType.club:
        return _validateClubData(user, localizations);
      case UserType.institute:
        return _validateInstituteData(user, localizations);
      case UserType.others:
        // optional generic check
        return _validateOtherData(user, localizations);
    }
  }

  // ==================== PLAYER ====================
  String? _validatePlayerData(UserModel user, S s) {
        // --- Common Validations ---
    final firstNameResult =
        Validators.validateNameBLoC(user.firstName, s, fieldName: s.firstName);
    if (!firstNameResult.isValid) return firstNameResult.errorMessage;

    final lastNameResult =
        Validators.validateNameBLoC(user.lastName, s, fieldName: s.lastName);
    if (!lastNameResult.isValid) return lastNameResult.errorMessage;

    final emailResult = Validators.validateEmailBLoC(user.email, s);
    if (!emailResult.isValid) return emailResult.errorMessage;

    final passwordResult =
        Validators.validatePasswordBLoC(user.password, s);
    if (!passwordResult.isValid) return passwordResult.errorMessage;

    final confirmPasswordResult =
        Validators.validateConfirmPasswordBLoC(user.confirmPassword, s, password: user.password);
    if (!confirmPasswordResult.isValid) return confirmPasswordResult.errorMessage;
    // ---------------------------

    final heightResult = Validators.validateHeightBLoC(user.height, s);
    if (!heightResult.isValid) return heightResult.errorMessage;

    final weightResult = Validators.validateWeightBLoC(user.weight, s);
    if (!weightResult.isValid) return weightResult.errorMessage;

    final ageResult = Validators.validateWeightBLoC(user.age, s);
    if (!ageResult.isValid) return ageResult.errorMessage;

    final genderResult = Validators.validateDropdownBLoC(user.gender, s, fieldName: s.gender);
    if (!genderResult.isValid) return genderResult.errorMessage;

    final locationResult = Validators.validateDropdownBLoC(user.location, s, fieldName: s.location);
    if (!locationResult.isValid) return locationResult.errorMessage;

    final sportResult = Validators.validateDropdownBLoC(user.sport, s, fieldName: s.sportProfession);
    if (!sportResult.isValid) return sportResult.errorMessage;
    if (RegisterLists.isTeamSport(s, user.sport)) {
  final positionResult = Validators.validateDropdownBLoC(
    user.position,
    s,
    fieldName: s.position,
  );
  if (!positionResult.isValid) return positionResult.errorMessage;
}

    return null;
  }

  // ==================== COACH and SCOUT ====================
  String? _validateCoachAndScoutData(UserModel user, S s) {
        // --- Common Validations ---
    final firstNameResult =
        Validators.validateNameBLoC(user.firstName, s, fieldName: s.firstName);
    if (!firstNameResult.isValid) return firstNameResult.errorMessage;

    final lastNameResult =
        Validators.validateNameBLoC(user.lastName, s, fieldName: s.lastName);
    if (!lastNameResult.isValid) return lastNameResult.errorMessage;

    final emailResult = Validators.validateEmailBLoC(user.email, s);
    if (!emailResult.isValid) return emailResult.errorMessage;

    final passwordResult =
        Validators.validatePasswordBLoC(user.password, s);
    if (!passwordResult.isValid) return passwordResult.errorMessage;

    final confirmPasswordResult =
        Validators.validateConfirmPasswordBLoC(user.confirmPassword, s, password: user.password);
    if (!confirmPasswordResult.isValid) return confirmPasswordResult.errorMessage;
    
    final genderResult = Validators.validateDropdownBLoC(user.gender, s, fieldName: s.gender);
    if (!genderResult.isValid) return genderResult.errorMessage;
    // ---------------------------
    final specResult = Validators.validateRequiredBLoC(user.sport, s, fieldName: s.specializedSport);
    if (!specResult.isValid) return specResult.errorMessage;

     final locationResult = Validators.validateDropdownBLoC(user.location, s, fieldName: s.location);
    if (!locationResult.isValid) return locationResult.errorMessage;

    final expResult = Validators.validateExperienceBLoC(user.experienceYears, s);
    if (!expResult.isValid) return expResult.errorMessage;
    return null;
  }

  // ==================== CLUB ====================
  String? _validateClubData(UserModel user, S s) {
    final clubNameResult =
        Validators.validateNameBLoC(user.clubName, s, fieldName: s.clubName);
    if (!clubNameResult.isValid) return clubNameResult.errorMessage;

    final emailResult = Validators.validateEmailBLoC(user.email, s);
    if (!emailResult.isValid) return emailResult.errorMessage;

    final passwordResult =
        Validators.validatePasswordBLoC(user.password, s);
    if (!passwordResult.isValid) return passwordResult.errorMessage;

    final confirmPasswordResult =
        Validators.validateConfirmPasswordBLoC(user.confirmPassword, s, password: user.password);
    if (!confirmPasswordResult.isValid) return confirmPasswordResult.errorMessage;
    
    final locationResult = Validators.validateDropdownBLoC(user.location, s, fieldName: s.location);
    if (!locationResult.isValid) return locationResult.errorMessage;

    final dateResult = Validators.validateDateBLoC(user.foundDate, s);
    if (!dateResult.isValid) return dateResult.errorMessage;

    final sportsResult = Validators.validateListBLoC(user.sports, s, fieldName: s.sport);
    if (!sportsResult.isValid) return sportsResult.errorMessage;

    return null;
  }

  // ==================== INSTITUTE ====================
  String? _validateInstituteData(UserModel user, S s) {
    final instituteNameResult =
        Validators.validateNameBLoC(user.instituteName, s, fieldName: s.instituteName);
    if (!instituteNameResult.isValid) return instituteNameResult.errorMessage;

    final emailResult = Validators.validateEmailBLoC(user.email, s);
    if (!emailResult.isValid) return emailResult.errorMessage;

    final passwordResult =
        Validators.validatePasswordBLoC(user.password, s);
    if (!passwordResult.isValid) return passwordResult.errorMessage;

    final confirmPasswordResult =
        Validators.validateConfirmPasswordBLoC(user.confirmPassword, s, password: user.password);
    if (!confirmPasswordResult.isValid) return confirmPasswordResult.errorMessage;
    
    final locationResult = Validators.validateDropdownBLoC(user.location, s, fieldName: s.location);
    if (!locationResult.isValid) return locationResult.errorMessage;

    final industryResult = Validators.validateRequiredBLoC(user.industry, s, fieldName: s.industary);
    if (!industryResult.isValid) return industryResult.errorMessage;

    return null;
  }
   // ==================== PLAYER ====================
  String? _validateOtherData(UserModel user, S s) {
        // --- Common Validations ---
    final firstNameResult =
        Validators.validateNameBLoC(user.firstName, s, fieldName: s.firstName);
    if (!firstNameResult.isValid) return firstNameResult.errorMessage;

    final lastNameResult =
        Validators.validateNameBLoC(user.lastName, s, fieldName: s.lastName);
    if (!lastNameResult.isValid) return lastNameResult.errorMessage;

    final emailResult = Validators.validateEmailBLoC(user.email, s);
    if (!emailResult.isValid) return emailResult.errorMessage;

    final passwordResult =
        Validators.validatePasswordBLoC(user.password, s);
    if (!passwordResult.isValid) return passwordResult.errorMessage;

    final confirmPasswordResult =
        Validators.validateConfirmPasswordBLoC(user.confirmPassword, s, password: user.password);
    if (!confirmPasswordResult.isValid) return confirmPasswordResult.errorMessage;
    final genderResult = Validators.validateDropdownBLoC(user.gender, s, fieldName: s.gender);
    if (!genderResult.isValid) return genderResult.errorMessage;
    final locationResult = Validators.validateDropdownBLoC(user.location, s, fieldName: s.location);
    if (!locationResult.isValid) return locationResult.errorMessage;
    return null;
  }

}

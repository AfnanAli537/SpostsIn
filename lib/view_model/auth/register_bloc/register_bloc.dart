// // File: lib/blocs/auth/signup/signup_bloc.dart

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/data/models/user_model.dart';
// import 'package:sports_in/data/repo/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

// class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
//   final AuthRepository _authRepository;

//   RegisterBloc(this._authRepository) : super(RegisterInitialState()) {
//     on<RegisterSubmittedEvent>(_onRegisterSubmitted);
//     on<RegisterResetEvent>(_onRegisterReset);
//     on<InitialRegisterScreenEvent>(_onRegisterInit);
//   }

//   Future<void> _onRegisterSubmitted(
//     RegisterSubmittedEvent event,
//     Emitter<RegisterState> emit,
//   ) async {
//     emit(RegisterLoadingState());

//     try {
//       // Validate common fields
//       final emailError = Validators.validateEmail(event.email);
//       final passwordError = Validators.validatePassword(event.password);
//       final confirmPasswordError = Validators.validateConfirmPassword(
//         event.confirmPassword,
//         event.password,
//       );

//       if (emailError != null) {
//         emit(RegisterFailureState(emailError));
//         return;
//       }
//       if (passwordError != null) {
//         emit(RegisterFailureState(passwordError));
//         return;
//       }
//       if (confirmPasswordError != null) {
//         emit(RegisterFailureState(confirmPasswordError));
//         return;
//       }

//       // Validate user-specific fields based on userType
//       final validationError =
//           _validateUserSpecificData(event.userType, event.userData);
//       if (validationError != null) {
//         emit(RegisterFailureState(validationError));
//         return;
//       }

//       // Register user with appropriate endpoint based on userType
//       final response = await _registerUser(
//         userType: event.userType,
//         email: event.email,
//         password: event.password,
//         userData: event.userData,
//       );

//       if (response != null && response['success'] == true) {
//         emit(RegisterSuccessState(
//           userName: response['user']['name'] ?? 'User',
//           userType: event.userType,
//           token: response['token'],
//         ));
//       } else {
//         emit(RegisterFailureState(
//             response?['message'] ?? 'Failed to register. Please try again.'));
//       }
//     } catch (e) {
//       emit(RegisterFailureState(e.toString()));
//     }
//   }

//   // Validate user-specific data based on type
//   String? _validateUserSpecificData(
//       UserType userType, Map<String, dynamic> userData) {
//     switch (userType) {
//       case UserType.player:
//         if (userData['firstName'] == null || userData['firstName'].isEmpty) {
//           return 'First name is required';
//         }
//         if (userData['lastName'] == null || userData['lastName'].isEmpty) {
//           return 'Last name is required';
//         }
//         if (userData['height'] == null || userData['height'].isEmpty) {
//           return 'Height is required';
//         }
//         if (userData['weight'] == null || userData['weight'].isEmpty) {
//           return 'Weight is required';
//         }
//         if (userData['gender'] == null || userData['gender'].isEmpty) {
//           return 'Gender is required';
//         }
//         if (userData['location'] == null || userData['location'].isEmpty) {
//           return 'Location is required';
//         }
//         if (userData['sportPosition'] == null ||
//             userData['sportPosition'].isEmpty) {
//           return 'Sport profession is required';
//         }
//         if (userData['position'] == null || userData['position'].isEmpty) {
//           return 'Position is required';
//         }
//         break;

//       case UserType.coach:
//         if (userData['firstName'] == null || userData['firstName'].isEmpty) {
//           return 'First name is required';
//         }
//         if (userData['lastName'] == null || userData['lastName'].isEmpty) {
//           return 'Last name is required';
//         }
//         if (userData['yearsOfExperience'] == null ||
//             userData['yearsOfExperience'].isEmpty) {
//           return 'Years of experience is required';
//         }
//         if (userData['sportName'] == null || userData['sportName'].isEmpty) {
//           return 'Sport name is required';
//         }
//         if (userData['location'] == null || userData['location'].isEmpty) {
//           return 'Location is required';
//         }
//         if (userData['gender'] == null || userData['gender'].isEmpty) {
//           return 'Gender is required';
//         }
//         break;

//       case UserType.scout:
//       case UserType.club:
//       case UserType.institute:
//       case UserType.other:
//         // Add validation for other user types as needed
//         break;
//     }
//     return null;
//   }

//   // Register user with appropriate API endpoint
//   Future<Map<String, dynamic>?> _registerUser({
//     required UserType userType,
//     required String email,
//     required String password,
//     required Map<String, dynamic> userData,
//   }) async {
//     switch (userType) {
//       case UserType.player:
//         return await _authRepository.registerPlayer(
//           email: email,
//           password: password,
//           userData: userData,
//         );

//       case UserType.coach:
//         return await _authRepository.registerCoach(
//           email: email,
//           password: password,
//           userData: userData,
//         );

//       case UserType.scout:
//         return await _authRepository.registerScout(
//           email: email,
//           password: password,
//           userData: userData,
//         );

//       case UserType.club:
//         return await _authRepository.registerClub(
//           email: email,
//           password: password,
//           userData: userData,
//         );

//       case UserType.institute:
//         return await _authRepository.registerInstitute(
//           email: email,
//           password: password,
//           userData: userData,
//         );

//       case UserType.other:
//         return await _authRepository.registerOther(
//           email: email,
//           password: password,
//           userData: userData,
//         );
//     }
//   }

//   void _onRegisterReset(RegisterResetEvent event, Emitter<RegisterState> emit) {
//     emit(RegisterInitialState());
//   }

//   void _onRegisterInit(
//       InitialRegisterScreenEvent event, Emitter<RegisterState> emit) {
//     emit(RegisterInitialState());
//   }
// }
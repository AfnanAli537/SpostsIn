import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/data/repo/auth_repo.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepo repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<CheckLoginStatus>(_onCheckLoginStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
   final emailError = Validators.email(event.email);
    if (emailError != null) {
    emit(LoginFailure(emailError: emailError));
      return;
    }

    final passwordError = Validators.password(event.password);
    if (passwordError != null) {
      emit(LoginFailure(passwordError:passwordError));
      return;
    }

    emit(LoginLoading());
    try {
      final response = await repository.login(
        email: event.email,
        password: event.password,
      );
        final token =response.token;
         if (token != null && token.isNotEmpty) {
        await SharedPref.saveToken(token); 
      }
      emit(LoginSuccess(response.token));
    } catch (e) {
      emit(LoginFailure(generalError: e.toString()));
    }
  }


  Future<void> _onCheckLoginStatus(
    CheckLoginStatus event,
    Emitter<LoginState> emit,
  ) async {
    final token = await SharedPref.getToken();
    final expiryString = await SharedPref.getExpiryDate();

    if (token == null || expiryString == null) {
      emit(LoginInitial());
      return;
    }

    final expiryDate = DateTime.tryParse(expiryString);
    if (expiryDate == null || DateTime.now().isAfter(expiryDate)) {
      await SharedPref.clearToken();
      emit(LoginInitial());
    } else {
      emit(LoginSuccess(token));
    }
  }


  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    await SharedPref.clearToken();
    emit(LoginInitial());
  }


}

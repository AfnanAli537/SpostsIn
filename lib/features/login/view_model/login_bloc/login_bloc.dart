// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/login/data/repo/login_repo.dart';
import 'package:sports_in/features/login/model/login_response_model.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final sharedPref = getIt<SharedPref>();
  final LoginRepo repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<CheckLoginStatus>(_onCheckLoginStatus);
    on<LogoutRequested>(_onLogoutRequested);
     on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await repository.login(
        context:event.context ,
        email: event.email,
        password: event.password,
      );
        final token =response.token;
         if (token != null && token.isNotEmpty) {
        await sharedPref.saveToken(token); 
         print('Token saved: $token');
      }
      emit(LoginSuccess(response.token));
    } catch (e) {
      emit(LoginFailure(generalError:e.toString()));
    }
  }


  Future<void> _onCheckLoginStatus(
    CheckLoginStatus event,
    Emitter<LoginState> emit,
  ) async {
    final token = await sharedPref.getToken();
    final expiryString = await sharedPref.getExpiryDate();

    if (token == null || expiryString == null) {
      emit(LoginInitial());
      return;
    }

    final expiryDate = DateTime.tryParse(expiryString);
    if (expiryDate == null || DateTime.now().isAfter(expiryDate)) {
      await sharedPref.clearToken();
      emit(LoginInitial());
    } else {
      emit(LoginSuccess(token));
    }
  }


  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    await sharedPref.clearToken();
    emit(LoginInitial());
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(GoogleSignInLoading());
    try {
      final LoginResponse user = await repository.loginWithGoogle();
      emit(GoogleSignInSuccess(user));
    } catch (e) {
      emit(GoogleSignInFailure(e.toString()));
    }
  }
}

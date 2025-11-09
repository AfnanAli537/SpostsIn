// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/data/models/login_response_model.dart';
import 'package:sports_in/data/repo/auth_repo.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepo repository;

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
        await SharedPref.saveToken(token); 
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

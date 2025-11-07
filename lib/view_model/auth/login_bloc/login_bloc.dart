import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
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
    emit(LoginLoading());
  //   print("🔹 Current state: $state");
  //   print('🔹 Login event received');
  // print('Email: ${event.email}');
  // print('Password: ${event.password}');
    try {
      final response = await repository.login(
        context:event.context ,
        email: event.email,
        password: event.password,
      );
      //  print('🔹 Response from repository: $response');
        final token =response.token;
         if (token != null && token.isNotEmpty) {
        await SharedPref.saveToken(token); 
         print('✅ Token saved: $token');
      }
      // else{
      //   print('⚠️ No token received!');
      // }
      emit(LoginSuccess(response.token));
      // print("🔹 Current state: $state");
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


}

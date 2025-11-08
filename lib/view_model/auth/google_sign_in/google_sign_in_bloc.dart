import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/data/models/login_response_model.dart';
import 'package:sports_in/data/repo/auth_repo.dart';
part 'google_sign_in_event.dart';
part 'google_sign_in_state.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  final AuthRepo _repo;

  GoogleSignInBloc(this._repo) : super(GoogleSignInInitial()) {
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<GoogleSignInState> emit,
  ) async {
    emit(GoogleSignInLoading());
    try {
      final LoginResponse user = await _repo.loginWithGoogle();
      emit(GoogleSignInSuccess(user));
    } catch (e) {
      emit(GoogleSignInFailure(e.toString()));
    }
  }
}

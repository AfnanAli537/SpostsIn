import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'forget_password_event.dart';
part 'forget_password_state.dart';

class ForgetPasswordBlocBloc extends Bloc<ForgetPasswordBlocEvent, ForgetPasswordBlocState> {
  ForgetPasswordBlocBloc() : super(ForgetPasswordBlocInitial()) {
    on<ForgetPasswordBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

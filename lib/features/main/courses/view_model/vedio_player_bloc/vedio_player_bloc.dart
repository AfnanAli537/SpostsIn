import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vedio_player_event.dart';
part 'vedio_player_state.dart';

class VedioPlayerBloc extends Bloc<VedioPlayerEvent, VedioPlayerState> {
  VedioPlayerBloc() : super(VedioPlayerInitial());

  @override
  Stream<VedioPlayerState> mapEventToState(
    VedioPlayerEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}

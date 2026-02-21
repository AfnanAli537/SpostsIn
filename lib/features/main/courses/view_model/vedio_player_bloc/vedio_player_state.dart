part of 'vedio_player_bloc.dart';

abstract class VedioPlayerState extends Equatable {
  const VedioPlayerState();
  
  @override
  List<Object> get props => [];
}

class VedioPlayerInitial extends VedioPlayerState {}

part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetFavoriteSightingsEvent extends HomeEvent {}

class ShowErrorEvent extends HomeEvent {
  ShowErrorEvent({required this.message, this.code});

  final String message;
  final int? code;

  @override
  List<Object?> get props => [message, props];
}

class ChangeTabBarIndexEvent extends HomeEvent {
  ChangeTabBarIndexEvent({required this.index});

  final int index;
}

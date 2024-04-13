// home_page_event.dart
part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class EntryButtonPressed extends HomeEvent {
  @override
  List<Object> get props => [];
}

class ExitButtonPressed extends HomeEvent {
  @override
  List<Object> get props => [];
}

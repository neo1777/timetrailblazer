part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {}

class EntryButtonPressed extends HomeEvent {}

class ExitButtonPressed extends HomeEvent {}

class HomeDatabaseUpdated extends HomeEvent {
  final String lastEntryType;
  HomeDatabaseUpdated(this.lastEntryType);
}

class DatabaseReset extends HomeEvent {}

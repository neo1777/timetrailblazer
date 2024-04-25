import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
class HomeStarted extends HomeEvent {}
class EntryButtonPressed extends HomeEvent {}

class ExitButtonPressed extends HomeEvent {}

// Evento inviato quando il database viene aggiornato con un nuovo tipo di voce
class HomeDatabaseUpdated extends HomeEvent {
  final String lastEntryType;

  HomeDatabaseUpdated(this.lastEntryType);

  @override
  List<Object?> get props => [lastEntryType];
}

class DatabaseReset extends HomeEvent {}

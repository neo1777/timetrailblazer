part of 'home_bloc.dart';

/// La classe astratta `HomeEvent` rappresenta gli eventi che possono essere gestiti dal `HomeBloc`.
/// Questi eventi sono utilizzati per comunicare le interazioni dell'utente o le modifiche di stato al bloc.
abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {}

class EntryButtonPressed extends HomeEvent {}

class ExitButtonPressed extends HomeEvent {}

/// L'evento `HomeDatabaseUpdated` viene emesso quando il database delle voci di lavoro viene aggiornato.
///
/// Contiene la proprietà `lastEntryType` che rappresenta il tipo dell'ultima voce di lavoro registrata (entrata o uscita).
/// Questa informazione viene utilizzata dal bloc per aggiornare lo stato dell'interfaccia utente in base all'ultima voce.
class HomeDatabaseUpdated extends HomeEvent {
  final String lastEntryType;
  HomeDatabaseUpdated(this.lastEntryType);
}

class DatabaseReset extends HomeEvent {}

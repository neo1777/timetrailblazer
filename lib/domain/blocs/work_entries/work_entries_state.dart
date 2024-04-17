part of 'work_entries_bloc.dart';

/// Classe astratta che rappresenta uno stato del `WorkEntriesBloc`.
abstract class WorkEntriesState extends Equatable {
  const WorkEntriesState();
}

/// Stato iniziale del `WorkEntriesBloc`.
class WorkEntriesInitial extends WorkEntriesState {
  @override
  List<Object> get props => [];
}

/// Stato che rappresenta il caricamento delle voci di lavoro.
class WorkEntriesLoading extends WorkEntriesState {
  @override
  List<Object> get props => [];
}

/// Stato che rappresenta le voci di lavoro caricate.
class WorkEntriesLoaded extends WorkEntriesState {
  /// La lista delle voci di lavoro caricate.
  final List<WorkEntry> entries;
  
  /// Le voci di lavoro raggruppate per giorno.
  final Map<DateTime, List<WorkEntry>> entriesGroupedByDay;
  
  /// La data di inizio dell'intervallo di date.
  final DateTime startDate;
  
  /// La data di fine dell'intervallo di date.
  final DateTime endDate;

  const WorkEntriesLoaded(this.entries, this.entriesGroupedByDay, this.startDate, this.endDate);

  @override
  List<Object> get props => [entries, entriesGroupedByDay, startDate, endDate];
}

/// Stato che rappresenta un errore durante il caricamento delle voci di lavoro.
class WorkEntriesError extends WorkEntriesState {
  /// Il messaggio di errore.
  final String message;

  const WorkEntriesError(this.message);

  @override
  List<Object> get props => [message];
}

/// Stato che rappresenta l'aggiornamento dell'intervallo di date di inizio e fine.
class WorkEntriesDateRangeUpdated extends WorkEntriesState {
  final DateTime startDate; // La nuova data di inizio (può essere null)
  final DateTime endDate; // La nuova data di fine (può essere null)

  const WorkEntriesDateRangeUpdated(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

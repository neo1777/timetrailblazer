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
  final List<WorkEntry> entries;
  final Map<DateTime, List<WorkEntry>> entriesGroupedByDay;

  const WorkEntriesLoaded(this.entries, this.entriesGroupedByDay);

  @override
  List<Object> get props => [entries, entriesGroupedByDay];
}

/// Stato che rappresenta un errore durante il caricamento delle voci di lavoro.
class WorkEntriesError extends WorkEntriesState {
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

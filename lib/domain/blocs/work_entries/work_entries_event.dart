part of 'work_entries_bloc.dart';

abstract class WorkEntriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento per richiedere il caricamento delle voci di lavoro per un dato intervallo di date
class FetchWorkEntries extends WorkEntriesEvent {
  final DateTime startDate;
  final DateTime endDate;

  FetchWorkEntries(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

// Evento inviato quando le voci di lavoro sono state aggiornate
class WorkEntriesUpdated extends WorkEntriesEvent {
  final List<WorkEntryModel> updatedEntries;

  WorkEntriesUpdated(this.updatedEntries);

  @override
  List<Object?> get props => [updatedEntries];
}

class ResetDatabase extends WorkEntriesEvent {
  final DateTime startDate;
  final DateTime endDate;

  ResetDatabase(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

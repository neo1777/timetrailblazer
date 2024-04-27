part of 'work_entries_bloc.dart';

abstract class WorkEntriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// L'evento [FetchWorkEntries] richiede il caricamento delle voci di lavoro per un dato intervallo di date.
///
/// Contiene le proprietà [startDate] e [endDate] che rappresentano l'intervallo di date per il quale caricare le voci di lavoro.
class FetchWorkEntries extends WorkEntriesEvent {
  final DateTime startDate;
  final DateTime endDate;

  FetchWorkEntries(this.startDate, this.endDate);
}

/// L'evento [WorkEntriesUpdated] viene emesso quando le voci di lavoro sono state aggiornate.
///
/// Contiene la proprietà [updatedEntries] che rappresenta la lista aggiornata delle voci di lavoro.
class WorkEntriesUpdated extends WorkEntriesEvent {
  final List<WorkEntryModel> updatedEntries;

  WorkEntriesUpdated(this.updatedEntries);
}

/// L'evento [ResetDatabase] richiede il reset del database per un dato intervallo di date.
///
/// Contiene le proprietà [startDate] e [endDate] che rappresentano l'intervallo di date per il quale resettare le voci di lavoro.
class ResetDatabase extends WorkEntriesEvent {
  final DateTime startDate;
  final DateTime endDate;

  ResetDatabase(this.startDate, this.endDate);
}

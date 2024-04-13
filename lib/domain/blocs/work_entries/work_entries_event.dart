part of 'work_entries_bloc.dart';

/// Classe astratta che rappresenta un evento del `WorkEntriesBloc`.
abstract class WorkEntriesEvent extends Equatable {
  const WorkEntriesEvent();
}

/// Evento per recuperare le voci di lavoro.
class FetchWorkEntries extends WorkEntriesEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FetchWorkEntries({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [
        startDate,
        endDate,
      ];
}

/// Evento per aggiungere una nuova voce di lavoro.
class AddWorkEntry extends WorkEntriesEvent {
  final WorkEntry entry;

  const AddWorkEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

/// Evento per aggiornare una voce di lavoro esistente.
class UpdateWorkEntry extends WorkEntriesEvent {
  final WorkEntry entry;

  const UpdateWorkEntry(this.entry);

  @override
  List<Object> get props => [entry];
}

/// Evento per eliminare una voce di lavoro.
class DeleteWorkEntry extends WorkEntriesEvent {
  final int entryId;
  final DateTime day;

  const DeleteWorkEntry(this.entryId, this.day);

  @override
  List<Object> get props => [entryId, day];
}

/// Evento per eliminare tutte le voci di lavoro.
class DeleteAllWorkEntries extends WorkEntriesEvent {
  final DateTime startDate;
  final DateTime endDate;

  const DeleteAllWorkEntries(this.startDate, this.endDate);

  @override
  List<Object> get props => [startDate, endDate];
}

/// Evento per aggiornare l'intervallo di date di inizio e fine.
class UpdateDateRange extends WorkEntriesEvent {
  final DateTime startDate;
  final DateTime endDate;

  const UpdateDateRange(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

part of 'work_entries_bloc.dart';

/// Rappresenta un evento del BLoC `WorkEntriesBloc`.
abstract class WorkEntriesEvent extends Equatable {
  const WorkEntriesEvent();

  @override
  List<Object> get props => [];
}

/// Rappresenta l'evento di cancellazione/reset del database.
class ResetDatabase extends WorkEntriesEvent {
  final DateTime startDate;
  final DateTime endDate;

  const ResetDatabase({
    required this.startDate,
    required this.endDate,
  });
}

/// Rappresenta l'evento di cancellazione di una singola voce di lavoro.
class DeleteWorkEntry extends WorkEntriesEvent {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  const DeleteWorkEntry({
    required this.id,
    required this.startDate,
    required this.endDate,
  });
}

/// Rappresenta l'evento di richiesta delle voci di lavoro per un intervallo di date.
class FetchWorkEntries extends WorkEntriesEvent {
  /// La data di inizio dell'intervallo.
  final DateTime startDate;

  /// La data di fine dell'intervallo.
  final DateTime endDate;

  const FetchWorkEntries({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}

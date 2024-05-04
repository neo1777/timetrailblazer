import 'package:equatable/equatable.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';

/// La classe base astratta per gli eventi del BLoC `WorkEntriesBloc`.
abstract class WorkEntriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// L'evento che richiede il caricamento delle voci di lavoro per un dato intervallo di date.
class FetchWorkEntries extends WorkEntriesEvent {
  /// La data di inizio dell'intervallo.
  final DateTime startDate;

  /// La data di fine dell'intervallo.
  final DateTime endDate;

  FetchWorkEntries(this.startDate, this.endDate);

  @override
  List<Object?> get props => [startDate, endDate];
}

/// L'evento che indica che le voci di lavoro sono state aggiornate.
class WorkEntriesUpdated extends WorkEntriesEvent {
  /// La lista aggiornata delle voci di lavoro.
  final List<DayWorkEntriesModel> updatedEntries;

  WorkEntriesUpdated(this.updatedEntries);

  @override
  List<Object?> get props => [updatedEntries];
}

/// L'evento che richiede il reset del database delle voci di lavoro.
class ResetDatabase extends WorkEntriesEvent {
  /// La data di inizio dell'intervallo da resettare.
  final DateTime startDate;

  /// La data di fine dell'intervallo da resettare.
  final DateTime endDate;

  /// La funzione di callback da chiamare in caso di errore.
  final Function(String, String) onErrorCallback;

  ResetDatabase(this.startDate, this.endDate, {required this.onErrorCallback});

  @override
  List<Object?> get props => [startDate, endDate, onErrorCallback];
}

/// L'evento che richiede l'eliminazione di una voce di lavoro.
class DeleteWorkEntry extends WorkEntriesEvent {
  /// L'ID della voce di lavoro da eliminare.
  final int id;

  /// La data di inizio dell'intervallo.
  final DateTime startDate;

  /// La data di fine dell'intervallo.
  final DateTime endDate;

  /// La funzione di callback da chiamare in caso di errore.
  final Function(String, String) onErrorCallback;

  DeleteWorkEntry({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.onErrorCallback,
  });

  @override
  List<Object?> get props => [id, startDate, endDate, onErrorCallback];
}

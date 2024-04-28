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

  FetchWorkEntries(
    this.startDate,
    this.endDate,
  );
}

/// L'evento `WorkEntriesUpdated` viene emesso quando le voci di lavoro sono state aggiornate.
///
/// Contiene la proprietà `updatedEntries` che rappresenta la lista aggiornata delle voci di lavoro.
/// Questo evento viene utilizzato per comunicare al bloc che le voci di lavoro sono state modificate
/// e che lo stato dell'interfaccia utente deve essere aggiornato di conseguenza.
class WorkEntriesUpdated extends WorkEntriesEvent {
  final List<WorkEntryModel> updatedEntries;

  WorkEntriesUpdated(this.updatedEntries);
}

/// L'evento `ResetDatabase` viene emesso quando si desidera resettare il database delle voci di lavoro.
///
/// Contiene le proprietà `startDate` e `endDate` che rappresentano l'intervallo di date per il quale resettare le voci di lavoro.
/// Quando questo evento viene gestito dal bloc, tutte le voci di lavoro all'interno dell'intervallo specificato vengono eliminate dal database.
class ResetDatabase extends WorkEntriesEvent {
  final DateTime startDate;
  final DateTime endDate;
  final BuildContext context;

  ResetDatabase(
    this.startDate,
    this.endDate, {
    required this.context,
  });
}

class DeleteWorkEntry extends WorkEntriesEvent {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final BuildContext context;
  DeleteWorkEntry({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.context,
  });
}

import 'package:timetrailblazer/data/models/work_entry_model.dart';

/// Rappresenta un modello per le voci di lavoro di un singolo giorno.
///
/// La classe `DayWorkEntriesModel` contiene informazioni su un giorno specifico e le relative voci di lavoro.
/// Viene utilizzata per organizzare e raggruppare le voci di lavoro in base alla data.
class DayWorkEntriesModel {
  /// Il giorno a cui si riferiscono le voci di lavoro.
  final DateTime day;

  /// La lista delle voci di lavoro per il giorno specificato.
  ///
  /// Questo parametro è opzionale e rappresenta le voci di lavoro registrate per il giorno specificato dalla proprietà `day`.
  /// Se non ci sono voci di lavoro per il giorno, il valore sarà `null`.
  final List<WorkEntryModel>? workEntries;

  /// Costruttore della classe `DayWorkEntriesModel`.
  ///
  /// Accetta i seguenti parametri:
  /// - `day`: il giorno a cui si riferiscono le voci di lavoro.
  /// - `workEntries`: la lista delle voci di lavoro per il giorno specificato (opzionale).
  DayWorkEntriesModel({required this.day, this.workEntries});
}

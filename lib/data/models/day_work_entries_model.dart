import 'package:timetrailblazer/data/models/work_entry_model.dart';

/// Rappresenta un modello per le voci di lavoro di un singolo giorno.
class DayWorkEntriesModel {
  /// Il giorno a cui si riferiscono le voci di lavoro.
  final DateTime day;

  /// La lista delle voci di lavoro per il giorno specificato.
  final List<WorkEntryModel>? workEntries;

  /// Costruttore della classe `DayWorkEntriesModel`.
  ///
  /// Accetta i seguenti parametri:
  /// - `day`: il giorno a cui si riferiscono le voci di lavoro.
  /// - `workEntries`: la lista delle voci di lavoro per il giorno specificato (opzionale).
  DayWorkEntriesModel({required this.day, this.workEntries});
}
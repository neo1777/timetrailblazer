import 'package:drift/drift.dart';

/// Classe che rappresenta la tabella delle voci di lavoro nel database.
class WorkEntries extends Table {
  /// Colonna per l'ID autogenerato della voce di lavoro.
  IntColumn get id => integer().autoIncrement()();

  /// Colonna per il timestamp della voce di lavoro.
  DateTimeColumn get timestamp => dateTime()();

  /// Colonna per il flag di entrata/uscita della voce di lavoro.
  BoolColumn get isEntry => boolean()();
}

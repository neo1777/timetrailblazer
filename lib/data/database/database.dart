import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:timetrailblazer/data/database/work_entry_table.dart';

part 'database.g.dart';

/// Classe che rappresenta il database dell'applicazione utilizzando Drift.
///
/// Questa classe estende la classe `GeneratedDatabase` generata da Drift e
/// fornisce i metodi per l'accesso alle tabelle del database.
@DriftDatabase(tables: [WorkEntries])
class AppDatabase extends _$AppDatabase {
  /// Costruttore della classe `AppDatabase`.
  AppDatabase() : super(_openConnection());

  /// Versione del database.
  @override
  int get schemaVersion => 1;

  /// Metodo per l'inserimento di una nuova voce di lavoro nel database.
  Future<int> insertWorkEntry(WorkEntriesCompanion workEntry) async {
    return await into(workEntries).insert(workEntry);
  }

  /// Metodo per l'aggiornamento di una voce di lavoro esistente nel database.
  Future<bool> updateWorkEntry(WorkEntriesCompanion workEntry) async {
    return await update(workEntries).replace(workEntry);
  }

  /// Metodo per il recupero dell'ultima voce di lavoro inserita nel database.
  Future<WorkEntry?> getLastWorkEntry() async {
    return await (select(workEntries)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Metodo per il recupero delle voci di lavoro in un intervallo di date specificato.
  Future<List<WorkEntry>> getWorkEntriesByDateRange(
      DateTime startDate, DateTime endDate) async {
    return await (select(workEntries)
          ..where((t) => t.timestamp.isBetweenValues(startDate, endDate))
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp)]))
        .get();
  }

  /// Metodo per l'eliminazione di tutte le voci di lavoro dal database.
  Future<int> deleteAllWorkEntries() async {
    return await delete(workEntries).go();
  }

  /// Metodo per l'eliminazione di una singola voce di lavoro dal database in base all'ID.
  Future<int> deleteWorkEntryById(int id) async {
    return await (delete(workEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Metodo per il recupero di una voce di lavoro dal database in base all'ID.
  Future<WorkEntry?> getWorkEntryById(int id) async {
    return await (select(workEntries)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Nuovo metodo per recuperare tutte le voci di lavoro
  Future<List<WorkEntry>> getAllWorkEntries() async {
    return await select(workEntries).get();
  }
}

/// Funzione per l'apertura della connessione al database.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'work_entries.sqlite'));
    return NativeDatabase(file);
  });
}

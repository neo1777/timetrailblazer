import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/data/models/work_entry_dto.dart';

/// La classe `WorkEntriesProvider` fornisce i metodi per interagire con il database delle voci di lavoro.
class WorkEntriesProvider {
  final DatabaseHelper _databaseHelper;

  WorkEntriesProvider(this._databaseHelper);

  /// Inserisce una nuova voce di lavoro nel database.
  Future<void> insertWorkEntry(WorkEntryDTO entry) async {
    await _databaseHelper.insertWorkEntry(entry);
  }

  /// Recupera le voci di lavoro dal database in base all'intervallo di date specificato.
  Future<List<WorkEntryDTO>> getWorkEntries(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _databaseHelper.getWorkEntries(
      startDate,
      endDate,
    );
  }

  /// Elimina tutte le voci di lavoro dal database.
  Future<void> deleteAllWorkEntries() async {
    await _databaseHelper.deleteAllWorkEntries();
  }

  /// Elimina una specifica voce di lavoro dal database in base all'ID.
  Future<void> deleteWorkEntry(int entryId) async {
    await _databaseHelper.deleteWorkEntry(entryId);
  }

  /// Aggiorna una voce di lavoro nel database.
  Future<void> updateWorkEntry(WorkEntryDTO entry) async {
    await _databaseHelper.updateWorkEntry(entry);
  }

  /// Recupera l'ultima voce di lavoro inserita nel database.
  Future<WorkEntryDTO?> getLastWorkEntry() async {
    return await _databaseHelper.getLastWorkEntry();
  }
}

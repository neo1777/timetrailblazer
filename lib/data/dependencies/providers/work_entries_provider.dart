import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/data/models/work_entry_dto.dart';
import 'package:timetrailblazer/utils/logger.dart';

/// La classe `WorkEntriesProvider` fornisce i metodi per interagire con il database delle voci di lavoro.
class WorkEntriesProvider {
  final DatabaseHelper _databaseHelper;

  WorkEntriesProvider(this._databaseHelper);

  /// Inserisce una nuova voce di lavoro nel database.
  Future<void> insertWorkEntry(WorkEntryDTO entry) async {
    try {
      await _databaseHelper.insertWorkEntry(entry);
    } catch (e) {
      logger.e('Errore durante l\'inserimento della voce di lavoro', error: e);
      throw Exception('Errore durante l\'inserimento della voce di lavoro: ${e.toString()}');
    }
  }

  /// Recupera le voci di lavoro dal database in base all'intervallo di date specificato.
  Future<List<WorkEntryDTO>> getWorkEntries(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _databaseHelper.getWorkEntries(
        startDate,
        endDate,
      );
    } catch (e) {
      logger.e('Errore durante il recupero delle voci di lavoro', error: e);
      throw Exception('Errore durante il recupero delle voci di lavoro: ${e.toString()}');
    }
  }

  /// Elimina tutte le voci di lavoro dal database.
  Future<void> deleteAllWorkEntries() async {
    try {
      await _databaseHelper.deleteAllWorkEntries();
    } catch (e) {
      logger.e('Errore durante l\'eliminazione di tutte le voci di lavoro', error: e);
      throw Exception('Errore durante l\'eliminazione di tutte le voci di lavoro: ${e.toString()}');
    }
  }

  /// Elimina una specifica voce di lavoro dal database in base all'ID.
  Future<void> deleteWorkEntry(int entryId) async {
    try {
      await _databaseHelper.deleteWorkEntry(entryId);
    } catch (e) {
      logger.e('Errore durante l\'eliminazione della voce di lavoro', error: e);
      throw Exception('Errore durante l\'eliminazione della voce di lavoro: ${e.toString()}');
    }
  }

  /// Aggiorna una voce di lavoro nel database.
  Future<void> updateWorkEntry(WorkEntryDTO entry) async {
    try {
      await _databaseHelper.updateWorkEntry(entry);
    } catch (e) {
      logger.e('Errore durante l\'aggiornamento della voce di lavoro', error: e);
      throw Exception('Errore durante l\'aggiornamento della voce di lavoro: ${e.toString()}');
    }
  }

  /// Recupera l'ultima voce di lavoro inserita nel database.
  Future<WorkEntryDTO?> getLastWorkEntry() async {
    try {
      return await _databaseHelper.getLastWorkEntry();
    } catch (e) {
      logger.e('Errore durante il recupero dell\'ultima voce di lavoro', error: e);
      throw Exception('Errore durante il recupero dell\'ultima voce di lavoro: ${e.toString()}');
    }
  }
}
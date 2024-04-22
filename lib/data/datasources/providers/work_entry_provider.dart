import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/data/dtos/work_entry_dto.dart';

/// La classe `WorkEntryProvider` fornisce i metodi per interagire con il database
/// attraverso l'utilizzo di `WorkEntryDTO`.
class WorkEntryProvider {
  /// L'istanza di `DatabaseHelper` utilizzata per l'accesso al database.
  final DatabaseHelper _databaseHelper;

  /// Costruttore della classe `WorkEntryProvider`.
  ///
  /// Accetta un parametro [_databaseHelper] di tipo `DatabaseHelper`.
  WorkEntryProvider(this._databaseHelper);

  /// Inserisce una nuova voce di lavoro nel database.
  ///
  /// Accetta un parametro [workEntryDTO] di tipo `WorkEntryDTO` che rappresenta la voce di lavoro da inserire.
  ///
  /// Restituisce un `Future` che si completa quando l'inserimento è terminato.
  Future<void> insertWorkEntry(WorkEntryDTO workEntryDTO) async {
    await _databaseHelper.insertWorkEntry(workEntryDTO);
  }

  /// Recupera l'ultima voce di lavoro inserita nel database.
  ///
  /// Restituisce un `Future` che si completa con un oggetto `WorkEntryDTO` rappresentante l'ultima voce di lavoro,
  /// oppure `null` se non ci sono voci di lavoro nel database.
  Future<WorkEntryDTO?> getLastWorkEntry() async {
    return await _databaseHelper.getLastWorkEntry();
  }

  /// Recupera le voci di lavoro nell'intervallo di date specificato.
  ///
  /// Accetta i seguenti parametri:
  /// - [startTimestamp]: il timestamp di inizio dell'intervallo in millisecondi.
  /// - [endTimestamp]: il timestamp di fine dell'intervallo in millisecondi.
  ///
  /// Restituisce un `Future` che si completa con una lista di oggetti `WorkEntryDTO` rappresentanti le voci di lavoro nell'intervallo specificato.
  Future<List<WorkEntryDTO>> getWorkEntriesByDateRange(
      int startTimestamp, int endTimestamp) async {
    return await _databaseHelper.getWorkEntriesByDateRange(
        startTimestamp, endTimestamp);
  }

  /// Resetta il database cancellando tutte le voci di lavoro.
  ///
  /// Restituisce un `Future` che si completa quando il reset è terminato.
  Future<void> resetDatabase() async {
    await _databaseHelper.resetDatabase();
  }

  /// Cancella una singola voce di lavoro dal database in base all'ID.
  ///
  /// Accetta un parametro [id] di tipo `int` che rappresenta l'ID della voce di lavoro da eliminare.
  ///
  /// Restituisce un `Future` che si completa quando la cancellazione è terminata.
  Future<void> deleteWorkEntryById(int id) async {
    await _databaseHelper.deleteWorkEntryById(id);
  }
}

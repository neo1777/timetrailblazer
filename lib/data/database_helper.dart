import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timetrailblazer/data/models/work_entry_dto.dart';
import 'package:timetrailblazer/utils/logger.dart';

/// La classe `DatabaseHelper` gestisce l'accesso al database SQLite dell'applicazione.
class DatabaseHelper {
  static const _databaseName = 'work_entries.db'; // Il nome del database
  static const _databaseVersion = 1; // La versione del database
  static const table = 'work_entries'; // Il nome della tabella nel database

  static Database? _database; // L'istanza del database

  /// Inizializza il database chiamando il metodo `database`.
  Future<void> initializeDatabase() async {
    await database;
  }

  /// Ottiene l'istanza del database. Se il database non esiste, viene creato.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inizializza il database creando la tabella `work_entries` se non esiste.
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// Crea la tabella `work_entries` nel database.
  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE $table(
          id INTEGER PRIMARY KEY,
          timestamp INTEGER,
          is_entry INTEGER,
          FOREIGN KEY (work_entry_id) REFERENCES work_entries (id) ON DELETE CASCADE
        )
      ''');
    } catch (e) {
      logger.e('Errore durante la creazione della tabella work_entries',
          error: e);
      throw Exception(
          'Errore durante la creazione della tabella work_entries: ${e.toString()}');
    }
  }

  /// Inserisce una nuova voce di lavoro nel database.
  Future<void> insertWorkEntry(WorkEntryDTO entry) async {
    final db = await database;
    try {
      await db.insert(
        table,
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      logger.e(
          'Errore durante l\'inserimento della voce di lavoro nel database',
          error: e);
      throw Exception(
          'Errore durante l\'inserimento della voce di lavoro nel database: ${e.toString()}. Si prega di riprovare più tardi o contattare l\'assistenza se il problema persiste.');
    }
  }

  /// Recupera le voci di lavoro dal database in base all'intervallo di date specificato.
  Future<List<WorkEntryDTO>> getWorkEntries(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        table,
        where: 'timestamp >= ? AND timestamp <= ?',
        whereArgs: [
          startDate.millisecondsSinceEpoch,
          endDate.millisecondsSinceEpoch,
        ],
        orderBy: 'timestamp DESC',
      );
      return List.generate(maps.length, (i) => WorkEntryDTO.fromMap(maps[i]));
    } catch (e) {
      logger.e('Errore durante il recupero delle voci di lavoro dal database',
          error: e);
      throw Exception(
          'Errore durante il recupero delle voci di lavoro dal database: ${e.toString()}. Si prega di riprovare più tardi o contattare l\'assistenza se il problema persiste.');
    }
  }

  /// Elimina tutte le voci di lavoro dal database.
  Future<void> deleteAllWorkEntries() async {
    final db = await database;
    try {
      await db.delete(table);
    } catch (e) {
      logger.e(
          'Errore durante l\'eliminazione di tutte le voci di lavoro dal database',
          error: e);
      throw Exception(
          'Errore durante l\'eliminazione di tutte le voci di lavoro dal database: ${e.toString()}. Si prega di riprovare più tardi o contattare l\'assistenza se il problema persiste.');
    }
  }

  /// Elimina una specifica voce di lavoro dal database in base all'ID.
  Future<void> deleteWorkEntry(int entryId) async {
    final db = await database;
    try {
      await db.delete(
        table,
        where: 'id = ?',
        whereArgs: [entryId],
      );
    } catch (e) {
      logger.e(
          'Errore durante l\'eliminazione della voce di lavoro dal database',
          error: e);
      throw Exception(
          'Errore durante l\'eliminazione della voce di lavoro dal database: ${e.toString()}. Si prega di verificare l\'ID della voce di lavoro e riprovare. Se il problema persiste, contattare l\'assistenza.');
    }
  }

  /// Aggiorna una voce di lavoro nel database.
  Future<void> updateWorkEntry(WorkEntryDTO entry) async {
    final db = await database;
    try {
      await db.update(
        table,
        entry.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
      );
    } catch (e) {
      logger.e(
          'Errore durante l\'aggiornamento della voce di lavoro nel database',
          error: e);
      throw Exception(
          'Errore durante l\'aggiornamento della voce di lavoro nel database: ${e.toString()}. Si prega di verificare i dati della voce di lavoro e riprovare. Se il problema persiste, contattare l\'assistenza.');
    }
  }

  /// Recupera l'ultima voce di lavoro inserita nel database.
  Future<WorkEntryDTO?> getLastWorkEntry() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        table,
        orderBy: 'timestamp DESC',
      );
      if (maps.isNotEmpty) {
        return WorkEntryDTO.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      logger.e(
          'Errore durante il recupero dell\'ultima voce di lavoro dal database',
          error: e);
      throw Exception(
          'Errore durante il recupero dell\'ultima voce di lavoro dal database: ${e.toString()}. Si prega di riprovare più tardi o contattare l\'assistenza se il problema persiste.');
    }
  }
}

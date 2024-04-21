import 'package:sqflite/sqflite.dart';
import 'package:timetrailblazer/data/dtos/work_entry_dto.dart';

/// La classe `DatabaseHelper` fornisce i metodi per l'accesso al database SQLite.
class DatabaseHelper {
  /// Il nome del database.
  static const String _databaseName = 'work_entries.db';

  /// La versione del database.
  static const int _databaseVersion = 1;

  /// Il nome della tabella delle voci di lavoro.
  static const String _tableWorkEntries = 'work_entries';

  /// L'istanza del database.
  static Database? _database;

  /// Restituisce l'istanza del database, creandola se non esiste.
  ///
  /// Questo metodo controlla se l'istanza del database è già stata creata.
  /// Se l'istanza non esiste, viene chiamato il metodo `_initDatabase()` per inizializzare il database.
  /// Infine, viene restituita l'istanza del database.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Inizializza il database.
  ///
  /// Questo metodo privato viene chiamato quando l'istanza del database non esiste ancora.
  /// Recupera il percorso del database utilizzando `getDatabasesPath()` e costruisce il percorso completo.
  /// Quindi, apre il database utilizzando `openDatabase()`, specificando il percorso, la versione e il metodo `onCreate`.
  /// Il metodo `onCreate` viene chiamato quando il database viene creato per la prima volta.
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = '$databasesPath/$_databaseName';
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  /// Crea le tabelle del database.
  ///
  /// Questo metodo privato viene chiamato quando il database viene creato per la prima volta.
  /// Esegue una query SQL per creare la tabella `_tableWorkEntries` con i campi `id`, `timestamp` e `isEntry`.
  /// Il campo `id` è la chiave primaria autoincrementale.
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableWorkEntries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp INTEGER NOT NULL,
        isEntry INTEGER NOT NULL
      )
    ''');
  }

  /// Inserisce una nuova voce di lavoro nel database.
  ///
  /// Riceve come parametro la [workEntryDTO] di tipo [WorkEntryDTO] da inserire.
  /// Recupera l'istanza del database chiamando il getter `database`.
  /// Esegue l'inserimento nella tabella `_tableWorkEntries` utilizzando il metodo `insert()` di SQLite.
  /// Restituisce un [Future] che si completa quando l'inserimento è stato effettuato.
  Future<void> insertWorkEntry(WorkEntryDTO workEntryDTO) async {
    final db = await database;
    await db.insert(
      _tableWorkEntries,
      workEntryDTO.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Recupera l'ultima voce di lavoro inserita nel database.
  ///
  /// Recupera l'istanza del database chiamando il getter `database`.
  /// Esegue una query sulla tabella `_tableWorkEntries` utilizzando il metodo `query()` di SQLite.
  /// Ordina i risultati in base al campo `timestamp` in ordine decrescente e limita il risultato a 1 riga.
  /// Se ci sono risultati, converte la prima riga in un oggetto [WorkEntryDTO] utilizzando il metodo `fromMap()`.
  /// Restituisce un [Future] che si completa con l'ultima [WorkEntryDTO] inserita, o `null` se non ci sono voci di lavoro nel database.
  Future<WorkEntryDTO?> getLastWorkEntry() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableWorkEntries,
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return WorkEntryDTO.fromMap(maps.first);
    }
    return null;
  }

  /// Questo metodo esegue una query sul database per recuperare le voci di lavoro
  /// nell'intervallo di date specificato utilizzando i timestamp di inizio e di fine. Restituisce
  /// una lista di WorkEntryDTO mappando i risultati della query.
  // Future<List<WorkEntryDTO>> getWorkEntriesByDateRange(
  //     int startTimestamp, int endTimestamp) async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     _tableWorkEntries,
  //     where: 'timestamp >= ? AND timestamp <= ?',
  //     whereArgs: [startTimestamp, endTimestamp],
  //     orderBy: 'timestamp DESC',
  //   );
  //   return maps.map((map) => WorkEntryDTO.fromMap(map)).toList();
  // }
  Future<List<WorkEntryDTO>> getWorkEntriesByDateRange(int startTimestamp, int endTimestamp) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    _tableWorkEntries,
    where: 'timestamp >= ? AND timestamp <= ?',
    whereArgs: [startTimestamp, endTimestamp],
    orderBy: 'timestamp',
  );
  return maps.map((map) => WorkEntryDTO.fromMap(map)).toList();
}
}

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timetrailblazer/data/dtos/work_entry_dto.dart';
import 'package:timetrailblazer/data/dtos/work_stats_dto.dart';

/// La classe `DatabaseHelper` fornisce i metodi per l'accesso al database SQLite.
class DatabaseHelper {
  /// Il nome del database.
  static const String _databaseName = 'work_entries.db';

  /// La versione del database.
  static const int _databaseVersion = 1;

  /// Il nome della tabella delle voci di lavoro.
  static const String _tableWorkEntries = 'work_entries';
  static const String _columnId = 'id';
  static const String _columnTimestamp = 'timestamp';
  static const String _columnIsEntry = 'isEntry';

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
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnTimestamp INTEGER NOT NULL,
        $_columnIsEntry INTEGER NOT NULL
      )
    ''');
    // Crea un indice sulla colonna 'timestamp' per migliorare le prestazioni delle query
    await db.execute('''
      CREATE INDEX idx_timestamp ON $_tableWorkEntries ($_columnTimestamp)
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
      {
        _columnTimestamp: workEntryDTO.timestamp,
        _columnIsEntry: workEntryDTO.isEntry,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Aggiorna una voce di lavoro esistente nel database.
  ///
  /// Riceve come parametro la [workEntryDTO] di tipo [WorkEntryDTO] da aggiornare.
  /// Utilizza l'ID della [workEntryDTO] per trovare la voce corrispondente e aggiornarla.
  /// Recupera l'istanza del database chiamando il getter `database`.
  /// Esegue l'aggiornamento nella tabella `_tableWorkEntries` utilizzando il metodo `update()` di SQLite.
  /// Restituisce un [Future] che si completa quando l'aggiornamento è stato effettuato.
  Future<void> updateWorkEntry(WorkEntryDTO workEntryDTO) async {
    final db = await database;
    await db.update(
      _tableWorkEntries,
      {
        _columnTimestamp: workEntryDTO.timestamp,
        _columnIsEntry: workEntryDTO.isEntry,
      },
      where: '$_columnId = ?',
      whereArgs: [workEntryDTO.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Recupera l'ultima voce di lavoro inserita nel database.
  ///
  /// Recupera l'istanza del database chiamando il getter database.
  /// Esegue una query sulla tabella _tableWorkEntries utilizzando il metodo query() di SQLite.
  /// Ordina i risultati in base al campo timestamp in ordine decrescente e limita il risultato a 1 riga.
  /// Se ci sono risultati, converte la prima riga in un oggetto [WorkEntryDTO] utilizzando il metodo fromMap().
  /// Restituisce un [Future] che si completa con l'ultima [WorkEntryDTO] inserita, o null se non ci sono voci di lavoro nel database.
  Future<WorkEntryDTO?> getLastWorkEntry() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableWorkEntries,
      orderBy: '$_columnTimestamp DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return WorkEntryDTO.fromMap(maps.first);
    }
    return null;
  }

  /// Recupera le voci di lavoro nell'intervallo di date specificato.
  ///
  /// Riceve come parametri il [startTimestamp] e l'[endTimestamp] che rappresentano l'intervallo di date.
  /// Recupera l'istanza del database chiamando il getter database.
  /// Esegue una query sulla tabella _tableWorkEntries utilizzando il metodo query() di SQLite.
  /// Filtra i risultati in base all'intervallo di timestamp specificato utilizzando la clausola where.
  /// Ordina i risultati in base al campo timestamp in ordine crescente.
  /// Mappa i risultati della query in una lista di [WorkEntryDTO] utilizzando il metodo fromMap().
  /// Restituisce un [Future] che si completa con la lista di [WorkEntryDTO] recuperate.
  Future<List<WorkEntryDTO>> getWorkEntriesByDateRange(
      int startTimestamp, int endTimestamp) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableWorkEntries,
      where: 'timestamp >= ? AND timestamp <= ?',
      whereArgs: [startTimestamp, endTimestamp],
      orderBy: 'timestamp',
    );
    return maps.map((map) => WorkEntryDTO.fromMap(map)).toList();
  }

  /// Elimina tutte le voci di lavoro dal database.
  ///
  /// Recupera l'istanza del database chiamando il getter database.
  /// Esegue una query SQL per eliminare tutte le righe dalla tabella _tableWorkEntries utilizzando il metodo delete() di SQLite.
  /// Restituisce un [Future] che si completa quando l'eliminazione è stata effettuata.
  Future<void> deleteAllWorkEntries() async {
    final db = await database;
    await db.delete(_tableWorkEntries);
  }

  /// Resetta il database eliminando tutte le tabelle e ricreandole.
  ///
  /// Recupera l'istanza del database chiamando il getter database.
  /// Esegue una serie di query SQL per eliminare tutte le tabelle dal database utilizzando il metodo execute() di SQLite.
  /// Chiama il metodo _createDatabase() per ricreare le tabelle del database.
  /// Restituisce un [Future] che si completa quando il reset del database è stato effettuato.
  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $_tableWorkEntries');
    await _createDatabase(db, _databaseVersion);
  }

  /// Elimina una singola voce di lavoro dal database in base all'ID.
  ///
  /// Riceve come parametro l'[id] della voce di lavoro da eliminare.
  /// Recupera l'istanza del database chiamando il getter database.
  /// Esegue una query SQL per eliminare la riga corrispondente all'ID specificato dalla tabella _tableWorkEntries utilizzando il metodo delete() di SQLite.
  /// Restituisce un [Future] che si completa quando l'eliminazione è stata effettuata.
  Future<void> deleteWorkEntryById(int id) async {
    final db = await database;
    await db.delete(
      _tableWorkEntries,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Recupera una voce di lavoro dal database in base all'ID.
  ///
  /// Accetta un parametro [id] di tipo `int` che rappresenta l'ID della voce di lavoro da recuperare.
  ///
  /// Recupera l'istanza del database chiamando il getter `database`.
  /// Esegue una query sulla tabella `_tableWorkEntries` utilizzando il metodo `query()` di SQLite.
  /// Filtra i risultati in base all'ID specificato utilizzando la clausola `where`.
  ///
  /// Se vengono trovate voci di lavoro corrispondenti all'ID, converte la prima voce in un oggetto `WorkEntryDTO`
  /// utilizzando il metodo `fromMap()` e la restituisce.
  ///
  /// Se non vengono trovate voci di lavoro corrispondenti all'ID, restituisce `null`.
  ///
  /// Restituisce un `Future` che si completa con un oggetto `WorkEntryDTO` rappresentante la voce di lavoro,
  /// oppure `null` se non viene trovata alcuna voce di lavoro con l'ID specificato.
  Future<WorkEntryDTO?> getWorkEntryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableWorkEntries,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return WorkEntryDTO.fromMap(maps.first);
    }
    return null;
  }

  /// Recupera tutte le voci di lavoro dal database.
  ///
  /// Esegue una query sulla tabella `_tableWorkEntries` per recuperare tutte le voci di lavoro.
  /// Ordina le voci di lavoro in base al campo `_columnTimestamp` in ordine crescente.
  /// Mappa i risultati della query in una lista di oggetti `WorkEntryDTO` utilizzando il metodo `fromMap`.
  ///
  /// Restituisce un `Future` che si completa con la lista di tutte le voci di lavoro presenti nel database.
  Future<List<WorkEntryDTO>> getAllWorkEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableWorkEntries,
      orderBy: '$_columnTimestamp ASC',
    );
    return List.generate(maps.length, (i) {
      return WorkEntryDTO.fromMap(maps[i]);
    });
  }

  /// Recupera le statistiche di lavoro giornaliere dal database.
  ///
  /// Esegue una query SQL per aggregare le voci di lavoro raggruppate per giorno
  /// e calcolare le ore lavorate e le ore di straordinario per ciascun giorno.
  ///
  /// Restituisce un `Future` che si completa con una lista di oggetti `WorkStatsDTO`
  /// rappresentanti le statistiche di lavoro giornaliere.
  Future<List<WorkStatsDTO>> getDailyWorkStats() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        DATE(timestamp / 1000, 'unixepoch') AS date,
        IFNULL(SUM(CASE WHEN isEntry = 1 THEN (
          SELECT IFNULL((timestamp - w.timestamp) / 1000, 0)
          FROM $_tableWorkEntries 
          WHERE id > w.id AND isEntry = 0 AND DATE(timestamp / 1000, 'unixepoch') = DATE(w.timestamp / 1000, 'unixepoch')
          ORDER BY timestamp 
          LIMIT 1
        ) ELSE 0 END), 0) AS workedSeconds,
        0 AS overtimeSeconds
      FROM $_tableWorkEntries w
      WHERE isEntry = 1
      GROUP BY DATE(timestamp / 1000, 'unixepoch')
    ''');
      final List<WorkStatsDTO> dtos = maps.map((map) {
        return WorkStatsDTO.fromMap({
          'date': map['date'],
          'workedSeconds': map['workedSeconds'] ?? 0,
          'overtimeSeconds': map['overtimeSeconds'] ?? 0,
        });
      }).toList();
      return dtos;
    } catch (e) {
      return [];
    }
  }

  /// Recupera le statistiche di lavoro mensili dal database.
  ///
  /// Esegue una query SQL per aggregare le voci di lavoro raggruppate per mese
  /// e calcolare le ore lavorate e le ore di straordinario per ciascun mese.
  ///
  /// Restituisce un `Future` che si completa con una lista di oggetti `WorkStatsDTO`
  /// rappresentanti le statistiche di lavoro mensili.
  Future<List<WorkStatsDTO>> getMonthlyWorkStats() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        strftime('%Y', timestamp / 1000, 'unixepoch') AS year,
        strftime('%m', timestamp / 1000, 'unixepoch') AS month,
        IFNULL(SUM(CASE WHEN isEntry = 1 THEN (
          SELECT IFNULL((timestamp - w.timestamp) / 1000, 0)
          FROM $_tableWorkEntries
          WHERE id > w.id AND isEntry = 0 AND DATE(timestamp / 1000, 'unixepoch') = DATE(w.timestamp / 1000, 'unixepoch')
          ORDER BY timestamp
          LIMIT 1
        ) ELSE 0 END), 0) AS workedSeconds,
        0 AS overtimeSeconds
      FROM $_tableWorkEntries w
      WHERE isEntry = 1
      GROUP BY strftime('%Y', timestamp / 1000, 'unixepoch'), strftime('%m', timestamp / 1000, 'unixepoch')
    ''');
      final List<WorkStatsDTO> dtos = maps.map((map) {
        return WorkStatsDTO.fromMap({
          'year': int.tryParse(map['year'] ?? '') ?? 0,
          'month': int.tryParse(map['month'] ?? '') ?? 0,
          'workedSeconds': map['workedSeconds'] ?? 0,
          'overtimeSeconds': map['overtimeSeconds'] ?? 0,
        });
      }).toList();
      return dtos;
    } catch (e) {
      return [];
    }
  }

  /// Recupera le statistiche di lavoro per l'intervallo di date selezionato dal database.
  ///
  /// Accetta i seguenti parametri:
  /// - [startDate]: la data di inizio dell'intervallo.
  /// - [endDate]: la data di fine dell'intervallo.
  ///
  /// Esegue una query SQL per aggregare le voci di lavoro nell'intervallo di date specificato
  /// e calcolare le ore lavorate e le ore di straordinario per ciascun giorno.
  ///
  /// Restituisce un `Future` che si completa con una lista di oggetti `WorkStatsDTO`
  /// rappresentanti le statistiche di lavoro per l'intervallo di date selezionato.
  Future<List<WorkStatsDTO>> getSelectedRangeWorkStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        DATE(timestamp / 1000, 'unixepoch') AS date,
        IFNULL(SUM(CASE WHEN isEntry = 1 THEN (
          SELECT IFNULL((timestamp - w.timestamp) / 1000, 0)
          FROM $_tableWorkEntries
          WHERE id > w.id AND isEntry = 0 AND DATE(timestamp / 1000, 'unixepoch') = DATE(w.timestamp / 1000, 'unixepoch')
          ORDER BY timestamp
          LIMIT 1
        ) ELSE 0 END), 0) AS workedSeconds,
        0 AS overtimeSeconds
      FROM $_tableWorkEntries w
      WHERE isEntry = 1 AND DATE(timestamp / 1000, 'unixepoch') BETWEEN ? AND ?
      GROUP BY DATE(timestamp / 1000, 'unixepoch')
    ''', [
        DateFormat('yyyy-MM-dd').format(startDate),
        DateFormat('yyyy-MM-dd').format(endDate),
      ]);
      final List<WorkStatsDTO> dtos = maps.map((map) {
        return WorkStatsDTO.fromMap({
          'date': map['date'],
          'workedSeconds': map['workedSeconds'] ?? 0,
          'overtimeSeconds': map['overtimeSeconds'] ?? 0,
        });
      }).toList();
      return dtos;
    } catch (e) {
      return [];
    }
  }
}

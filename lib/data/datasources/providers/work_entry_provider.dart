import 'package:timetrailblazer/data/database/database.dart';
import 'package:timetrailblazer/data/dtos/work_entry_dto.dart';
import 'package:timetrailblazer/data/dtos/work_stats_dto.dart';

/// Classe che fornisce i metodi per interagire con il database
/// attraverso l'utilizzo di `WorkEntryDTO`.
class WorkEntryProvider {
  /// Istanza del database.
  final AppDatabase _database;

  /// Costruttore della classe `WorkEntryProvider`.
  ///
  /// Accetta un parametro `database` di tipo `AppDatabase`.
  WorkEntryProvider(this._database);

  /// Metodo per l'inserimento di una nuova voce di lavoro nel database.
  Future<void> insertWorkEntry(WorkEntryDTO workEntryDTO) async {
    await _database.insertWorkEntry(workEntryDTO.toCompanion());
  }

  /// Metodo per l'aggiornamento di una voce di lavoro esistente nel database.
  Future<void> updateWorkEntry(WorkEntryDTO workEntryDTO) async {
    await _database.updateWorkEntry(workEntryDTO.toCompanion());
  }

  /// Metodo per il recupero dell'ultima voce di lavoro inserita nel database.
  Future<WorkEntryDTO?> getLastWorkEntry() async {
    final workEntry = await _database.getLastWorkEntry();
    return workEntry != null ? WorkEntryDTO.fromWorkEntry(workEntry) : null;
  }

  /// Metodo per il recupero delle voci di lavoro in un intervallo di date specificato.
  Future<List<WorkEntryDTO>> getWorkEntriesByDateRange(DateTime startDate, DateTime endDate) async {
    final workEntries = await _database.getWorkEntriesByDateRange(startDate, endDate);
    return workEntries.map((workEntry) => WorkEntryDTO.fromWorkEntry(workEntry)).toList();
  }

  /// Metodo per il reset del database cancellando tutte le voci di lavoro.
  Future<void> resetDatabase() async {
    await _database.deleteAllWorkEntries();
  }

  /// Metodo per la cancellazione di una singola voce di lavoro dal database in base all'ID.
  Future<void> deleteWorkEntryById(int id) async {
    await _database.deleteWorkEntryById(id);
  }

  /// Metodo per il recupero di una voce di lavoro dal database in base all'ID.
  Future<WorkEntryDTO?> getWorkEntryById(int id) async {
    final workEntry = await _database.getWorkEntryById(id);
    return workEntry != null ? WorkEntryDTO.fromWorkEntry(workEntry) : null;
  }

  /// Metodo per il recupero delle statistiche di lavoro giornaliere dal database.
  Future<List<WorkStatsDTO>> getDailyWorkStats() async {
    final workEntries = await _database.getAllWorkEntries();
    final dailyStats = <WorkStatsDTO>[];

    final groupedEntries = _groupEntriesByDate(workEntries);

    for (final entry in groupedEntries.entries) {
      final date = entry.key;
      final entries = entry.value;

      final workedSeconds = _calculateWorkedSeconds(entries);
      final overtimeSeconds = _calculateOvertimeSeconds(entries);

      dailyStats.add(WorkStatsDTO(
        date: date.millisecondsSinceEpoch,
        workedSeconds: workedSeconds,
        overtimeSeconds: overtimeSeconds,
      ));
    }

    return dailyStats;
  }

  /// Metodo per il recupero delle statistiche di lavoro mensili dal database.
  Future<List<WorkStatsDTO>> getMonthlyWorkStats() async {
    final workEntries = await _database.getAllWorkEntries();
    final monthlyStats = <WorkStatsDTO>[];

    final groupedEntries = _groupEntriesByMonth(workEntries);

    for (final entry in groupedEntries.entries) {
      final year = entry.key.year;
      final month = entry.key.month;
      final entries = entry.value;

      final workedSeconds = _calculateWorkedSeconds(entries);
      final overtimeSeconds = _calculateOvertimeSeconds(entries);

      monthlyStats.add(WorkStatsDTO(
        year: year,
        month: month,
        workedSeconds: workedSeconds,
        overtimeSeconds: overtimeSeconds,
      ));
    }

    return monthlyStats;
  }

  /// Metodo per il recupero delle statistiche di lavoro per un intervallo di date selezionato dal database.
  Future<List<WorkStatsDTO>> getSelectedRangeWorkStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final workEntries = await _database.getWorkEntriesByDateRange(startDate, endDate);
    final selectedRangeStats = <WorkStatsDTO>[];

    final groupedEntries = _groupEntriesByDate(workEntries);

    for (final entry in groupedEntries.entries) {
      final date = entry.key;
      final entries = entry.value;

      final workedSeconds = _calculateWorkedSeconds(entries);
      final overtimeSeconds = _calculateOvertimeSeconds(entries);

      selectedRangeStats.add(WorkStatsDTO(
        date: date.millisecondsSinceEpoch,
        workedSeconds: workedSeconds,
        overtimeSeconds: overtimeSeconds,
      ));
    }

    return selectedRangeStats;
  }

  /// Metodo privato per raggruppare le voci di lavoro per data.
  Map<DateTime, List<WorkEntry>> _groupEntriesByDate(List<WorkEntry> entries) {
    return entries.fold({}, (map, entry) {
      final date = DateTime(entry.timestamp.year, entry.timestamp.month, entry.timestamp.day);
      map[date] ??= [];
      map[date]!.add(entry);
      return map;
    });
  }

  /// Metodo privato per raggruppare le voci di lavoro per mese.
  Map<DateTime, List<WorkEntry>> _groupEntriesByMonth(List<WorkEntry> entries) {
    return entries.fold({}, (map, entry) {
      final month = DateTime(entry.timestamp.year, entry.timestamp.month);
      map[month] ??= [];
      map[month]!.add(entry);
      return map;
    });
  }

  /// Metodo privato per calcolare i secondi lavorati dato un elenco di voci di lavoro.
  int _calculateWorkedSeconds(List<WorkEntry> entries) {
    int workedSeconds = 0;

    for (int i = 0; i < entries.length; i += 2) {
      if (i + 1 < entries.length) {
        final entryTimestamp = entries[i].timestamp;
        final exitTimestamp = entries[i + 1].timestamp;
        final duration = exitTimestamp.difference(entryTimestamp);
        workedSeconds += duration.inSeconds;
      }
    }

    return workedSeconds;
  }

  /// Metodo privato per calcolare i secondi di straordinario dato un elenco di voci di lavoro.
  int _calculateOvertimeSeconds(List<WorkEntry> entries) {
    // TODO: Implementare la logica per il calcolo dei secondi di straordinario
    return 0;
  }
}
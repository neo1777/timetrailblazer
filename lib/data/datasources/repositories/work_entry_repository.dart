import 'package:timetrailblazer/data/datasources/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/datasources/providers/work_entry_provider.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/domain/blocs/work_stats/work_stats_state.dart';

/// Classe che rappresenta il repository per la gestione delle voci di lavoro.
class WorkEntryRepository {
  /// Istanza del provider delle voci di lavoro.
  final WorkEntryProvider _workEntryProvider;

  /// Istanza del mapper delle voci di lavoro.
  final WorkEntryMapper _workEntryMapper;

  /// Costruttore della classe `WorkEntryRepository`.
  ///
  /// Accetta le istanze del provider e del mapper delle voci di lavoro come parametri.
  WorkEntryRepository(this._workEntryProvider, this._workEntryMapper);

  /// Metodo per l'inserimento di una nuova voce di lavoro.
  Future<void> insertWorkEntry(WorkEntryModel workEntry) async {
    final workEntryDTO = _workEntryMapper.toDTO(workEntry);
    await _workEntryProvider.insertWorkEntry(workEntryDTO);
  }

  /// Metodo per l'aggiornamento di una voce di lavoro esistente.
  Future<void> updateWorkEntry(WorkEntryModel workEntry) async {
    final workEntryDTO = _workEntryMapper.toDTO(workEntry);
    await _workEntryProvider.updateWorkEntry(workEntryDTO);
  }

  /// Metodo per il recupero dell'ultima voce di lavoro inserita.
  Future<WorkEntryModel?> getLastWorkEntry() async {
    final workEntryDTO = await _workEntryProvider.getLastWorkEntry();
    return workEntryDTO != null ? _workEntryMapper.fromDTO(workEntryDTO) : null;
  }

  /// Metodo per il recupero delle voci di lavoro per i giorni specificati.
  Future<List<DayWorkEntriesModel>> getWorkEntriesByDays(
      List<DateTime> days, DateTime endDate) async {
    final dayWorkEntriesList = <DayWorkEntriesModel>[];

    for (final day in days) {
      final startOfDay = DateTime(day.year, day.month, day.day);
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1));

      final workEntryDTOs = await _workEntryProvider.getWorkEntriesByDateRange(
          startOfDay, endOfDay);
      final workEntries = workEntryDTOs.map(_workEntryMapper.fromDTO).toList();

      dayWorkEntriesList.add(
        DayWorkEntriesModel(
          day: day,
          workEntries: workEntries.isNotEmpty ? workEntries : null,
        ),
      );
    }

    return dayWorkEntriesList;
  }

  /// Metodo per il reset del database cancellando tutte le voci di lavoro.
  Future<void> resetDatabase() async {
    await _workEntryProvider.resetDatabase();
  }

  /// Metodo per la cancellazione di una singola voce di lavoro dal database in base all'ID.
  Future<void> deleteWorkEntryById(int id) async {
    await _workEntryProvider.deleteWorkEntryById(id);
  }

  /// Metodo per il recupero di una voce di lavoro dal database in base all'ID.
  Future<WorkEntryModel?> getWorkEntryById(int id) async {
    final workEntryDTO = await _workEntryProvider.getWorkEntryById(id);
    return workEntryDTO != null ? _workEntryMapper.fromDTO(workEntryDTO) : null;
  }

  /// Metodo per il salvataggio di una voce di lavoro nel database.
  Future<void> saveWorkEntry(WorkEntryModel workEntry) async {
    if (workEntry.id != null) {
      await updateWorkEntry(workEntry);
    } else {
      await insertWorkEntry(workEntry);
    }
  }

  /// Metodo per il recupero delle statistiche di lavoro per un intervallo di date selezionato.
  Future<List<DailyWorkStats>> getSelectedRangeWorkStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final workStatsDTOs = await _workEntryProvider.getSelectedRangeWorkStats(
      startDate: startDate,
      endDate: endDate,
    );
    return workStatsDTOs
        .map((dto) => DailyWorkStats(
              date: DateTime.fromMillisecondsSinceEpoch(dto.date!),
              workedHours: Duration(seconds: dto.workedSeconds),
              overtimeHours: Duration(seconds: dto.overtimeSeconds),
            ))
        .toList();
  }
}
/**import 'dart:async';

import 'package:timetrailblazer/data/datasources/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/datasources/providers/work_entry_provider.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/domain/blocs/work_stats/work_stats_state.dart';

/// La classe `WorkEntryRepository` rappresenta il repository per la gestione delle voci di lavoro.
class WorkEntryRepository {
  /// L'istanza di `WorkEntryProvider` utilizzata per l'accesso ai dati.
  final WorkEntryProvider _workEntryProvider;

  /// L'istanza di `WorkEntryMapper` utilizzata per la mappatura tra `WorkEntryDTO` e `WorkEntry`.
  final WorkEntryMapper _workEntryMapper;

  /// Costruttore della classe `WorkEntryRepository`.
  ///
  /// Accetta i seguenti parametri:
  /// - [_workEntryProvider]: l'istanza di `WorkEntryProvider` per l'accesso ai dati.
  /// - [_workEntryMapper]: l'istanza di `WorkEntryMapper` per la mappatura.
  WorkEntryRepository(this._workEntryProvider, this._workEntryMapper);

  /// Inserisce una nuova voce di lavoro.
  ///
  /// Accetta un parametro [workEntry] di tipo `WorkEntry` che rappresenta la voce di lavoro da inserire.
  ///
  /// Restituisce un `Future` che si completa quando l'inserimento è terminato.
  Future<void> insertWorkEntry(
    WorkEntryModel workEntry,
  ) async {
    final workEntryDTO = _workEntryMapper.toDTO(workEntry);
    await _workEntryProvider.insertWorkEntry(workEntryDTO);
  }

  /// Aggiorna una voce di lavoro esistente.
  ///
  /// Accetta un parametro [workEntry] di tipo `WorkEntryModel` che rappresenta la voce di lavoro da aggiornare.
  ///
  /// Restituisce un `Future` che si completa quando l'aggiornamento è terminato.
  Future<void> updateWorkEntry(WorkEntryModel workEntry) async {
    final workEntryDTO = _workEntryMapper.toDTO(workEntry);
    await _workEntryProvider.updateWorkEntry(workEntryDTO);
  }

  /// Recupera l'ultima voce di lavoro inserita.
  ///
  /// Restituisce un `Future` che si completa con un oggetto `WorkEntry` rappresentante l'ultima voce di lavoro,
  /// oppure `null` se non ci sono voci di lavoro.
  Future<WorkEntryModel?> getLastWorkEntry() async {
    final workEntryDTO = await _workEntryProvider.getLastWorkEntry();

    if (workEntryDTO != null) {
      return _workEntryMapper.fromDTO(workEntryDTO);
    }

    return null;
  }

  /// Recupera le voci di lavoro per i giorni specificati.
  ///
  /// Accetta i seguenti parametri:
  /// - [days]: la lista di oggetti `DateTime` rappresentanti i giorni per cui recuperare le voci di lavoro.
  /// - [endDate]: la data di fine dell'intervallo di date.
  ///
  /// Restituisce un `Future` che si completa con una lista di oggetti `DayWorkEntriesModel` rappresentanti le voci di lavoro raggruppate per giorno.
  Future<List<DayWorkEntriesModel>> getWorkEntriesByDays(
      List<DateTime> days, DateTime endDate) async {
    final List<DayWorkEntriesModel> dayWorkEntriesList = [];

    for (final day in days) {
      final startOfDay = DateTime(day.year, day.month, day.day);
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1));

      final workEntryDTOs = await _workEntryProvider.getWorkEntriesByDateRange(
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch,
      );

      final workEntries = workEntryDTOs.map(_workEntryMapper.fromDTO).toList();

      dayWorkEntriesList.add(
        DayWorkEntriesModel(
          day: day,
          workEntries: workEntries.isNotEmpty ? workEntries : null,
        ),
      );
    }

    return dayWorkEntriesList;
  }

  /// Resetta il database cancellando tutte le voci di lavoro.
  ///
  /// Restituisce un `Future` che si completa quando il reset è terminato.
  Future<void> resetDatabase() async {
    await _workEntryProvider.resetDatabase();
  }

  /// Cancella una singola voce di lavoro dal database in base all'ID.
  ///
  /// Accetta un parametro [id] di tipo `int` che rappresenta l'ID della voce di lavoro da eliminare.
  ///
  /// Restituisce un `Future` che si completa quando la cancellazione è terminata.
  Future<void> deleteWorkEntryById(int id) async {
    await _workEntryProvider.deleteWorkEntryById(id);
  }

  /// Recupera una voce di lavoro dal database in base all'ID.
  ///
  /// Accetta un parametro [id] di tipo `int` che rappresenta l'ID della voce di lavoro da recuperare.
  ///
  /// Restituisce un `Future` che si completa con un oggetto `WorkEntryModel` rappresentante la voce di lavoro,
  /// oppure `null` se non viene trovata alcuna voce di lavoro con l'ID specificato.
  Future<WorkEntryModel?> getWorkEntryById(int id) async {
    final workEntryDTO = await _workEntryProvider.getWorkEntryById(id);
    if (workEntryDTO != null) {
      return _workEntryMapper.fromDTO(workEntryDTO);
    }
    return null;
  }

  /// Salva una voce di lavoro nel database.
  ///
  /// Accetta un parametro [workEntry] di tipo `WorkEntryModel` che rappresenta la voce di lavoro da salvare.
  ///
  /// Se la voce di lavoro ha un ID, viene considerata una voce esistente e viene aggiornata nel database.
  /// Se la voce di lavoro non ha un ID, viene considerata una nuova voce e viene inserita nel database.
  ///
  /// Restituisce un `Future` che si completa quando il salvataggio è terminato.
  Future<void> saveWorkEntry(WorkEntryModel workEntry) async {
    if (workEntry.id != null) {
      await updateWorkEntry(workEntry);
    } else {
      await insertWorkEntry(workEntry);
    }
  }

  /// Recupera le statistiche di lavoro giornaliere.
  ///
  /// Restituisce un `Future` che si completa con una lista di oggetti `DailyWorkStats`
  /// rappresentanti le statistiche di lavoro giornaliere.
  Future<List<DailyWorkStats>> getDailyWorkStats() async {
    final workStatsDTOs = await _workEntryProvider.getDailyWorkStats();
    return workStatsDTOs
        .map((dto) => DailyWorkStats(
              date: DateTime.fromMillisecondsSinceEpoch(dto.date!),
              workedHours: Duration(seconds: dto.workedSeconds),
              overtimeHours: Duration(seconds: dto.overtimeSeconds),
            ))
        .toList();
  }

  /// Recupera le statistiche di lavoro mensili.
  ///
  /// Restituisce un `Future` che si completa con una lista di oggetti `MonthlyWorkStats`
  /// rappresentanti le statistiche di lavoro mensili.
  Future<List<MonthlyWorkStats>> getMonthlyWorkStats() async {
    final workStatsDTOs = await _workEntryProvider.getMonthlyWorkStats();
    return workStatsDTOs
        .map((dto) => MonthlyWorkStats(
              month: DateTime(dto.year!, dto.month!),
              workedHours: Duration(seconds: dto.workedSeconds),
              overtimeHours: Duration(seconds: dto.overtimeSeconds),
            ))
        .toList();
  }

  /// Recupera le statistiche di lavoro per l'intervallo di date selezionato.
  ///
  /// Accetta i seguenti parametri:
  /// - [startDate]: la data di inizio dell'intervallo.
  /// - [endDate]: la data di fine dell'intervallo.
  ///
  /// Restituisce un `Future` che si completa con una lista di oggetti `DailyWorkStats`
  /// rappresentanti le statistiche di lavoro per l'intervallo di date selezionato.
  Future<List<DailyWorkStats>> getSelectedRangeWorkStats({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final workStatsDTOs = await _workEntryProvider.getSelectedRangeWorkStats(
      startDate: startDate,
      endDate: endDate,
    );
    return workStatsDTOs
        .map((dto) => DailyWorkStats(
              date: DateTime.fromMillisecondsSinceEpoch(dto.date!),
              workedHours: Duration(seconds: dto.workedSeconds),
              overtimeHours: Duration(seconds: dto.overtimeSeconds),
            ))
        .toList();
  }
}
 */
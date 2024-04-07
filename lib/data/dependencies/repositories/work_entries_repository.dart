import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timetrailblazer/data/dependencies/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/dependencies/providers/work_entries_provider.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';

/// La classe `WorkEntriesRepository` gestisce l'accesso ai dati delle voci di lavoro.
class WorkEntriesRepository {
  final WorkEntriesProvider _workEntriesProvider;
  final WorkEntryMapper _workEntryMapper;

  WorkEntriesRepository(
    this._workEntriesProvider,
    this._workEntryMapper,
  );

  /// Inserisce una nuova voce di lavoro.
  Future<void> insertWorkEntry(WorkEntry entry) async {
    final dto = _workEntryMapper.toDTO(entry);
    await _workEntriesProvider.insertWorkEntry(dto);
  }

  /// Recupera le voci di lavoro in base all'intervallo di date specificato.
  Future<List<WorkEntry>> getWorkEntries(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final dtos = await _workEntriesProvider.getWorkEntries(
      startDate,
      endDate,
    );
    return dtos.map(_workEntryMapper.fromDTO).toList(growable: false);
  }

  /// Elimina tutte le voci di lavoro.
  Future<void> deleteAllWorkEntries() async {
    await _workEntriesProvider.deleteAllWorkEntries();
  }

  /// Elimina una specifica voce di lavoro in base all'ID.
  Future<void> deleteWorkEntry(int entryId) async {
    await _workEntriesProvider.deleteWorkEntry(entryId);
  }

  /// Aggiorna una voce di lavoro.
  Future<void> updateWorkEntry(WorkEntry entry) async {
    final dto = _workEntryMapper.toDTO(entry);
    await _workEntriesProvider.updateWorkEntry(dto);
  }

  /// Recupera l'ultima voce di lavoro inserita.
  Future<WorkEntry?> getLastWorkEntry() async {
    final dto = await _workEntriesProvider.getLastWorkEntry();
    if (dto != null) {
      return _workEntryMapper.fromDTO(dto);
    }
    return null;
  }

  /// Esporta le voci di lavoro in un file CSV.
  Future<String> exportToCsv(List<WorkEntry> entries) async {
    final List<List<dynamic>> rows = entries
        .map((entry) => [
              entry.id,
              entry.timestamp.toIso8601String(),
              entry.isEntry ? 'Entrata' : 'Uscita',
            ])
        .toList();

    final String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/work_entries.csv';
    final File file = File(path);
    await file.writeAsString(csv);

    return path;
  }

  /// Importa le voci di lavoro da un file CSV.
  Future<void> importFromCsv(String path) async {
    final file = File(path);
    final csvString = await file.readAsString();
    final csvList = const CsvToListConverter().convert(csvString);

    final workEntries = csvList.map((row) {
      final id = row[0];
      final timestamp = DateTime.parse(row[1]);
      final isEntry = row[2] == 'Entrata';
      return WorkEntry(id: id, timestamp: timestamp, isEntry: isEntry);
    }).toList();

    for (final workEntry in workEntries) {
      await _workEntriesProvider
          .insertWorkEntry(_workEntryMapper.toDTO(workEntry));
    }
  }

  /// Calcola il tempo di lavoro giornaliero a partire dalle voci di lavoro.
  Future<Map<DateTime, Duration>> calculateWorkTimeMap() async {
    final entries = await getWorkEntries(DateTime(2000), DateTime.now());
    final workTimeMap = <DateTime, Duration>{};

    for (int i = 0; i < entries.length; i += 2) {
      final startEntry = entries[i];
      final endEntry = i + 1 < entries.length ? entries[i + 1] : null;

      if (endEntry != null) {
        final workDate = DateTime(
          startEntry.timestamp.year,
          startEntry.timestamp.month,
          startEntry.timestamp.day,
        );
        final workDuration =
            endEntry.timestamp.difference(startEntry.timestamp);
        workTimeMap[workDate] =
            (workTimeMap[workDate] ?? const Duration()) + workDuration;
      }
    }

    return workTimeMap;
  }
}

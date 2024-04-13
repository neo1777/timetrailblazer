import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:timetrailblazer/data/dependencies/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/dependencies/providers/work_entries_provider.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';
import 'package:timetrailblazer/utils/logger.dart';

/// La classe `WorkEntriesRepository` gestisce l'accesso ai dati delle voci di lavoro.
abstract class WorkEntriesRepository {
  WorkEntriesRepository();
}

class WorkEntriesRepositoryImpl implements WorkEntriesRepository {
  final WorkEntriesProvider _workEntriesProvider;
  final WorkEntryMapper _workEntryMapper;

  WorkEntriesRepositoryImpl(
    this._workEntriesProvider,
    this._workEntryMapper,
  );

  /// Inserisce una nuova voce di lavoro.
  Future<void> insertWorkEntry(WorkEntry entry) async {
    try {
      final dto = _workEntryMapper.toDTO(entry);
      await _workEntriesProvider.insertWorkEntry(dto);
    } catch (e) {
      logger.e(
          'Errore durante l\'inserimento della voce di lavoro nel repository',
          error: e);
      throw Exception(
          'Errore durante l\'inserimento della voce di lavoro nel repository: ${e.toString()}');
    }
  }

  /// Recupera le voci di lavoro in base all'intervallo di date specificato.
  Future<List<WorkEntry>> getWorkEntries(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final dtos = await _workEntriesProvider.getWorkEntries(
        startDate,
        endDate,
      );
      return dtos.map(_workEntryMapper.fromDTO).toList(growable: false);
    } catch (e) {
      logger.e('Errore durante il recupero delle voci di lavoro nel repository',
          error: e);
      throw Exception(
          'Errore durante il recupero delle voci di lavoro nel repository: ${e.toString()}');
    }
  }

  /// Elimina tutte le voci di lavoro.
  Future<void> deleteAllWorkEntries() async {
    try {
      await _workEntriesProvider.deleteAllWorkEntries();
    } catch (e) {
      logger.e(
          'Errore durante l\'eliminazione di tutte le voci di lavoro nel repository',
          error: e);
      throw Exception(
          'Errore durante l\'eliminazione di tutte le voci di lavoro nel repository: ${e.toString()}');
    }
  }

  /// Elimina una specifica voce di lavoro in base all'ID.
  Future<void> deleteWorkEntry(int entryId) async {
    try {
      await _workEntriesProvider.deleteWorkEntry(entryId);
    } catch (e) {
      logger.e(
          'Errore durante l\'eliminazione della voce di lavoro nel repository',
          error: e);
      throw Exception(
          'Errore durante l\'eliminazione della voce di lavoro nel repository: ${e.toString()}');
    }
  }

  /// Aggiorna una voce di lavoro.
  Future<void> updateWorkEntry(WorkEntry entry) async {
    try {
      final dto = _workEntryMapper.toDTO(entry);
      await _workEntriesProvider.updateWorkEntry(dto);
    } catch (e) {
      logger.e(
          'Errore durante l\'aggiornamento della voce di lavoro nel repository',
          error: e);
      throw Exception(
          'Errore durante l\'aggiornamento della voce di lavoro nel repository: ${e.toString()}');
    }
  }

  /// Recupera l'ultima voce di lavoro inserita.
  Future<WorkEntry?> getLastWorkEntry() async {
    try {
      final dto = await _workEntriesProvider.getLastWorkEntry();
      if (dto != null) {
        return _workEntryMapper.fromDTO(dto);
      }
      return null;
    } catch (e) {
      logger.e(
          'Errore durante il recupero dell\'ultima voce di lavoro nel repository',
          error: e);
      throw Exception(
          'Errore durante il recupero dell\'ultima voce di lavoro nel repository: ${e.toString()}');
    }
  }

  /// Esporta le voci di lavoro in un file CSV.
  Future<String> exportToCsv(List<WorkEntry> entries) async {
    try {
      final rows = entries.map((entry) =>
          [entry.id, entry.timestamp.toIso8601String(), entry.isEntry]);

      final csv = const ListToCsvConverter().convert(rows.toList());

      final String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Salva file CSV',
        fileName: 'voci_di_lavoro.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (outputFile == null) {
        throw Exception('Nessun file selezionato');
      }

      final File file = File(outputFile);
      await file.writeAsString(csv);

      return outputFile;
    } catch (e) {
      logger.e('Errore durante l\'esportazione delle voci di lavoro in CSV',
          error: e);
      throw Exception(
          'Errore durante l\'esportazione delle voci di lavoro in CSV: ${e.toString()}');
    }
  }

  /// Importa le voci di lavoro da un file CSV.
  Future<void> importFromCsv(String path) async {
    try {
      final file = File(path);
      final csvString = await file.readAsString();
      final csvList = const CsvToListConverter().convert(csvString);

      final workEntries = csvList.map((row) {
        final id = row[0];
        final timestamp = DateTime.parse(row[1]);
        final isEntry = bool.parse(row[2]);
        return WorkEntry(id: id, timestamp: timestamp, isEntry: isEntry);
      }).toList();

      for (final workEntry in workEntries) {
        await _workEntriesProvider
            .insertWorkEntry(_workEntryMapper.toDTO(workEntry));
      }
    } catch (e) {
      logger.e('Errore durante l\'importazione delle voci di lavoro da CSV',
          error: e);
      throw Exception(
          'Errore durante l\'importazione delle voci di lavoro da CSV: ${e.toString()}');
    }
  }

  /// Calcola il tempo di lavoro giornaliero a partire dalle voci di lavoro.
  Future<Map<DateTime, Duration>> calculateWorkTimeMap() async {
    try {
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
    } catch (e) {
      logger.e('Errore durante il calcolo del tempo di lavoro', error: e);
      throw Exception(
          'Errore durante il calcolo del tempo di lavoro: ${e.toString()}');
    }
  }
}

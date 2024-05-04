import 'dart:io' as io;
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:file_selector/file_selector.dart' as selector;

import 'package:path_provider/path_provider.dart';
import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/data/datasources/mappers/work_entry_mapper.dart';

class DataExporter {
  /// Esporta i dati delle voci di lavoro dal database in un file CSV.
  ///
  /// Questa funzione recupera tutte le voci di lavoro dal database utilizzando il
  /// metodo `getAllWorkEntries` della classe `DatabaseHelper`. Converte le voci
  /// in un formato CSV utilizzando la libreria `csv`. Infine, salva il file CSV
  /// in una posizione appropriata a seconda della piattaforma:
  /// - Web: Scarica il file CSV utilizzando il browser.
  /// - Android/iOS: Salva il file CSV nella directory selezionata dall'utente utilizzando `FlutterFileDialog`.
  /// - Linux/macOS/Windows: Implementazione modificata per Linux per permettere la scelta della cartella e del nome del file.
  ///
  /// Restituisce il percorso del file.
  static Future<String?> exportToCsv() async {
    final databaseHelper = DatabaseHelper();
    WorkEntryMapper workEntryMapper = WorkEntryMapper();
    final workEntriesDto = await databaseHelper.getAllWorkEntries();
    final workEntries = List.generate(workEntriesDto.length,
        (index) => workEntryMapper.fromDTO(workEntriesDto[index]));
    // Converti le voci di lavoro in un formato CSV
    final csvData = workEntries
        .map((entry) => [
              entry.id,
              entry.timestamp,
              entry.isEntry,
            ])
        .toList();

    // Crea il contenuto CSV
    final csvString = const ListToCsvConverter().convert(csvData);

    // Ottieni il nome del file CSV
    final fileName = "work_entries_${DateTime.now().toIso8601String()}.csv";

    // Gestione specifica per piattaforma Linux
    if (io.Platform.isLinux) {
      // Prepara il dialogo per salvare il file
      const String fileName = 'exported_data.csv'; // Nome suggerito per il file
      final String? filePath = await selector
          .getSaveLocation(suggestedName: fileName)
          .then((value) =>
              value?.path); // Modifica qui: usa '?' per gestire il valore nullo

      if (filePath != null) {
        // Salva il file CSV
        final file = io.File(filePath);
        await file.writeAsString(
            csvString); // Assicurati che 'csvString' sia una stringa correttamente formattata in CSV
        return filePath; // Restituisci il percorso del file salvato
      } else {
        // Gestisci il caso in cui l'utente annulla l'azione
        return null; // O gestisci in un altro modo appropriato
      }
    } else if (io.Platform.isAndroid || io.Platform.isIOS) {
      // Per Android e iOS, salva il file CSV nella directory selezionata dall'utente utilizzando FlutterFileDialog
      final csvBytes = Uint8List.fromList(csvString.toString().codeUnits);
      final params = SaveFileDialogParams(
        sourceFilePath: null,
        data: csvBytes,
        localOnly: true,
        fileName: fileName,
      );
      final filePath = await FlutterFileDialog.saveFile(params: params);
      return filePath;
    } else {
      // Per macOS e Windows, salva il file CSV nella directory dei documenti dell'applicazione utilizzando path_provider
      final directory = await getApplicationDocumentsDirectory();
      final file = io.File('${directory.path}/$fileName');
      await file.writeAsString(csvString.toString());
      return file.path;
    }
  }
}

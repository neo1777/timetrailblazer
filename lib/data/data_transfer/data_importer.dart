import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:timetrailblazer/data/database/database.dart';
import 'package:timetrailblazer/data/datasources/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

class DataImporter {
  /// Importa i dati delle voci di lavoro da un file CSV nel database.
  ///
  /// Questa funzione utilizza un approccio diverso a seconda della piattaforma:
  /// - Web: Utilizza `file_picker` per consentire all'utente di selezionare un file CSV.
  /// - Android/iOS: Utilizza `FlutterFileDialog` per consentire all'utente di selezionare un file CSV.
  /// - Linux/macOS/Windows: Utilizza `file_picker` per consentire all'utente di selezionare un file CSV.
  ///
  /// Dopo aver selezionato il file CSV, legge il contenuto del file utilizzando la libreria `csv`
  /// e converte i dati in una lista di oggetti `WorkEntry`. Infine, inserisce le voci di lavoro nel
  /// database utilizzando il metodo `insertWorkEntry` della classe `DatabaseHelper`.
  static Future<void> importFromCsv() async {
    final databaseHelper = AppDatabase();

    String? csvString;

    if (Platform.isAndroid || Platform.isIOS) {
      // Per Android e iOS, utilizza FlutterFileDialog per selezionare il file CSV
      const params = OpenFileDialogParams(
        dialogType: OpenFileDialogType.document,
        sourceType: SourceType.photoLibrary,
        fileExtensionsFilter: ['csv'],
      );
      final filePath = await FlutterFileDialog.pickFile(params: params);
      if (filePath != null) {
        final file = File(filePath);
        csvString = await file.readAsString();
      }
    } else {
      // Per Linux, macOS e Windows, utilizza file_picker per selezionare il file CSV
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result != null) {
        final file = File(result.files.single.path!);
        csvString = await file.readAsString();
      }
    }

    if (csvString != null) {
      // Converti il contenuto CSV in una lista di mappe
      final csvList = const CsvToListConverter().convert(csvString);

      // Converti la lista di mappe in una lista di oggetti WorkEntry
      final workEntries = csvList.map((row) {
        return WorkEntryModel(
          id: row[0],
          timestamp: DateTime.parse(row[1]),
          isEntry: bool.parse(row[2]),
        );
      }).toList();

      //Resetta il database
      await databaseHelper.deleteAllWorkEntries();

      // Inserisci le voci di lavoro nel database
      for (final entry in workEntries) {
        final entryDTO = WorkEntryMapper().toDTO(entry);
        await databaseHelper.insertWorkEntry(entryDTO.toCompanion());
      }
    }
  }
}

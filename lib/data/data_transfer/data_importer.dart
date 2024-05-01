import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/data/datasources/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

class DataImporter {
  /// Importa i dati delle voci di lavoro da un file CSV nel database.
  ///
  /// Questa funzione utilizza il pacchetto `file_picker` per consentire all'utente
  /// di selezionare un file CSV dal dispositivo. Legge il contenuto del file CSV
  /// utilizzando la libreria `csv` e converte i dati in una lista di oggetti
  /// `WorkEntry`. Infine, inserisce le voci di lavoro nel database utilizzando
  /// il metodo `insertWorkEntry` della classe `DatabaseHelper`.
  static Future<void> importFromCsv() async {
    final databaseHelper = DatabaseHelper();


    // Seleziona il file CSV utilizzando il file picker
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final csvString = await file.readAsString();

      // Converti il contenuto CSV in una lista di mappe
      final csvList = const CsvToListConverter().convert(csvString);

      // Converti la lista di mappe in una lista di oggetti WorkEntry
      final workEntries = csvList.skip(1).map((row) {
        return WorkEntryModel(
          id: row[0],
          timestamp: DateTime.fromMillisecondsSinceEpoch(row[1]),
          isEntry: row[2] == 1,
        );
      }).toList();

      // Inserisci le voci di lavoro nel database
      for (final entry in workEntries) {
        final entryDTO = WorkEntryMapper().toDTO(entry);
        await databaseHelper.insertWorkEntry(entryDTO);
      }
    }
  }
}

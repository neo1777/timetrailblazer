import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timetrailblazer/data/database_helper.dart';

class DataExporter {
  /// Esporta i dati delle voci di lavoro dal database in un file CSV.
  ///
  /// Questa funzione recupera tutte le voci di lavoro dal database utilizzando il
  /// metodo `getAllWorkEntries` della classe `DatabaseHelper`. Converte le voci
  /// in un formato CSV utilizzando la libreria `csv`. Infine, salva il file CSV
  /// nella directory dei documenti dell'app utilizzando il pacchetto `path_provider`.
  ///
  /// Restituisce il percorso del file CSV esportato.
  static Future<String> exportToCsv() async {
    final databaseHelper = DatabaseHelper();
    final workEntries = await databaseHelper.getAllWorkEntries();

    // Converti le voci di lavoro in un formato CSV
    final  csvData = workEntries
        .map((entry) => [
              entry.id,
              entry.timestamp,
              entry.isEntry,
            ])
        .toList ();

    // // Aggiungi l'intestazione al file CSV
    // csvData.insert(0, ['ID', 'Timestamp', 'IsEntry']);

    // Crea il contenuto CSV
    final csvString = const ListToCsvConverter().convert(csvData);

    // Ottieni il percorso della directory dei documenti dell'app
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.absolute.path;

    // Crea il file CSV nella directory dei documenti
    final file =
        File('$path/work_entries_${DateTime.now().toIso8601String()}.csv');
    await file.writeAsString(csvString);

    return file.path;
  }
}

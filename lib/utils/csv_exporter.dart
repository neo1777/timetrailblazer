// csv_exporter.dart
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/config/constants_string.dart';

class CsvExporter {

  /// Esporta tutte le voci di lavoro dal database in un file CSV.
  ///
  /// Recupera tutte le voci di lavoro dal database utilizzando il metodo `getAllWorkEntries`
  /// della classe `DatabaseHelper`. Converte le voci di lavoro in un formato compatibile con CSV
  /// e le scrive in un file chiamato "work_entries.csv" nella directory selezionata dall'utente.
  ///
  /// Restituisce una stringa che rappresenta il percorso completo del file CSV esportato.
  ///
  /// In caso di errore durante l'esportazione, viene mostrato un SnackBar con un messaggio di errore appropriato.
  /// Se l'esportazione ha successo, viene mostrato un SnackBar con un messaggio di successo.
  static Future<String?> exportToCsv(navigatorKey) async {
  final databaseHelper = DatabaseHelper();
  final workEntries = await databaseHelper.getAllWorkEntries();

  if (workEntries.isEmpty) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(content: Text('${AppErrorMessages.csvExportError} Il database è vuoto.')),
    );
    return null;
  }

  final csvData = workEntries.map((entry) => [entry.id, entry.timestamp, entry.isEntry]).toList();
  final csvString = const ListToCsvConverter().convert(csvData);

  final String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory == null) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(content: Text('Nessuna directory selezionata. Esportazione annullata.')),
    );
    return null;
  }

  final file = File('$selectedDirectory/work_entries.csv');
  await file.writeAsString(csvString);

  if (navigatorKey.currentContext != null) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(content: Text('${AppSuccessMessages.csvExportCompleted} ${file.path}')),
    );
  }

  return file.path;
}
}
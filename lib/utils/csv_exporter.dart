import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/config/constants_string.dart';

class CsvExporter {
  /// Esporta tutte le voci di lavoro dal database in un file CSV.
  ///
  /// Questa funzione recupera tutte le voci di lavoro dal database utilizzando il metodo `getAllWorkEntries`
  /// della classe `DatabaseHelper`. Converte le voci di lavoro in un formato compatibile con CSV.
  ///
  /// Successivamente, mostra una finestra di dialogo per consentire all'utente di inserire il nome del file CSV da salvare.
  /// Se l'utente conferma, viene mostrata una seconda finestra di dialogo per selezionare la cartella di destinazione.
  ///
  /// Se l'utente conferma sia il nome del file che la cartella di destinazione, il file CSV viene salvato nella posizione specificata.
  ///
  /// In caso di errore durante l'esportazione, viene mostrato un SnackBar con un messaggio di errore appropriato.
  /// Se l'esportazione ha successo, viene mostrato un SnackBar con un messaggio di successo.
  static Future<String?> exportToCsv(navigatorKey) async {
    final databaseHelper = DatabaseHelper();
    final workEntries = await databaseHelper.getAllWorkEntries();

    if (workEntries.isEmpty) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
            content: Text(
                '${AppErrorMessages.csvExportError} Il database è vuoto.')),
      );
      return null;
    }

    final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm", "it_IT");

    final csvData = workEntries
        .map((entry) => [
              entry.id,
              dateFormat
                  .format(DateTime.fromMillisecondsSinceEpoch(entry.timestamp)),
              entry.isEntry
            ])
        .toList();

    final csvString = const ListToCsvConverter().convert(csvData);

    final String? fileName =
        await _showFileNameInputDialog(navigatorKey.currentContext!);

    if (fileName == null || fileName.isEmpty) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
            content:
                Text('Nessun nome file specificato. Esportazione annullata.')),
      );
      return null;
    }

    final String? selectedPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Seleziona la cartella di destinazione',
    );

    if (selectedPath == null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
            content:
                Text('Nessuna cartella selezionata. Esportazione annullata.')),
      );
      return null;
    }

    final file = File(path.join(selectedPath, '$fileName.csv'));
    await file.writeAsString(csvString);

    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
            content:
                Text('${AppSuccessMessages.csvExportCompleted} ${file.path}')),
      );
    }

    return file.path;
  }

  /// Mostra una finestra di dialogo per consentire all'utente di inserire il nome del file CSV da salvare.
  ///
  /// Questa funzione mostra una finestra di dialogo con un campo di testo in cui l'utente può inserire il nome del file.
  /// Se l'utente conferma, il nome del file viene restituito. Se l'utente annulla, viene restituito `null`.
  static Future<String?> _showFileNameInputDialog(BuildContext context) async {
    String? fileName;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inserisci il nome del file'),
          content: TextField(
            onChanged: (value) {
              fileName = value;
            },
            decoration: const InputDecoration(hintText: 'Nome file'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(fileName),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    return fileName;
  }
}

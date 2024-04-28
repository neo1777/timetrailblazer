// csv_importer.dart

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:timetrailblazer/data/database_helper.dart';
import 'package:timetrailblazer/data/dtos/work_entry_dto.dart';
import 'package:timetrailblazer/config/constants_string.dart';

class CsvImporter {

  /// Importa le voci di lavoro da un file CSV nel database.
  ///
  /// Utilizza il pacchetto `file_picker` per consentire all'utente di selezionare un file CSV dal dispositivo.
  /// Legge il contenuto del file CSV selezionato e lo converte in una lista di `WorkEntryDTO`.
  /// Cancella tutte le voci di lavoro esistenti dal database utilizzando il metodo `deleteAllWorkEntries`
  /// della classe `DatabaseHelper` e inserisce le nuove voci di lavoro utilizzando il metodo `insertWorkEntry`.
  ///
  /// Restituisce `true` se l'importazione ha avuto successo, `false` altrimenti.
  ///
  /// In caso di errore durante l'importazione, viene lanciata un'eccezione con un messaggio di errore appropriato.
  static Future<bool> importFromCsv() async {
    final databaseHelper = DatabaseHelper();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) {
      throw Exception(AppErrorMessages.csvSelectNullError);
    }

    final file = File(result.files.single.path!);

    if (!await file.exists()) {
      throw Exception(AppErrorMessages.csvFileNotFound);
    }

    final csvString = await file.readAsString();

    if (csvString.isEmpty) {
      throw Exception(AppErrorMessages.emptyCsvFile);
    }

    final csvList = const CsvToListConverter().convert(csvString);

    final workEntries = csvList.map((row) {
      return WorkEntryDTO(
        id: row[0],
        timestamp: row[1],
        isEntry: row[2],
      );
    }).toList();

    await databaseHelper.deleteAllWorkEntries();

    for (final entry in workEntries) {
      await databaseHelper.insertWorkEntry(entry);
    }

    return true;
  }

  /// Mostra una finestra di dialogo di conferma prima di importare i dati CSV.
  ///
  /// Se l'utente conferma l'importazione, viene chiamato il metodo `importFromCsv` per importare i dati CSV nel database.
  /// In caso di errore durante l'importazione, viene mostrato un messaggio di errore utilizzando il widget `SnackBar`.
  /// Se l'importazione ha successo, viene mostrato un messaggio di successo.
  static Future<void> showImportConfirmationDialog(navigatorKey) async {
    final BuildContext context = navigatorKey.currentContext!;
    final confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma Importazione'),
          content: const Text(
              'Importare i dati dal file CSV sovrascriverà il database attuale. Sei sicuro di voler procedere?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Importa'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        final success = await importFromCsv();
        if (success) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(
                content: Text(AppSuccessMessages.csvImportCompleted)),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
              content:
                  Text('${AppErrorMessages.csvImportError} ${e.toString()}')),
        );
      }
    }
  }
}

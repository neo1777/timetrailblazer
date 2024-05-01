import 'package:flutter/material.dart';
import 'package:timetrailblazer/data/data_transfer/data_exporter.dart';
import 'package:timetrailblazer/data/data_transfer/data_importer.dart';

class DataTransferWidget extends StatelessWidget {
  const DataTransferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            final filePath = await DataExporter.exportToCsv();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Dati esportati in $filePath')),
            );
          },
          child: const Text('Esporta CSV'),
        ),
        ElevatedButton(
          onPressed: () async {
            await DataImporter.importFromCsv();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dati importati con successo')),
            );
          },
          child: const Text('Importa CSV'),
        ),
      ],
    );
  }
}
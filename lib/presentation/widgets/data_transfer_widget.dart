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
        IconButton(
          icon: const Icon(Icons.file_upload),
          onPressed: () async {
            await DataImporter.importFromCsv()
                .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(
                          content: Text('Dati importati con successo')),
                    ));
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: () async {
            await DataExporter.exportToCsv()
                .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dati esportati in $value')),
                    ));
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:timetrailblazer/utils/csv_exporter.dart';
import 'package:timetrailblazer/utils/csv_importer.dart';

class CsvImportExportWidget extends StatelessWidget {
  const CsvImportExportWidget({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.file_upload),
          onPressed: () {
            CsvImporter.showImportConfirmationDialog(navigatorKey);
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: () {
            CsvExporter.exportToCsv(navigatorKey);
          },
        ),
      ],
    );
  }
}

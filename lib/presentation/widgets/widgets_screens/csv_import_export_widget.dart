// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/utils/csv_exporter.dart';
import 'package:timetrailblazer/utils/csv_importer.dart';

class CsvImportExportWidget extends StatelessWidget {
  final DateTime startDate;

  final DateTime endDate;

  const CsvImportExportWidget({
    super.key,
    required this.startDate,
    required this.endDate,
  });
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.file_upload),
          onPressed: () {
            CsvImporter.showImportConfirmationDialog(navigatorKey).then(
              (value) => BlocProvider.of<WorkEntriesBloc>(context).add(
                FetchWorkEntries(
                  startDate,
                  endDate,
                ),
              ),
            );
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

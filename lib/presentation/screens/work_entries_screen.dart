import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:timetrailblazer/config/constants_routes.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/data/data_transfer/data_exporter.dart';
import 'package:timetrailblazer/data/data_transfer/data_importer.dart';
import 'package:timetrailblazer/data/models/date_range_model.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_event.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_state.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/date_range_picker.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';
import 'package:timetrailblazer/presentation/widgets/widgets_screens/day_range_calendar.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';
import 'package:timetrailblazer/utils/error_handling.dart';

/// La schermata che mostra le voci di lavoro registrate.
class WorkEntriesScreen extends StatefulWidget {
  /// Costruttore della classe `WorkEntriesScreen`.
  const WorkEntriesScreen({super.key});

  @override
  WorkEntriesScreenState createState() => WorkEntriesScreenState();
}

/// Lo stato della schermata delle voci di lavoro.
class WorkEntriesScreenState extends State<WorkEntriesScreen> {
  /// Il controller di scorrimento per il calendario.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final dateRangeModel = Provider.of<DateRangeModel>(context, listen: false);
    context.read<WorkEntriesBloc>().add(FetchWorkEntries(
          dateRangeModel.startDate,
          dateRangeModel.endDate,
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateRangeModel = Provider.of<DateRangeModel>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.workEntriesTitle,
        onBackPressed: () {
          Navigator.pushNamed(context, AppRoutes.home);
        },
        onAction: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () async {
              await _showImportConfirmationDialog();
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
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _showDeleteConfirmationDialog(context, dateRangeModel);
            },
          ),
        ],
      ),
      body: BlocBuilder<WorkEntriesBloc, WorkEntriesState>(
        builder: (context, state) {
          if (state is WorkEntriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkEntriesLoaded) {
            final dayWorkEntriesList = state.entries;
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomSpacer(flex: 1),
                  Flexible(
                    flex: 3,
                    child: Consumer<DateRangeModel>(
                        builder: (context, model, child) {
                      return DateRangePicker(
                        startDate: dateRangeModel.startDate,
                        endDate: dateRangeModel.endDate,
                        onStartDateChanged: (date) {
                          dateRangeModel.startDate = date;
                          // Aggiorna le voci di lavoro quando la data di inizio viene modificata
                          context.read<WorkEntriesBloc>().add(FetchWorkEntries(
                                dateRangeModel.startDate,
                                dateRangeModel.endDate,
                              ));
                        },
                        onEndDateChanged: (date) {
                          dateRangeModel.endDate = date;
                          // Aggiorna le voci di lavoro quando la data di fine viene modificata
                          context.read<WorkEntriesBloc>().add(FetchWorkEntries(
                                dateRangeModel.startDate,
                                dateRangeModel.endDate,
                              ));
                        },
                        onCurrentMonthPressed: () {
                          final now = DateTime.now();
                          dateRangeModel.startDate =
                              DateTime(now.year, now.month, 1);
                          dateRangeModel.endDate =
                              DateTime(now.year, now.month + 1, 0);
                          // Aggiorna le voci di lavoro quando viene premuto il pulsante "Mese corrente"
                          context.read<WorkEntriesBloc>().add(FetchWorkEntries(
                                dateRangeModel.startDate,
                                dateRangeModel.endDate,
                              ));
                        },
                      );
                    }),
                  ),
                  const CustomSpacer(flex: 1),
                  Flexible(
                    flex: 3,
                    child: WorkButton(
                      label: AppStrings.workStatsTitle,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.workStats);
                      },
                    ),
                  ),
                  const CustomSpacer(flex: 2),
                  Flexible(
                    flex: 20,
                    child: DayRangeCalendar(
                      dayWorkEntriesList: dayWorkEntriesList,
                      scrollController: _scrollController,
                      startDate: dateRangeModel.startDate,
                      endDate: dateRangeModel.endDate,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is WorkEntriesError) {
            // Mostra un messaggio di errore in caso di errore durante il caricamento delle voci di lavoro
            ErrorHandling.handleError(state.message, _showErrorSnackBar);
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  /// Mostra una finestra di conferma per l'importazione dei dati.
  Future<void> _showImportConfirmationDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma importazione'),
        content: const Text(
            'L\'importazione sovrascriverà i dati attuali. Sei sicuro di voler procedere?'),
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
      ),
    );

    if (result == true) {
      await DataImporter.importFromCsv()
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dati importati con successo')),
              ))
          .then((_) {
        final dateRangeModel =
            Provider.of<DateRangeModel>(context, listen: false);
        context.read<WorkEntriesBloc>().add(FetchWorkEntries(
              dateRangeModel.startDate,
              dateRangeModel.endDate,
            ));
      });
    }
  }

  /// Mostra una finestra di conferma per l'eliminazione del database.
  void _showDeleteConfirmationDialog(
      BuildContext context, DateRangeModel dateRangeModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: const Text(
            'L\'eliminazione del database cancellerà tutti i dati. Sei sicuro di voler procedere?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<WorkEntriesBloc>(context).add(
                ResetDatabase(
                  dateRangeModel.startDate,
                  dateRangeModel.endDate,
                  onErrorCallback: _showErrorDialog,
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

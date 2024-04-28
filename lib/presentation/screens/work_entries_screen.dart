import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:timetrailblazer/config/constants_routes.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/data/models/date_range_model.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/date_range_picker.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';
import 'package:timetrailblazer/presentation/widgets/widgets_screens/csv_import_export_widget.dart';
import 'package:timetrailblazer/presentation/widgets/widgets_screens/day_range_calendar.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';

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
          const CsvImportExportWidget(),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              BlocProvider.of<WorkEntriesBloc>(context).add(
                ResetDatabase(
                  dateRangeModel.startDate,
                  dateRangeModel.endDate,
                  context: context,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<WorkEntriesBloc, WorkEntriesState>(
        builder: (context, state) {
          if (state is WorkEntriesLoading) {
            // Mostra un indicatore di caricamento mentre le voci di lavoro vengono caricate
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
            return const Center(child: Text(AppErrorMessages.getEntriesError));
          } else {
            // Stato non gestito, mostra un contenitore vuoto
            return Container();
          }
        },
      ),
    );
  }
}

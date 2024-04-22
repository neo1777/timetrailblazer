import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/config/constants_routes.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/date_range_picker.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';
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

  /// La data di inizio dell'intervallo di date.
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);

  /// La data di fine dell'intervallo di date.
  DateTime _endDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  @override
  void initState() {
    super.initState();
    // Aggiunta dell'evento per recuperare le voci di lavoro all'inizializzazione dello stato
    context.read<WorkEntriesBloc>().add(FetchWorkEntries(
          startDate: _startDate,
          endDate: _endDate,
        ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.workEntriesTitle,
        onBackPressed: () {
          Navigator.pushNamed(context, AppRoutes.home);
        },
        onAction: [
          const IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: null,
          ),
          const IconButton(
            icon: Icon(Icons.file_download),
            onPressed: null,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              context.read<WorkEntriesBloc>().add(
                    ResetDatabase(
                      startDate: _startDate,
                      endDate: _endDate,
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
            final dayWorkEntriesList = state.dayWorkEntriesList;
            return Column(
              children: [
                const CustomSpacer(flex: 1),
                Flexible(
                  flex: 3,
                  child: DateRangePicker(
                    startDate: _startDate,
                    endDate: _endDate,
                    onStartDateChanged: (date) {
                      _startDate = date;
                      // Aggiorna le voci di lavoro quando la data di inizio viene modificata
                      context.read<WorkEntriesBloc>().add(FetchWorkEntries(
                            startDate: _startDate,
                            endDate: _endDate,
                          ));
                    },
                    onEndDateChanged: (date) {
                      _endDate = date;
                      // Aggiorna le voci di lavoro quando la data di fine viene modificata
                      context.read<WorkEntriesBloc>().add(FetchWorkEntries(
                            startDate: _startDate,
                            endDate: _endDate,
                          ));
                    },
                    onCurrentMonthPressed: () {
                      final now = DateTime.now();
                      _startDate = DateTime(now.year, now.month, 1);
                      _endDate = DateTime(now.year, now.month + 1, 0);
                      // Aggiorna le voci di lavoro quando viene premuto il pulsante "Mese corrente"
                      context.read<WorkEntriesBloc>().add(FetchWorkEntries(
                            startDate: _startDate,
                            endDate: _endDate,
                          ));
                    },
                  ),
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
                const CustomSpacer(flex: 1),
                Expanded(
                  flex: 20,
                  child: DayRangeCalendar(
                    dayWorkEntriesList: dayWorkEntriesList,
                    scrollController: _scrollController,
                  ),
                ),
              ],
            );
          } else if (state is WorkEntriesError) {
            // Mostra un messaggio di errore in caso di errore durante il caricamento delle voci di lavoro
            return Center(child: Text(state.message));
          } else {
            // Stato non gestito, mostra un contenitore vuoto
            return Container();
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/date_range_model.dart';
import 'package:timetrailblazer/domain/blocs/work_stats/work_stats_bloc.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';

class WorkStatsScreen extends StatelessWidget {
  const WorkStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ottiene il modello DateRangeModel utilizzando il Provider
    final dateRangeModel = Provider.of<DateRangeModel>(context);

    return BlocProvider(
      create: (context) => WorkStatsBloc(
        RepositoryProvider.of<WorkEntryRepository>(context),
      )..add(ShowMonthlyStats()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.workStatsTitle,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<WorkStatsBloc, WorkStatsState>(
          builder: (context, state) {
            if (state is WorkStatsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WorkStatsLoaded) {
              final dailyStats = state.dailyStats;
              final monthlyStats = state.monthlyStats;
              final selectedRangeStats = state.selectedRangeStats;

              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    const CustomSpacer(flex: 1),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 2,
                            child: WorkButton(
                              label: 'Giornaliero',
                              onPressed: () {
                                context
                                    .read<WorkStatsBloc>()
                                    .add(ShowDailyStats());
                              },
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: WorkButton(
                              label: 'Mensile',
                              onPressed: () {
                                context
                                    .read<WorkStatsBloc>()
                                    .add(ShowMonthlyStats());
                              },
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: WorkButton(
                              label: 'Intervallo selezionato',
                              onPressed: () {
                                context
                                    .read<WorkStatsBloc>()
                                    .add(ShowSelectedRangeStats(
                                      startDate: dateRangeModel.startDate,
                                      endDate: dateRangeModel.endDate,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CustomSpacer(flex: 2),
                    // Mostra il titolo con le date di inizio e fine per l'intervallo selezionato
                    if (state.selectedView == StatsView.selectedRange)
                      Flexible(
                        flex: 5,
                        child: Text(
                          'Dal ${DateFormat('dd/MM/yyyy').format(dateRangeModel.startDate)} al ${DateFormat('dd/MM/yyyy').format(dateRangeModel.endDate)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    const CustomSpacer(flex: 1),
                    Flexible(
                      flex: 5,
                      child: state.selectedView == StatsView.daily
                          ? _buildDailyStatsList(dailyStats)
                          : state.selectedView == StatsView.monthly
                              ? _buildMonthlyStatsList(monthlyStats)
                              : _buildSelectedRangeStatsList(
                                  selectedRangeStats),
                    ),
                  ],
                ),
              );
            } else if (state is WorkStatsError) {
              return const Center(child: Text(AppErrorMessages.loadStatsError));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDailyStatsList(List<DailyWorkStats> dailyStats) {
    if (dailyStats.isEmpty) {
      return const Center(
          child: Text('Nessun dato disponibile per il giorno selezionato.'));
    }

    return ListView.separated(
      itemCount: dailyStats.length,
      itemBuilder: (context, index) {
        final dailyStat = dailyStats[index];
        final formattedDate = DateFormat('dd/MM/yyyy').format(dailyStat.date);
        final workedHours = dailyStat.workedHours.inHours;
        final overtimeHours = dailyStat.overtimeHours.inHours;

        return ListTile(
          title: Text(formattedDate),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ore lavorate: $workedHours'),
              Text('Ore di straordinario: $overtimeHours'),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget _buildMonthlyStatsList(List<MonthlyWorkStats> monthlyStats) {
    if (monthlyStats.isEmpty) {
      return const Center(
          child: Text('Nessun dato disponibile per il mese selezionato.'));
    }

    return ListView.separated(
      itemCount: monthlyStats.length,
      itemBuilder: (context, index) {
        final monthlyStat = monthlyStats[index];
        final formattedMonth =
            DateFormat('MMMM yyyy', 'it_IT').format(monthlyStat.month);
        final workedHours = monthlyStat.workedHours.inHours;
        final overtimeHours = monthlyStat.overtimeHours.inHours;

        return ListTile(
          title: Text(formattedMonth),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ore lavorate: $workedHours'),
              Text('Ore di straordinario: $overtimeHours'),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  Widget _buildSelectedRangeStatsList(List<DailyWorkStats> selectedRangeStats) {
    if (selectedRangeStats.isEmpty) {
      return const Center(
          child:
              Text('Nessun dato disponibile per l\'intervallo selezionato.'));
    }

    return ListView.separated(
      itemCount: selectedRangeStats.length,
      itemBuilder: (context, index) {
        final dailyStat = selectedRangeStats[index];
        final formattedDate = DateFormat('dd/MM/yyyy').format(dailyStat.date);
        final workedHours = dailyStat.workedHours.inHours;
        final overtimeHours = dailyStat.overtimeHours.inHours;

        return ListTile(
          title: Text(formattedDate),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ore lavorate: $workedHours'),
              Text('Ore di straordinario: $overtimeHours'),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timetrailblazer/config/app_constants.dart';
import 'package:timetrailblazer/data/dependencies/repositories/work_entries_repository.dart';
import 'package:timetrailblazer/presentation/widgets/work_stats_list_item.dart';
import 'package:timetrailblazer/utils/error_handler.dart';
import 'package:timetrailblazer/utils/logger.dart';

/// La schermata che mostra le statistiche di lavoro.
class WorkStatsScreen extends StatelessWidget {
  const WorkStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.workStatsTitle),
      ),
      // Utilizza `FutureBuilder` per gestire il caricamento asincrono delle statistiche dal repository
      body: FutureBuilder<Map<DateTime, Duration>>(
        future:
            context.read<WorkEntriesRepositoryImpl>().calculateWorkTimeMap(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            logger.e(AppErrorMessages.loadStatsError, error: snapshot.error);
            ErrorHandler.showErrorNotification(
              '${AppErrorMessages.loadStatsError}: ${snapshot.error}. ${AppErrorMessages.retryLater}',
            );
            return Container();
          } else {
            final workTimeMap = snapshot.data!;
            final workDates = workTimeMap.keys.toList();
            workDates.sort((a, b) => b.compareTo(a));

            return ListView.separated(
              itemCount: workDates.length,
              itemBuilder: (context, index) {
                final workDate = workDates[index];
                final workDuration = workTimeMap[workDate]!;

                // Mostra le statistiche di lavoro giornaliere utilizzando il widget `WorkStatsListItem`
                return WorkStatsListItem(
                  date: DateFormat('yyyy-MM-dd').format(workDate),
                  duration: workDuration,
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          }
        },
      ),
    );
  }
}

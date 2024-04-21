import 'package:flutter/material.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/presentation/widgets/app_bar.dart';
import 'package:timetrailblazer/presentation/widgets/spacer.dart';

/// La schermata che mostra le statistiche di lavoro.
class WorkStatsScreen extends StatelessWidget {
  const WorkStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.workStatsTitle,
        onBackPressed: () => Navigator.pop(context),
      ),
      // Utilizza `FutureBuilder` per gestire il caricamento asincrono delle statistiche dal repository
      body: FutureBuilder<Map<DateTime, Duration>>(
        future: null,
        //context.read<WorkEntriesRepositoryImpl>().calculateWorkTimeMap(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // logger.e(AppErrorMessages.loadStatsError, error: snapshot.error);
            // ErrorHandler.showErrorNotification(
            //   '${AppErrorMessages.loadStatsError}: ${snapshot.error}. ${AppErrorMessages.retryLater}',
            // );
            return Container();
          } else {
            //final workTimeMap = snapshot.data!;
            // final workDates = workTimeMap.keys.toList();
            // workDates.sort((a, b) => b.compareTo(a));

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
                  const Flexible(flex: 50, child: Placeholder()
                      //
                      // ListView.separated(
                      //   itemCount: workDates.length,
                      //   itemBuilder: (context, index) {
                      //     final workDate = workDates[index];
                      //     final workDuration = workTimeMap[workDate]!;

                      //     // Mostra le statistiche di lavoro giornaliere utilizzando il widget `WorkStatsListItem`
                      //     return Placeholder();
                      //     // WorkStatsListItem(
                      //     //   date: DateFormat('yyyy-MM-dd').format(workDate),
                      //     //   duration: workDuration,
                      //     // );
                      //   },
                      //   separatorBuilder: (context, index) => const Divider(),
                      // ),
                      ),
                  const CustomSpacer(flex: 1),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

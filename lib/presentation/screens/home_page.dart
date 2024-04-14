import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/config/app_constants.dart';
import 'package:timetrailblazer/config/routes.dart';
import 'package:timetrailblazer/data/dependencies/repositories/work_entries_repository.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_bloc.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';
import 'package:timetrailblazer/utils/error_handler.dart';
import 'package:timetrailblazer/utils/logger.dart';

/// La schermata principale dell'applicazione.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

/// Lo stato della schermata principale.
class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return FutureBuilder<WorkEntry?>(
              future:
                  context.read<WorkEntriesRepositoryImpl>().getLastWorkEntry(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Mostra un indicatore di caricamento mentre il FutureBuilder sta recuperando i dati
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  // Gestisci gli errori del FutureBuilder
                  return Center(
                      child: Text('${AppStrings.error}: ${snapshot.error}'));
                }
                final lastWorkEntry = snapshot.data;

                final isEntryAllowed =
                    lastWorkEntry == null || !lastWorkEntry.isEntry;

                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool isLandscape =
                        constraints.maxWidth > constraints.maxHeight;
                    final double buttonWidth =
                        constraints.maxWidth * (isLandscape ? 0.4 : 0.8);

                    return Padding(
                      padding:
                          const EdgeInsets.all(AppDimensions.screenPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: constraints.maxHeight * 0.1),
                          Flexible(
                            child: WorkButton(
                              label: AppStrings.entryButtonLabel,
                              onPressed: isEntryAllowed
                                  ? () {
                                      _registerEntry(context, true);
                                      context
                                          .read<HomeBloc>()
                                          .add(EntryButtonPressed());
                                    }
                                  : null,
                              width: buttonWidth,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.mediumSpacing),
                          Flexible(
                            child: WorkButton(
                              label: AppStrings.exitButtonLabel,
                              onPressed: !isEntryAllowed
                                  ? () {
                                      _registerEntry(context, false);
                                      context
                                          .read<HomeBloc>()
                                          .add(ExitButtonPressed());
                                    }
                                  : null,
                              width: buttonWidth,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.largeSpacing),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                      context, AppRoutes.workEntries)
                                  .then((_) => _refreshWorkEntries());
                            },
                            child:
                                const Text(AppStrings.viewEntriesButtonLabel),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Registra una nuova voce di lavoro (entrata o uscita) nel database.
  ///
  /// Parametri:
  ///   - `context`: il contesto del widget.
  ///   - `isEntry`: un flag che indica se la voce è un'entrata o un'uscita.
  void _registerEntry(BuildContext context, bool isEntry) {
    final now = DateTime.now();
    final workEntriesBloc = context.read<WorkEntriesBloc>();

    // Validazione dei dati
    if (now.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      // Mostra un messaggio di errore se la data è precedente a ieri
      ErrorHandler.showErrorDialog(
        AppErrorMessages.invalidDate,
        AppErrorMessages.invalidDateMessage,
      );
      return;
    }

    final entry = WorkEntry(
      timestamp: now,
      isEntry: isEntry,
    );

    try {
      // Controlla se i dati sono validi prima di chiamare il metodo del repository
      if (entry.timestamp
          .isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
        throw Exception(AppErrorMessages.invalidDate);
      }
      workEntriesBloc.add(AddWorkEntry(entry));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isEntry
                ? AppStrings.entryRegistered
                : AppStrings.exitRegistered)),
      );
    } catch (e) {
      logger.e(AppErrorMessages.registrationError, error: e);
      ErrorHandler.showErrorDialog(
        AppErrorMessages.registrationError,
        AppErrorMessages.registrationErrorMessage(e.toString()),
      );
    }
  }

  /// Aggiorna le voci di lavoro visualizzate nella schermata WorkEntriesScreen.
  void _refreshWorkEntries() {
    final workEntriesBloc = context.read<WorkEntriesBloc>();
    workEntriesBloc.add(
      FetchWorkEntries(
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now(),
      ),
    );
  }
}

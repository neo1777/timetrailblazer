import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/constants.dart';
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
      appBar: AppBar(
        title: const Text(homeTitle),
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
                  return Center(child: Text('Errore: ${snapshot.error}'));
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: constraints.maxHeight * 0.1),
                          Flexible(
                            child: WorkButton(
                              label: 'Entrata',
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
                          const SizedBox(height: 16),
                          Flexible(
                            child: WorkButton(
                              label: 'Uscita',
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
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/work_entries')
                                  .then((_) => _refreshWorkEntries());
                            },
                            child: const Text('Visualizza registrazioni'),
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
  void _registerEntry(BuildContext context, bool isEntry) {
    final now = DateTime.now();
    final workEntriesBloc = context.read<WorkEntriesBloc>();

    // Validazione dei dati
    if (now.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      // Mostra un messaggio di errore se la data è precedente a ieri
      ErrorHandler.showErrorDialog(
        'Data non valida',
        'Non è possibile registrare voci di lavoro per date precedenti a ieri. Per favore, seleziona una data valida.',
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
        throw Exception('Data non valida');
      }
      workEntriesBloc.add(AddWorkEntry(entry));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEntry ? entryRegistered : exitRegistered)),
      );
    } catch (e) {
      logger.e('Errore durante la registrazione della voce di lavoro',
          error: e);
      ErrorHandler.showErrorDialog('Errore di registrazione',
          'Errore durante la registrazione della voce di lavoro: ${e.toString()}. Si prega di verificare i dati inseriti e riprovare. Se il problema persiste, contattare l\'assistenza.');
    }
  }

  /// Aggiorna le voci di lavoro visualizzate nella schermata.
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

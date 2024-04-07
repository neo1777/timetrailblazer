import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/constants.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';
import 'package:timetrailblazer/presentation/widgets/work_button.dart';

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
        child: BlocBuilder<WorkEntriesBloc, WorkEntriesState>(
          // Il `BlocBuilder` viene utilizzato per reagire ai cambiamenti di stato del `WorkEntriesBloc`
          // Ricostruisce il widget in base allo stato corrente del bloc
          builder: (context, state) {
            if (state is WorkEntriesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is WorkEntriesError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            // Logica di abilitazione/disabilitazione dei pulsanti di entrata e uscita in base allo stato delle voci di lavoro
            final isEntryAllowed = state is WorkEntriesInitial ||
                (state is WorkEntriesLoaded &&
                    (state.entries.isEmpty || !state.entries.last.isEntry));
            final isExitAllowed = state is WorkEntriesLoaded &&
                state.entries.isNotEmpty &&
                state.entries.last.isEntry;
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
                              ? () => _registerEntry(context, true)
                              : null,
                          width: buttonWidth,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: WorkButton(
                          label: 'Uscita',
                          onPressed: isExitAllowed
                              ? () => _registerEntry(context, false)
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
        ),
      ),
    );
  }

  /// Registra una nuova voce di lavoro (entrata o uscita) nel database.
  void _registerEntry(BuildContext context, bool isEntry) {
    final workEntriesBloc = context.read<WorkEntriesBloc>();
    final entry = WorkEntry(
      timestamp: DateTime.now(),
      isEntry: isEntry,
    );
    workEntriesBloc.add(AddWorkEntry(entry));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isEntry ? entryRegistered : exitRegistered)),
    );
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

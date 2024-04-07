import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/dependencies/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/dependencies/providers/work_entries_provider.dart';
import 'package:timetrailblazer/data/dependencies/repositories/work_entries_repository.dart';

/// Restituisce una lista di `RepositoryProvider` per l'iniezione dei repository nell'albero dei widget.
List<RepositoryProvider<dynamic>> getRepositories() {
  return [
    // Fornisce il `WorkEntriesRepository` all'albero dei widget, creandolo con il `WorkEntriesProvider` e il `WorkEntryMapper`.
    // Il `WorkEntriesRepository` è responsabile dell'accesso ai dati delle voci di lavoro e della loro gestione.
    RepositoryProvider<WorkEntriesRepository>(
      create: (context) => WorkEntriesRepository(
        context.read<WorkEntriesProvider>(),
        context.read<WorkEntryMapper>(),
      ),
    ),
  ];
}

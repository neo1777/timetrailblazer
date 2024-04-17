import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/dependencies/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/dependencies/providers/work_entries_provider.dart';
import 'package:timetrailblazer/data/dependencies/repositories/work_entries_repository.dart';

/// Restituisce una lista di `RepositoryProvider` per l'iniezione dei repository nell'albero dei widget.
///
/// Questa funzione configura i repository necessari per l'applicazione, creandoli con le loro dipendenze.
/// I repository sono responsabili dell'accesso ai dati e della loro gestione, fungendo da intermediari tra i provider e i BLoC.
/// Utilizza l'approccio "lazy" per creare i repository solo quando vengono effettivamente richiesti.
///
/// Returns:
/// - Una lista di `RepositoryProvider` contenente i repository configurati.
List<RepositoryProvider<dynamic>> getRepositories() {
  return [
    // Fornisce il `WorkEntriesRepository` all'albero dei widget, creandolo con il `WorkEntriesProvider` e il `WorkEntryMapper`.
    // Il `WorkEntriesRepository` è responsabile dell'accesso ai dati delle voci di lavoro e della loro gestione.
    // Utilizza l'approccio "lazy" per creare il repository solo quando viene effettivamente richiesto.
    RepositoryProvider<WorkEntriesRepositoryImpl>(
      create: (context) => WorkEntriesRepositoryImpl(
        context.read<WorkEntriesProvider>(),
        context.read<WorkEntryMapper>(),
      ),
      lazy: true,
    ),
  ];
}
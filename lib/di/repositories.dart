import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/mappers/work_entry_mapper.dart';
import 'package:timetrailblazer/data/datasources/providers/work_entry_provider.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';

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
    RepositoryProvider<WorkEntryRepository>(
      create: (context) => WorkEntryRepository(
        context.read<WorkEntryProvider>(),
        context.read<WorkEntryMapper>(),
      ),
      lazy: true,
    ),
  ];
}

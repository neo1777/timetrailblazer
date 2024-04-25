import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_bloc.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';

/// Restituisce una lista di `BlocProvider` per l'iniezione dei BLoC nell'albero dei widget.
///
/// Questa funzione configura i BLoC necessari per l'applicazione, creandoli con le loro dipendenze.
/// I BLoC sono responsabili della gestione dello stato e della logica di business dell'applicazione.
/// Utilizza l'approccio "lazy" per creare i BLoC solo quando vengono effettivamente richiesti.
///
/// Returns:
/// - Una lista di `BlocProvider` contenente i BLoC configurati.
List<BlocProvider<StateStreamableSource<Object?>>> getBlocProviders() {
  return [
    // Fornisce il `HomeBloc` all'albero dei widget, creandolo senza dipendenze esterne.
    // Il `HomeBloc` è responsabile della gestione dello stato relativo alla schermata principale dell'applicazione.
    // Utilizza l'approccio "lazy" per creare il BLoC solo quando viene effettivamente richiesto.
    BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(workEntryRepository:
        context.read<WorkEntryRepository>(),
      ),
      lazy: true,
    ),

    // Fornisce il `WorkEntriesBloc` all'albero dei widget, creandolo con il `WorkEntriesRepository`.
    // Il `WorkEntriesBloc` è responsabile della gestione dello stato relativo alle voci di lavoro.
    // Utilizza l'approccio "lazy" per creare il BLoC solo quando viene effettivamente richiesto.

    BlocProvider<WorkEntriesBloc>(
      create: (context) => WorkEntriesBloc(workEntryRepository:
        context.read<WorkEntryRepository>(),
      ),
      lazy: true,
    ),
  ];
}

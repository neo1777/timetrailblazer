import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/dependencies/repositories/work_entries_repository.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_bloc.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_bloc.dart';

/// Restituisce una lista di `BlocProvider` per l'iniezione dei BLoC nell'albero dei widget.
List<BlocProvider<StateStreamableSource<Object?>>> getBlocProviders() {
  return [
    // Fornisce il `WorkEntriesBloc` all'albero dei widget, creandolo con il `WorkEntriesRepository`.
    // Il `WorkEntriesBloc` è responsabile della gestione dello stato relativo alle voci di lavoro.
    BlocProvider<WorkEntriesBloc>(
      create: (context) => WorkEntriesBloc(
        context.read<WorkEntriesRepositoryImpl>(),
      ),
    ),

    // Fornisce il `HomeBloc` all'albero dei widget, creandolo senza dipendenze esterne.
    // Il `HomeBloc` è responsabile della gestione dello stato relativo alla schermata principale dell'applicazione.
    BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(),
    ),
  ];
}

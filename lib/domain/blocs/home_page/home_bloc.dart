import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

part 'home_event.dart';
part 'home_state.dart';

/// La classe `HomeBloc` gestisce la logica di business e lo stato della schermata principale dell'applicazione.
///
/// Questo BLoC si occupa di gestire lo stato dei pulsanti "Entrata" e "Uscita" sulla base dell'ultima voce di lavoro registrata.
/// Fornisce eventi e stati appropriati per consentire l'interazione con la schermata principale.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// Il repository delle voci di lavoro utilizzato per accedere ai dati.
  final WorkEntryRepository workEntryRepository;

  /// Costruttore della classe `HomeBloc`.
  ///
  /// Accetta un parametro [workEntryRepository] di tipo [WorkEntryRepository] per accedere ai dati delle voci di lavoro.
  /// Inizializza lo stato iniziale a [HomeInitial] e registra i gestori degli eventi utilizzando il metodo `on`.
  HomeBloc({required this.workEntryRepository}) : super(HomeInitial()) {
    on<HomeStarted>(_homeStarted);
    on<EntryButtonPressed>(_entryButtonPressed);
    on<ExitButtonPressed>(_exitButtonPressed);
    on<DatabaseReset>(_databaseReset);
  }

  /// Gestore dell'evento [HomeStarted].
  ///
  /// Questo metodo viene chiamato quando viene ricevuto l'evento [HomeStarted].
  /// Recupera l'ultima voce di lavoro dal repository e imposta lo stato appropriato in base al valore di [isEntry].
  _homeStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final lastEntry = await workEntryRepository.getLastWorkEntry();
    if (lastEntry == null) {
      emit(HomeEntryButtonEnabled());
    } else {
      emit(lastEntry.isEntry!
          ? HomeExitButtonEnabled()
          : HomeEntryButtonEnabled());
    }
  }

  /// Gestore dell'evento [EntryButtonPressed].
  ///
  /// Questo metodo viene chiamato quando viene ricevuto l'evento [EntryButtonPressed].
  /// Inserisce una nuova voce di lavoro con [isEntry] impostato su true (entrata) e imposta lo stato [HomeExitButtonEnabled].
  _entryButtonPressed(EntryButtonPressed event, Emitter<HomeState> emit) async {
    await workEntryRepository.insertWorkEntry(WorkEntryModel(
        timestamp: DateTime.now(), // ora corrente come timestamp
        isEntry: true)); // Assumi che true indichi un'entrata
    emit(HomeExitButtonEnabled());
  }

  /// Gestore dell'evento [ExitButtonPressed].
  ///
  /// Questo metodo viene chiamato quando viene ricevuto l'evento [ExitButtonPressed].
  /// Inserisce una nuova voce di lavoro con [isEntry] impostato su false (uscita) e imposta lo stato [HomeEntryButtonEnabled].
  _exitButtonPressed(ExitButtonPressed event, Emitter<HomeState> emit) async {
    await workEntryRepository.insertWorkEntry(WorkEntryModel(
        timestamp: DateTime.now(), // ora corrente come timestamp
        isEntry: false)); // Assumi che false indichi un'uscita
    emit(HomeEntryButtonEnabled());
  }

  /// Gestore dell'evento [DatabaseReset].
  ///
  /// Questo metodo viene chiamato quando viene ricevuto l'evento [DatabaseReset].
  /// Imposta lo stato [HomeEntryButtonEnabled] per abilitare il pulsante di entrata dopo il reset del database.
  _databaseReset(DatabaseReset event, Emitter<HomeState> emit) {
    emit(HomeEntryButtonEnabled());
  }
}

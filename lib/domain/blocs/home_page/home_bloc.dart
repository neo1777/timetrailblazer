import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_event.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_state.dart';

/// La classe `HomeBloc` gestisce la logica di business e lo stato della schermata principale dell'applicazione.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// Il repository delle voci di lavoro utilizzato per accedere ai dati.
  final WorkEntryRepository workEntryRepository;

  /// Costruttore della classe `HomeBloc`.
  ///
  /// Accetta un parametro [workEntryRepository] di tipo [WorkEntryRepository] per accedere ai dati delle voci di lavoro.
  /// Inizializza lo stato iniziale a [HomeInitial] e registra i gestori degli eventi utilizzando il metodo `on`.
  HomeBloc({required this.workEntryRepository}) : super(HomeInitial()) {
    on<HomeStarted>(_onHomeStarted);
    on<EntryButtonPressed>(_onEntryButtonPressed);
    on<ExitButtonPressed>(_onExitButtonPressed);
    on<DatabaseReset>(_onDatabaseReset);
  }

  /// Gestore dell'evento [HomeStarted].
  ///
  /// Recupera l'ultima voce di lavoro dal repository e imposta lo stato appropriato in base al valore di [isEntry].
  Future<void> _onHomeStarted(
      HomeStarted event, Emitter<HomeState> emit) async {
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
  /// Inserisce una nuova voce di lavoro con [isEntry] impostato su true (entrata) e imposta lo stato [HomeExitButtonEnabled].
  Future<void> _onEntryButtonPressed(
      EntryButtonPressed event, Emitter<HomeState> emit) async {
    final now = DateTime.now();
    await workEntryRepository.insertWorkEntry(
      WorkEntryModel(
        timestamp: now,
        isEntry: true,
      ),
      //timestamp: now,
    );
    emit(HomeExitButtonEnabled());
  }

  /// Gestore dell'evento [ExitButtonPressed].
  ///
  /// Inserisce una nuova voce di lavoro con [isEntry] impostato su false (uscita) e imposta lo stato [HomeEntryButtonEnabled].
  Future<void> _onExitButtonPressed(
      ExitButtonPressed event, Emitter<HomeState> emit) async {
    final now = DateTime.now();
    await workEntryRepository.insertWorkEntry(
      WorkEntryModel(
        timestamp: now,
        isEntry: false,
      ),
      //timestamp: now,
    );
    emit(HomeEntryButtonEnabled());
  }

  /// Gestore dell'evento [DatabaseReset].
  ///
  /// Imposta lo stato [HomeEntryButtonEnabled] per abilitare il pulsante di entrata dopo il reset del database.
  void _onDatabaseReset(DatabaseReset event, Emitter<HomeState> emit) {
    emit(HomeEntryButtonEnabled());
  }
}

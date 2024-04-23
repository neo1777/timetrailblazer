import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_bloc.dart';

part 'work_entries_event.dart';
part 'work_entries_state.dart';

/// Il BLoC che gestisce lo stato delle voci di lavoro.
class WorkEntriesBloc extends Bloc<WorkEntriesEvent, WorkEntriesState> {
  /// Il repository delle voci di lavoro.
  final WorkEntryRepository _workEntryRepository;

  /// Il BLoC della schermata principale.
  final HomeBloc _homeBloc;

  /// Costruttore del BLoC.
  ///
  /// Inizializza lo stato iniziale del BLoC a `WorkEntriesInitial`.
  /// Riceve come dipendenze il [WorkEntryRepository] per interagire con il database
  /// e il [HomeBloc] per comunicare con la schermata principale.
  WorkEntriesBloc(
    this._workEntryRepository,
    this._homeBloc,
  ) : super(WorkEntriesInitial()) {
    /// Gestisce l'evento `FetchWorkEntries`.
    on<FetchWorkEntries>(_onFetchWorkEntries);

    /// Gestisce l'evento `ResetDatabase`.
    on<ResetDatabase>(_onResetDatabase);

    /// Gestisce l'evento `DeleteWorkEntry`.
    on<DeleteWorkEntry>(_onDeleteWorkEntry);
  }

  /// Gestore dell'evento `ResetDatabase`.
  ///
  /// Quando viene richiesto il reset del database:
  /// 1. Emette lo stato `WorkEntriesLoading` per indicare che è in corso il reset.
  /// 2. Chiama il metodo `resetDatabase` del repository per resettare il database.
  /// 3. Genera la lista dei giorni compresi tra la data di inizio e la data di fine.
  /// 4. Crea una lista di `DayWorkEntriesModel` con i giorni generati e nessuna voce di lavoro associata.
  /// 5. Emette lo stato `WorkEntriesLoaded` con la lista di `DayWorkEntriesModel` generata.
  /// 6. Aggiunge l'evento `DatabaseReset` al `HomeBloc` per comunicare il reset del database.
  /// 7. In caso di errore, emette lo stato `WorkEntriesError` con un messaggio di errore.
  Future<void> _onResetDatabase(
      ResetDatabase event, Emitter<WorkEntriesState> emit) async {
    emit(WorkEntriesLoading());
    try {
      await _workEntryRepository.resetDatabase();

      final startDate = event.startDate;
      final endDate = event.endDate;

      // Genera la lista di giorni compresi tra la data di inizio e la data di fine
      final days = List.generate(
        endDate.difference(startDate).inDays + 1,
        (index) => startDate.add(Duration(days: index)),
      );

      // Crea una lista di DayWorkEntriesModel con i giorni generati e nessuna voce di lavoro associata
      final dayWorkEntriesList = days
          .map((day) => DayWorkEntriesModel(day: day, workEntries: null))
          .toList();

      emit(
        WorkEntriesLoaded(
          dayWorkEntriesList: dayWorkEntriesList,
          startDate: startDate,
          endDate: endDate,
        ),
      );

      // Aggiunge l'evento DatabaseReset al HomeBloc per comunicare il reset del database
      _homeBloc.add(DatabaseReset());
    } catch (error) {
      emit(const WorkEntriesError(
          message: 'Errore durante il reset del database'));
    }
  }

  /// Gestore dell'evento `DeleteWorkEntry`.
  ///
  /// Quando viene richiesta la cancellazione di una singola voce di lavoro:
  /// 1. Emette lo stato `WorkEntriesLoading` per indicare che è in corso la cancellazione.
  /// 2. Chiama il metodo `deleteWorkEntryById` del repository per cancellare la voce di lavoro.
  /// 3. Recupera le date di inizio e fine correnti dallo stato `WorkEntriesLoaded`.
  /// 4. Chiama il metodo `getWorkEntriesByDays` del repository con le date di inizio e fine correnti per recuperare le voci di lavoro aggiornate.
  /// 5. Emette lo stato `WorkEntriesLoaded` con le voci di lavoro aggiornate.
  /// 6. In caso di errore o se lo stato corrente non è `WorkEntriesLoaded`, emette lo stato `WorkEntriesError` con un messaggio di errore.
  Future<void> _onDeleteWorkEntry(
      DeleteWorkEntry event, Emitter<WorkEntriesState> emit) async {
    try {
      await _workEntryRepository.deleteWorkEntryById(event.id);

      final startDate = event.startDate;
      final endDate = event.endDate;

      // Genera la lista di giorni compresi tra la data di inizio e la data di fine
      final days = List.generate(
        endDate.difference(startDate).inDays + 1,
        (index) => startDate.add(Duration(days: index)),
      );

      final dayWorkEntriesList =
          await _workEntryRepository.getWorkEntriesByDays(days, endDate);

      emit(WorkEntriesLoaded(
          startDate: startDate,
          endDate: endDate,
          dayWorkEntriesList: dayWorkEntriesList));
    } catch (error) {
      //print(error);
      emit(const WorkEntriesError(
          message: 'Errore durante la cancellazione della voce di lavoro'));
    }
  }

  /// Gestore dell'evento `FetchWorkEntries`.
  ///
  /// Quando viene richiesto il recupero delle voci di lavoro:
  /// 1. Emette lo stato `WorkEntriesLoadingper indicare che è in corso il caricamento.   /// 2. Genera la lista di giorni compresi tra la data di inizio e la data di fine.   /// 3. Recupera le voci di lavoro dal repository per i giorni generati.   /// 4. Emette lo statoWorkEntriesLoadedcon le voci di lavoro recuperate.   /// 5. In caso di errore, emette lo statoWorkEntriesError` con un messaggio di errore.
  Future<void> _onFetchWorkEntries(
      FetchWorkEntries event, Emitter<WorkEntriesState> emit) async {
    emit(WorkEntriesLoading());
    try {
      final startDate = event.startDate;
      final endDate = event
          .endDate; // Genera la lista di giorni compresi tra la data di inizio e la data di fine
      final days = List.generate(
        endDate.difference(startDate).inDays + 1,
        (index) => startDate.add(Duration(days: index)),
      );

      // Recupera le voci di lavoro dal repository per i giorni generati
      final dayWorkEntriesList =
          await _workEntryRepository.getWorkEntriesByDays(
        days,
        endDate,
      );

      emit(
        WorkEntriesLoaded(
          dayWorkEntriesList: dayWorkEntriesList,
          startDate: startDate,
          endDate: endDate,
        ),
      );
    } catch (error) {
      emit(const WorkEntriesError(
          message: 'Errore durante il caricamento delle voci di lavoro'));
    }
  }
}

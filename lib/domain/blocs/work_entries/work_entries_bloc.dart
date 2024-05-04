import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/config/constants_string.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_event.dart';
import 'package:timetrailblazer/domain/blocs/work_entries/work_entries_state.dart';

/// La classe `WorkEntriesBloc` gestisce la logica di business e lo stato delle voci di lavoro.
class WorkEntriesBloc extends Bloc<WorkEntriesEvent, WorkEntriesState> {
  /// Il repository delle voci di lavoro utilizzato per accedere ai dati.
  final WorkEntryRepository workEntryRepository;

  /// Costruttore della classe `WorkEntriesBloc`.
  ///
  /// Accetta un parametro [workEntryRepository] di tipo [WorkEntryRepository] per accedere ai dati delle voci di lavoro.
  /// Inizializza lo stato iniziale a [WorkEntriesInitial] e registra i gestori degli eventi utilizzando il metodo `on`.
  WorkEntriesBloc({required this.workEntryRepository})
      : super(WorkEntriesInitial()) {
    on<FetchWorkEntries>(_onFetchWorkEntries);
    on<WorkEntriesUpdated>(_onWorkEntriesUpdated);
    on<ResetDatabase>(_onResetDatabase);
    on<DeleteWorkEntry>(_onDeleteWorkEntry);
  }

  /// Gestore dell'evento [FetchWorkEntries].
  ///
  /// Recupera le voci di lavoro dall'intervallo di date specificato utilizzando il repository.
  /// In caso di successo, imposta lo stato [WorkEntriesLoaded] con le voci di lavoro caricate.
  /// In caso di errore, imposta lo stato [WorkEntriesError] con un messaggio di errore appropriato.
  Future<void> _onFetchWorkEntries(
      FetchWorkEntries event, Emitter<WorkEntriesState> emit) async {
    emit(WorkEntriesLoading());
    try {
      final days = getDaysInRange(event.startDate, event.endDate);
      final entries =
          await workEntryRepository.getWorkEntriesByDays(days, event.endDate);
      emit(WorkEntriesLoaded(entries));
    } catch (e) {
      emit(WorkEntriesError(
          AppErrorMessages.fetchEntriesErrorMessage(e.toString())));
    }
  }

  /// Restituisce una lista di date nell'intervallo specificato.
  List<DateTime> getDaysInRange(DateTime startDate, DateTime endDate) {
    final days = <DateTime>[];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  /// Gestore dell'evento [WorkEntriesUpdated].
  ///
  /// Imposta lo stato [WorkEntriesLoaded] con le voci di lavoro aggiornate.
  void _onWorkEntriesUpdated(
      WorkEntriesUpdated event, Emitter<WorkEntriesState> emit) {
    emit(WorkEntriesLoaded(event.updatedEntries));
  }

  /// Gestore dell'evento [ResetDatabase].
  ///
  /// Resetta il database utilizzando il repository.
  /// In caso di successo, emette l'evento [FetchWorkEntries] per ricaricare le voci di lavoro e imposta lo stato [DatabaseResetSuccess].
  /// In caso di errore, imposta lo stato [WorkEntriesError] con un messaggio di errore appropriato.
  Future<void> _onResetDatabase(
      ResetDatabase event, Emitter<WorkEntriesState> emit) async {
    emit(WorkEntriesLoading());
    try {
      await workEntryRepository.resetDatabase();
      add(FetchWorkEntries(event.startDate, event.endDate));
      emit(DatabaseResetSuccess());
    } catch (e) {
      emit(WorkEntriesError(AppErrorMessages.resetDatabaseError));
      event.onErrorCallback(AppErrorMessages.errorOccurred, e.toString());
    }
  }

  /// Gestore dell'evento [DeleteWorkEntry].
  ///
  /// Elimina una voce di lavoro utilizzando il repository.
  /// In caso di successo, emette l'evento [FetchWorkEntries] per ricaricare le voci di lavoro e imposta lo stato [WorkEntryDeleted].
  /// In caso di errore, imposta lo stato [WorkEntriesError] con un messaggio di errore appropriato.
  Future<void> _onDeleteWorkEntry(
      DeleteWorkEntry event, Emitter<WorkEntriesState> emit) async {
    emit(WorkEntriesLoading());
    try {
      await workEntryRepository.deleteWorkEntryById(event.id);
      add(FetchWorkEntries(event.startDate, event.endDate));
      emit(WorkEntryDeleted());
    } catch (e) {
      emit(WorkEntriesError(
          AppErrorMessages.workEntriesOperationErrorMessage(e.toString())));
      event.onErrorCallback(AppErrorMessages.errorOccurred, e.toString());
    }
  }
}

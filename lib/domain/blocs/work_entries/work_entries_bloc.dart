import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timetrailblazer/data/dependencies/repositories/work_entries_repository.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';
import 'package:timetrailblazer/utils/logger.dart';

part 'work_entries_event.dart';
part 'work_entries_state.dart';

/// Il `WorkEntriesBloc` gestisce lo stato e gli eventi relativi alle voci di lavoro.
class WorkEntriesBloc extends Bloc<WorkEntriesEvent, WorkEntriesState> {
  final WorkEntriesRepositoryImpl _workEntriesRepository;

  /// Costruttore del `WorkEntriesBloc` che accetta un `WorkEntriesRepository`.
  WorkEntriesBloc(this._workEntriesRepository) : super(WorkEntriesInitial()) {
    // Gestisce l'evento `FetchWorkEntries` per recuperare le voci di lavoro.
    on<FetchWorkEntries>(_onFetchWorkEntries);
    // Gestisce l'evento `AddWorkEntry` per aggiungere una nuova voce di lavoro.
    on<AddWorkEntry>(_onAddWorkEntry);
    // Gestisce l'evento `UpdateWorkEntry` per aggiornare una voce di lavoro esistente.
    on<UpdateWorkEntry>(_onUpdateWorkEntry);
    // Gestisce l'evento `DeleteWorkEntry` per eliminare una voce di lavoro.
    on<DeleteWorkEntry>(_onDeleteWorkEntry);
    // Gestisce l'evento `DeleteAllWorkEntries` per eliminare tutte le voci di lavoro.
    on<DeleteAllWorkEntries>(_onDeleteAllWorkEntries);
    // Gestisce l'evento `UpdateDateRange` per aggiornare l'intervallo di date di inizio e fine.
    on<UpdateDateRange>(_onUpdateDateRange);
  }

  /// Gestore dell'evento `FetchWorkEntries`.
  /// Recupera le voci di lavoro dal repository e le emette nello stato `WorkEntriesLoaded`.
  Future<void> _onFetchWorkEntries(
    FetchWorkEntries event,
    Emitter<WorkEntriesState> emit,
  ) async {
    emit(WorkEntriesLoading());
    try {
      final entries = await _workEntriesRepository.getWorkEntries(
        event.startDate,
        event.endDate,
      );
      final sortedEntries = entries.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      emit(WorkEntriesLoaded(sortedEntries, _groupEntriesByDay(sortedEntries)));
    } catch (e) {
      logger.e('Errore durante il recupero delle voci di lavoro', error: e);
      emit(WorkEntriesError(
          'Errore durante il recupero delle voci di lavoro: ${e.toString()}. Si prega di riprovare più tardi o contattare l\'assistenza se il problema persiste.'));
    }
  }

  /// Raggruppa le voci di lavoro per giorno.
  Map<DateTime, List<WorkEntry>> _groupEntriesByDay(List<WorkEntry> entries) {
    Map<DateTime, List<WorkEntry>> entriesGroupedByDay = {};
    for (var entry in entries) {
      final day = DateTime(entry.day.year, entry.day.month, entry.day.day);
      if (entriesGroupedByDay.containsKey(day)) {
        entriesGroupedByDay[day]!.add(entry);
      } else {
        entriesGroupedByDay[day] = [entry];
      }
    }
    return entriesGroupedByDay;
  }

  /// Gestore dell'evento `AddWorkEntry`.
  /// Aggiunge una nuova voce di lavoro tramite il repository e recupera nuovamente le voci di lavoro.
  Future<void> _onAddWorkEntry(
    AddWorkEntry event,
    Emitter<WorkEntriesState> emit,
  ) async {
    try {
      await _workEntriesRepository.insertWorkEntry(event.entry);
      add(FetchWorkEntries(
        startDate: event.entry.day,
        endDate: event.entry.day.add(const Duration(days: 1)),
      ));
    } catch (e) {
      logger.e('Errore durante l\'aggiunta di una nuova voce di lavoro',
          error: e);
      emit(WorkEntriesError(
          'Errore durante l\'operazione sulle voci di lavoro: ${e.toString()}. Si prega di verificare la connessione di rete e riprovare. Se il problema persiste, contattare l\'assistenza.'));
    }
  }

  /// Gestore dell'evento `UpdateWorkEntry`.
  /// Aggiorna una voce di lavoro esistente tramite il repository e recupera nuovamente le voci di lavoro.
  Future<void> _onUpdateWorkEntry(
    UpdateWorkEntry event,
    Emitter<WorkEntriesState> emit,
  ) async {
    try {
      await _workEntriesRepository.updateWorkEntry(event.entry);
      add(FetchWorkEntries(
        startDate: event.entry.day,
        endDate: event.entry.day.add(const Duration(days: 1)),
      ));
    } catch (e) {
      logger.e('Errore durante l\'aggiornamento di una voce di lavoro',
          error: e);
      emit(WorkEntriesError(
          'Errore durante l\'operazione sulle voci di lavoro: ${e.toString()}. Si prega di verificare la connessione di rete e riprovare. Se il problema persiste, contattare l\'assistenza.'));
    }
  }

  /// Gestore dell'evento `DeleteWorkEntry`.
  /// Elimina una voce di lavoro tramite il repository e recupera nuovamente le voci di lavoro.
  Future<void> _onDeleteWorkEntry(
    DeleteWorkEntry event,
    Emitter<WorkEntriesState> emit,
  ) async {
    try {
      await _workEntriesRepository.deleteWorkEntry(event.entryId);
      add(FetchWorkEntries(
        startDate: event.day,
        endDate: event.day.add(const Duration(days: 1)),
      ));
    } catch (e) {
      logger.e('Errore durante l\'eliminazione di una voce di lavoro',
          error: e);
      emit(WorkEntriesError(
          'Errore durante l\'operazione sulle voci di lavoro: ${e.toString()}. Si prega di verificare la connessione di rete e riprovare. Se il problema persiste, contattare l\'assistenza.'));
    }
  }

  /// Gestore dell'evento `DeleteAllWorkEntries`.
  /// Elimina tutte le voci di lavoro tramite il repository e recupera nuovamente le voci di lavoro.
  Future<void> _onDeleteAllWorkEntries(
    DeleteAllWorkEntries event,
    Emitter<WorkEntriesState> emit,
  ) async {
    try {
      await _workEntriesRepository.deleteAllWorkEntries();

      add(FetchWorkEntries(
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    } catch (e) {
      logger.e('Errore durante l\'eliminazione di tutte le voci di lavoro',
          error: e);
      emit(WorkEntriesError(
          'Errore durante l\'operazione sulle voci di lavoro: ${e.toString()}. Si prega di verificare la connessione di rete e riprovare. Se il problema persiste, contattare l\'assistenza.'));
    }
  }

  /// Gestore dell'evento `UpdateDateRange`.
  /// Emette lo stato `WorkEntriesDateRangeUpdated` con le nuove date di inizio e fine.
  Future<void> _onUpdateDateRange(
    UpdateDateRange event,
    Emitter<WorkEntriesState> emit,
  ) async {
    emit(WorkEntriesDateRangeUpdated(event.startDate, event.endDate));
  }
}

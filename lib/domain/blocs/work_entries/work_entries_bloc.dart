import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

part 'work_entries_event.dart';
part 'work_entries_state.dart';

/// La classe `WorkEntriesBloc` gestisce la logica di business e lo stato delle voci di lavoro.
///
/// Questo BLoC si occupa di caricare, aggiornare e resettare le voci di lavoro in base agli eventi ricevuti.
/// Fornisce stati appropriati per rappresentare il caricamento, il successo o l'errore durante le operazioni sulle voci di lavoro.
class WorkEntriesBloc extends Bloc<WorkEntriesEvent, WorkEntriesState> {
  /// Il repository delle voci di lavoro utilizzato per accedere ai dati.
  final WorkEntryRepository workEntryRepository;

  /// Costruttore della classe `WorkEntriesBloc`.
  ///
  /// Accetta un parametro [workEntryRepository] di tipo [WorkEntryRepository] per accedere ai dati delle voci di lavoro.
  /// Inizializza lo stato iniziale a [WorkEntriesInitial] e registra i gestori degli eventi utilizzando il metodo `on`.
  WorkEntriesBloc({required this.workEntryRepository})
      : super(WorkEntriesInitial()) {
    on<FetchWorkEntries>(_fetchWorkEntries);
    on<WorkEntriesUpdated>(_workEntriesUpdated);
    on<ResetDatabase>(_resetDatabase);
    on<DeleteWorkEntry>(_deleteWorkEntry);
  }

  /// Gestore dell'evento [FetchWorkEntries].
  ///
  /// Questo metodo viene chiamato quando viene ricevuto l'evento [FetchWorkEntries].
  /// Imposta lo stato [WorkEntriesLoading] durante il caricamento delle voci di lavoro.
  /// Recupera le voci di lavoro dall'intervallo di date specificato utilizzando il repository.
  /// In caso di successo, imposta lo stato [WorkEntriesLoaded] con le voci di lavoro caricate.
  /// In caso di errore, imposta lo stato [WorkEntriesError] con un messaggio di errore appropriato.
  _fetchWorkEntries(
      FetchWorkEntries event, Emitter<WorkEntriesState> emit) async {
    emit(WorkEntriesLoading());
    try {
      List<DateTime> days = getDaysInRange(event.startDate, event.endDate);
      var entries =
          await workEntryRepository.getWorkEntriesByDays(days, event.endDate);
      emit(WorkEntriesLoaded(entries));
    } catch (e) {
      emit(WorkEntriesError("Failed to load entries: ${e.toString()}"));
    }
  }

  List<DateTime> getDaysInRange(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  /// Gestore dell'evento [WorkEntriesUpdated].
  ///
  /// Questo metodo viene chiamato quando viene ricevuto l'evento [WorkEntriesUpdated].
  /// Imposta lo stato [WorkEntriesLoaded] con le voci di lavoro aggiornate.
  _workEntriesUpdated(
      WorkEntriesUpdated event, Emitter<WorkEntriesState> emit) {
    emit(WorkEntriesLoaded(event.updatedEntries.cast<DayWorkEntriesModel>()));
  }

  /// Gestore dell'evento [ResetDatabase].
  ///
  /// Questo metodo viene chiamato quando viene ricevuto l'evento [ResetDatabase].
  /// Imposta lo stato [WorkEntriesLoading] durante il reset del database.
  /// Resetta il database utilizzando il repository.
  /// In caso di successo, emette l'evento [FetchWorkEntries] per ricaricare le voci di lavoro e imposta lo stato [DatabaseResetSuccess].
  /// In caso di errore, imposta lo stato [WorkEntriesError] con un messaggio di errore appropriato.
  _resetDatabase(ResetDatabase event, Emitter<WorkEntriesState> emit) async {
    emit(WorkEntriesLoading());
    try {
      await workEntryRepository.resetDatabase();
      add(FetchWorkEntries(event.startDate, event.endDate));
      emit(DatabaseResetSuccess());
    } catch (e) {
      emit(WorkEntriesError("Failed to reset database: ${e.toString()}"));
    }
  }

  _deleteWorkEntry(
      DeleteWorkEntry event, Emitter<WorkEntriesState> emit) async {
    emit(WorkEntriesLoading());
    try {
      await workEntryRepository.deleteWorkEntryById(event.id);
      add(FetchWorkEntries(event.startDate, event.endDate));
      emit(WorkEntryDeleted());
    } catch (e) {
      emit(WorkEntriesError("Failed to delete entry: ${e.toString()}"));
    }
  }
}

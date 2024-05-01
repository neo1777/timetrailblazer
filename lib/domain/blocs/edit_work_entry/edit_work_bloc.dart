import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

part 'edit_work_event.dart';
part 'edit_work_state.dart';

/// La classe `EditWorkBloc` è un BLoC (Business Logic Component) che gestisce la logica di business
/// per la modifica di una voce di lavoro.
///
/// Questo BLoC risponde agli eventi di modifica della voce di lavoro, come il caricamento dei dati iniziali,
/// la modifica della data e dell'ora, e il salvataggio delle modifiche.
///
/// Gli stati emessi dal BLoC rappresentano lo stato corrente della modifica della voce di lavoro,
/// come lo stato di caricamento, lo stato con i dati modificati e lo stato di salvataggio completato.
class EditWorkBloc extends Bloc<EditWorkEvent, EditWorkState> {
  /// Il repository delle voci di lavoro utilizzato per accedere ai dati.
  final WorkEntryRepository workEntryRepository;

  /// Costruttore della classe `EditWorkBloc`.
  ///
  /// Accetta lo stato iniziale del BLoC e il repository delle voci di lavoro come parametri.
  ///
  /// Registra i gestori degli eventi utilizzando il metodo `on` di `Bloc`.
  EditWorkBloc(super.initialState, {required this.workEntryRepository}) {
    on<LoadWorkEntry>(_onLoadWorkEntry);
    on<UpdateDate>(_onUpdateDate);
    on<UpdateTime>(_onUpdateTime);
    on<SaveWorkEntry>(_onSaveWorkEntry);
  }

  /// Gestore dell'evento `LoadWorkEntry`.
  ///
  /// Quando viene ricevuto l'evento `LoadWorkEntry`, questo metodo carica la voce di lavoro
  /// corrispondente all'ID fornito utilizzando il `workEntryRepository`.
  ///
  /// Se la voce di lavoro viene trovata, emette lo stato `EditWorkDataChanged` con la voce di lavoro caricata
  /// e `isSaveEnabled` impostato su `false`.
  ///
  /// Se la voce di lavoro non viene trovata, emette lo stato `EditWorkError` con un messaggio di errore.
  ///
  /// In caso di errore durante il caricamento, emette lo stato `EditWorkError` con il messaggio di errore.
  void _onLoadWorkEntry(
      LoadWorkEntry event, Emitter<EditWorkState> emit) async {
    try {
      emit(EditWorkLoading());
      var entry = await workEntryRepository.getWorkEntryById(event.entryId);
      if (entry != null) {
        emit(EditWorkDataChanged(workEntry: entry, isSaveEnabled: false));
      } else {
        emit(EditWorkError(message: 'Entry not found'));
      }
    } catch (e) {
      emit(EditWorkError(message: e.toString()));
    }
  }

  /// Gestore dell'evento `DateChanged`.
  ///
  /// Quando viene ricevuto l'evento `DateChanged`, questo metodo aggiorna la data della voce di lavoro
  /// nello stato corrente `EditWorkDataChanged`.
  ///
  /// Crea una copia della voce di lavoro corrente con la data aggiornata e emette un nuovo stato
  /// `EditWorkDataChanged` con la voce di lavoro aggiornata e `isSaveEnabled` impostato su `true`.
  void _onUpdateDate(UpdateDate event, Emitter<EditWorkState> emit) {
    if (state is EditWorkDataChanged) {
      final currentState = state as EditWorkDataChanged;
      final updatedEntry = currentState.workEntry.copyWith(
        timestamp: DateTime(
          event.newDate.year,
          event.newDate.month,
          event.newDate.day,
          currentState.workEntry.timestamp.hour,
          currentState.workEntry.timestamp.minute,
        ),
      );
      emit(EditWorkDataChanged(workEntry: updatedEntry, isSaveEnabled: true));
    }
  }

  /// Gestore dell'evento `TimeChanged`.
  ///
  /// Quando viene ricevuto l'evento `TimeChanged`, questo metodo aggiorna l'ora della voce di lavoro
  /// nello stato corrente `EditWorkDataChanged`.
  ///
  /// Crea una copia della voce di lavoro corrente con l'ora aggiornata e emette un nuovo stato
  /// `EditWorkDataChanged` con la voce di lavoro aggiornata e `isSaveEnabled` impostato su `true`.
  void _onUpdateTime(UpdateTime event, Emitter<EditWorkState> emit) {
    if (state is EditWorkDataChanged) {
      final currentState = state as EditWorkDataChanged;
      final updatedEntry = currentState.workEntry.copyWith(
        timestamp: DateTime(
          currentState.workEntry.timestamp.year,
          currentState.workEntry.timestamp.month,
          currentState.workEntry.timestamp.day,
          event.newTime.hour,
          event.newTime.minute,
        ),
      );
      emit(EditWorkDataChanged(workEntry: updatedEntry, isSaveEnabled: true));
    }
  }

  /// Gestore dell'evento `SaveWorkEntry`.
  ///
  /// Quando viene ricevuto l'evento `SaveWorkEntry`, questo metodo salva la voce di lavoro modificata
  /// utilizzando il `workEntryRepository`.
  ///
  /// Emette lo stato `EditWorkLoading` durante il salvataggio.
  ///
  /// Se il salvataggio ha successo, emette lo stato `EditWorkSaved`.
  ///
  /// In caso di errore durante il salvataggio, emette lo stato `EditWorkError` con il messaggio di errore.
  void _onSaveWorkEntry(
      SaveWorkEntry event, Emitter<EditWorkState> emit) async {
    try {
      emit(EditWorkLoading());
      await workEntryRepository.saveWorkEntry(event.workEntry);
      emit(EditWorkSaved());
    } catch (e) {
      emit(EditWorkError(message: e.toString()));
    }
  }
}

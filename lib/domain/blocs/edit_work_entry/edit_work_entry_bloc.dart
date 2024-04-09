import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:timetrailblazer/domain/entities/work_entry.dart';
import 'package:timetrailblazer/utils/logger.dart';

part 'edit_work_entry_event.dart';
part 'edit_work_entry_state.dart';

/// Il `EditWorkEntryBloc` gestisce lo stato e gli eventi relativi alla modifica di una voce di lavoro.
class EditWorkEntryBloc extends Bloc<EditWorkEntryEvent, EditWorkEntryState> {
  /// Costruttore del `EditWorkEntryBloc` che accetta una `WorkEntry` iniziale.
  EditWorkEntryBloc(WorkEntry initialWorkEntry)
      : super(EditWorkEntryInitial(initialWorkEntry)) {
    // Gestisce l'evento `UpdateDate` per aggiornare la data della voce di lavoro.
    on<UpdateDate>(_onUpdateDate);
    // Gestisce l'evento `UpdateTime` per aggiornare l'ora della voce di lavoro.
    on<UpdateTime>(_onUpdateTime);
  }

  /// Gestore dell'evento `UpdateDate`.
  /// Aggiorna la data della voce di lavoro nello stato corrente.
  void _onUpdateDate(UpdateDate event, Emitter<EditWorkEntryState> emit) {
    try {
      final updatedWorkEntry = state.workEntry.copyWith(
        timestamp: DateTime(
          event.date.year,
          event.date.month,
          event.date.day,
          state.workEntry.timestamp.hour,
          state.workEntry.timestamp.minute,
        ),
      );
      emit(EditWorkEntryUpdated(updatedWorkEntry));
    } catch (e) {
      logger.e(
          'Errore durante l\'aggiornamento della data della voce di lavoro',
          error: e);
      emit(EditWorkEntryError(state.workEntry,
          'Errore durante l\'aggiornamento della data della voce di lavoro: ${e.toString()}. Si prega di verificare la data selezionata e riprovare.'));
    }
  }

  /// Gestore dell'evento `UpdateTime`.
  /// Aggiorna l'ora della voce di lavoro nello stato corrente.
  void _onUpdateTime(UpdateTime event, Emitter<EditWorkEntryState> emit) {
    try {
      final updatedWorkEntry = state.workEntry.copyWith(
        timestamp: DateTime(
          state.workEntry.timestamp.year,
          state.workEntry.timestamp.month,
          state.workEntry.timestamp.day,
          event.time.hour,
          event.time.minute,
        ),
      );
      emit(EditWorkEntryUpdated(updatedWorkEntry));
    } catch (e) {
      logger.e('Errore durante l\'aggiornamento dell\'ora della voce di lavoro',
          error: e);
      emit(EditWorkEntryError(state.workEntry,
          'Errore durante l\'aggiornamento dell\'ora della voce di lavoro: ${e.toString()}. Si prega di verificare l\'ora selezionata e riprovare.'));
    }
  }
}
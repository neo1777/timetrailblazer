import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

/// La classe base astratta per gli eventi del BLoC `EditWorkBloc`.
abstract class EditWorkEvent extends Equatable {
  const EditWorkEvent();

  @override
  List<Object?> get props => [];
}

/// L'evento che richiede il caricamento dei dati esistenti di una voce di lavoro.
class LoadWorkEntry extends EditWorkEvent {
  /// L'ID della voce di lavoro da caricare.
  final int entryId;

  const LoadWorkEntry({required this.entryId});

  @override
  List<Object?> get props => [entryId];
}

/// L'evento che indica la modifica della data di una voce di lavoro.
class UpdateDate extends EditWorkEvent {
  /// La nuova data selezionata.
  final DateTime newDate;

  const UpdateDate({required this.newDate});

  @override
  List<Object?> get props => [newDate];
}

/// L'evento che indica la modifica dell'ora di una voce di lavoro.
class UpdateTime extends EditWorkEvent {
  /// La nuova ora selezionata.
  final TimeOfDay newTime;

  const UpdateTime({required this.newTime});

  @override
  List<Object?> get props => [newTime];
}

/// L'evento che richiede il salvataggio delle modifiche a una voce di lavoro.
class SaveWorkEntry extends EditWorkEvent {
  /// La voce di lavoro modificata da salvare.
  final WorkEntryModel workEntry;

  const SaveWorkEntry({required this.workEntry});

  @override
  List<Object?> get props => [workEntry];
}

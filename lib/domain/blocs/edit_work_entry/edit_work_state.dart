import 'package:equatable/equatable.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

/// La classe base astratta per gli stati del BLoC `EditWorkBloc`.
abstract class EditWorkState extends Equatable {
  const EditWorkState();

  @override
  List<Object?> get props => [];
}

/// Lo stato iniziale del BLoC `EditWorkBloc`.
class EditWorkInitial extends EditWorkState {}

/// Lo stato che indica che è in corso il caricamento dei dati di una voce di lavoro.
class EditWorkLoading extends EditWorkState {}

/// Lo stato che rappresenta i dati modificati di una voce di lavoro.
class EditWorkDataChanged extends EditWorkState {
  /// La voce di lavoro modificata.
  final WorkEntryModel workEntry;

  /// Flag che indica se il pulsante di salvataggio deve essere abilitato.
  final bool isSaveEnabled;

  const EditWorkDataChanged(
      {required this.workEntry, this.isSaveEnabled = false});

  @override
  List<Object?> get props => [workEntry, isSaveEnabled];
}

/// Lo stato che indica che il salvataggio di una voce di lavoro è stato completato con successo.
class EditWorkSaved extends EditWorkState {}

/// Lo stato che rappresenta un errore durante la modifica di una voce di lavoro.
class EditWorkError extends EditWorkState {
  /// Il messaggio di errore.
  final String message;

  const EditWorkError({required this.message});

  @override
  List<Object?> get props => [message];
}

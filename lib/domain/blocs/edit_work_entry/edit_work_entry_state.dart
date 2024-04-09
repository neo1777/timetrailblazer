part of 'edit_work_entry_bloc.dart';

/// Classe astratta che rappresenta uno stato del `EditWorkEntryBloc`.
abstract class EditWorkEntryState extends Equatable {
  final WorkEntry workEntry;

  const EditWorkEntryState(this.workEntry);

  @override
  List<Object> get props => [workEntry];
}

/// Stato iniziale del `EditWorkEntryBloc`.
class EditWorkEntryInitial extends EditWorkEntryState {
  const EditWorkEntryInitial(super.workEntry);
}

/// Stato che rappresenta una voce di lavoro aggiornata.
class EditWorkEntryUpdated extends EditWorkEntryState {
  const EditWorkEntryUpdated(super.workEntry);
}

class EditWorkEntryError extends EditWorkEntryState {
  final String errorMessage;

  const EditWorkEntryError(super.workEntry, this.errorMessage);

  @override
  List<Object> get props => [workEntry, errorMessage];
}

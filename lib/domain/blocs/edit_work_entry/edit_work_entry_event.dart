part of 'edit_work_entry_bloc.dart';

/// Classe astratta che rappresenta un evento del `EditWorkEntryBloc`.
abstract class EditWorkEntryEvent extends Equatable {
  const EditWorkEntryEvent();
}

/// Evento per aggiornare la data della voce di lavoro.
class UpdateDate extends EditWorkEntryEvent {
  final DateTime date;

  const UpdateDate(this.date);

  @override
  List<Object> get props => [date];
}

/// Evento per aggiornare l'ora della voce di lavoro.
class UpdateTime extends EditWorkEntryEvent {
  final TimeOfDay time;

  const UpdateTime(this.time);

  @override
  List<Object> get props => [time];
}
part of 'edit_work_bloc.dart';

abstract class EditWorkEvent extends Equatable {
  const EditWorkEvent();

  @override
  List<Object> get props => [];
}
// Evento per caricare i dati esistenti dell'entry
class LoadWorkEntry extends EditWorkEvent {
  final int entryId;

  const LoadWorkEntry({required this.entryId});

  @override
  List<Object> get props => [entryId];
}
// Evento per modificare la data dell'entry
class UpdateDate extends EditWorkEvent {
  final DateTime newDate;

  const UpdateDate({required this.newDate});

  @override
  List<Object> get props => [newDate];
}

// Evento per modificare l'ora dell'entry
class UpdateTime extends EditWorkEvent {
  final TimeOfDay newTime;

  const UpdateTime({required this.newTime});

  @override
  List<Object> get props => [newTime];
}
// Evento per salvare le modifiche
class SaveWorkEntry extends EditWorkEvent {
  final WorkEntryModel workEntry;

  const SaveWorkEntry({required this.workEntry});

  @override
  List<Object> get props => [workEntry];
}
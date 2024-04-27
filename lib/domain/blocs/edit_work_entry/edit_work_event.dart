part of 'edit_work_bloc.dart';

abstract class EditWorkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento per caricare i dati esistenti dell'entry
class LoadWorkEntry extends EditWorkEvent {
  final int entryId;

  LoadWorkEntry({required this.entryId});

  @override
  List<Object> get props => [entryId];
}

// Evento per modificare la data dell'entry
class DateChanged extends EditWorkEvent {
  final DateTime newDate;

  DateChanged({required this.newDate});

  @override
  List<Object> get props => [newDate];
}

// Evento per modificare l'ora dell'entry
class TimeChanged extends EditWorkEvent {
  final DateTime newTime;

  TimeChanged({required this.newTime});

  @override
  List<Object> get props => [newTime];
}

// Evento per salvare le modifiche
class SaveWorkEntry extends EditWorkEvent {
  final WorkEntryModel workEntry;

  SaveWorkEntry({required this.workEntry});

  @override
  List<Object> get props => [workEntry];
}
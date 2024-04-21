part of 'work_entries_bloc.dart';

/// Rappresenta lo stato del BLoC `WorkEntriesBloc`.
abstract class WorkEntriesState extends Equatable {
  const WorkEntriesState();

  @override
  List<Object> get props => [];
}

/// Rappresenta lo stato iniziale del BLoC `WorkEntriesBloc`.
class WorkEntriesInitial extends WorkEntriesState {}

/// Rappresenta lo stato di caricamento delle voci di lavoro.
class WorkEntriesLoading extends WorkEntriesState {}

/// Rappresenta lo stato di caricamento completato delle voci di lavoro.
class WorkEntriesLoaded extends WorkEntriesState {
  /// La lista delle voci di lavoro raggruppate per giorno.
  final List<DayWorkEntriesModel> dayWorkEntriesList;
  final DateTime startDate;
  final DateTime endDate;
  const WorkEntriesLoaded({
    required this.startDate,
    required this.endDate,
    required this.dayWorkEntriesList,
  });

  @override
  List<Object> get props => [startDate, endDate, dayWorkEntriesList];
}

/// Rappresenta lo stato di errore durante il caricamento delle voci di lavoro.
class WorkEntriesError extends WorkEntriesState {
  /// Il messaggio di errore.
  final String message;

  const WorkEntriesError({required this.message});

  @override
  List<Object> get props => [message];
}

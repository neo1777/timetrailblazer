import 'package:equatable/equatable.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';

/// La classe base astratta per gli stati del BLoC `WorkEntriesBloc`.
abstract class WorkEntriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Lo stato iniziale del BLoC `WorkEntriesBloc`.
class WorkEntriesInitial extends WorkEntriesState {}

/// Lo stato che indica che le voci di lavoro sono in caricamento.
class WorkEntriesLoading extends WorkEntriesState {}

/// Lo stato che indica che le voci di lavoro sono state caricate con successo.
class WorkEntriesLoaded extends WorkEntriesState {
  /// La lista delle voci di lavoro caricate.
  final List<DayWorkEntriesModel> entries;

  WorkEntriesLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
}

/// Lo stato che indica un errore durante il caricamento delle voci di lavoro.
class WorkEntriesError extends WorkEntriesState {
  /// Il messaggio di errore.
  final String message;

  WorkEntriesError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Lo stato che indica che il reset del database è avvenuto con successo.
class DatabaseResetSuccess extends WorkEntriesState {}

/// Lo stato che indica che l'eliminazione di una voce di lavoro è avvenuta con successo.
class WorkEntryDeleted extends WorkEntriesState {}

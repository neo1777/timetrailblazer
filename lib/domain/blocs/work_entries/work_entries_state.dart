part of 'work_entries_bloc.dart';

abstract class WorkEntriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Stato iniziale, quando l'applicazione è appena avviata o in attesa di dati
class WorkEntriesInitial extends WorkEntriesState {}

// Stato durante il caricamento delle voci di lavoro
class WorkEntriesLoading extends WorkEntriesState {}

// Stato quando le voci di lavoro sono caricate e pronte per essere mostrate
class WorkEntriesLoaded extends WorkEntriesState {
  final List<DayWorkEntriesModel> entries;
  WorkEntriesLoaded(this.entries);
}

// Stato in caso di errore nel caricamento delle voci di lavoro
class WorkEntriesError extends WorkEntriesState {
  final String message;
  WorkEntriesError(this.message);
}

class DatabaseResetSuccess extends WorkEntriesState {}

class WorkEntryDeleted extends WorkEntriesState {}


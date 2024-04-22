import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

part 'home_event.dart';
part 'home_state.dart';

/// Il BLoC che gestisce lo stato della schermata principale.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// Il repository delle voci di lavoro.
  final WorkEntryRepository _workEntryRepository;

  /// Costruttore del BLoC.
  ///
  /// Inizializza lo stato iniziale del BLoC a `HomeInitial`.
  /// Riceve come dipendenza il [WorkEntryRepository] per interagire con il database.
  HomeBloc(this._workEntryRepository) : super(HomeInitial()) {
    /// Gestisce l'evento `EntryButtonPressed`.
    on<EntryButtonPressed>(_onEntryButtonPressed);

    /// Gestisce l'evento `ExitButtonPressed`.
    on<ExitButtonPressed>(_onExitButtonPressed);

    // Gestisci l'evento DatabaseReset
    on<DatabaseReset>(_onDatabaseReset);
  }

  /// Gestore dell'evento `EntryButtonPressed`.
  ///
  /// Quando viene premuto il pulsante di entrata:
  /// 1. Inserisce una nuova voce di lavoro di tipo "entrata" nel database.
  /// 2. Emette lo stato `HomeExitButtonEnabled` per abilitare il pulsante di uscita.
  Future<void> _onEntryButtonPressed(
      EntryButtonPressed event, Emitter<HomeState> emit) async {
    await _workEntryRepository.insertWorkEntry(
      WorkEntryModel(timestamp: DateTime.now(), isEntry: true),
    );

    emit(HomeExitButtonEnabled());
  }

  /// Gestore dell'evento `ExitButtonPressed`.
  ///
  /// Quando viene premuto il pulsante di uscita:
  /// 1. Inserisce una nuova voce di lavoro di tipo "uscita" nel database.
  /// 2. Emette lo stato `HomeEntryButtonEnabled` per abilitare il pulsante di entrata.
  Future<void> _onExitButtonPressed(
      ExitButtonPressed event, Emitter<HomeState> emit) async {
    await _workEntryRepository.insertWorkEntry(
      WorkEntryModel(timestamp: DateTime.now(), isEntry: false),
    );

    emit(HomeEntryButtonEnabled());
  }

  /// Gestore dell'evento `DatabaseReset`.
  ///
  /// Quando viene ricevuto l'evento di reset del database:
  /// 1. Emette lo stato `HomeInitial` per tornare allo stato iniziale della schermata principale.
  Future<void> _onDatabaseReset(
      DatabaseReset event, Emitter<HomeState> emit) async {
    emit(HomeInitial());
  }
}

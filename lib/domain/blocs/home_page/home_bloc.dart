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
  }

  /// Gestore dell'evento `EntryButtonPressed`.
  ///
  /// Quando viene premuto il pulsante di entrata:
  /// 1. Inserisce una nuova voce di lavoro di tipo "entrata" nel database.
  /// 2. Recupera l'ultima voce di lavoro dal database.
  /// 3. Emette lo stato `HomeExitButtonEnabled` se l'ultima voce è di tipo "entrata",
  ///    altrimenti emette lo stato `HomeEntryButtonEnabled`.
  Future<void> _onEntryButtonPressed(
      EntryButtonPressed event, Emitter<HomeState> emit) async {
    await _workEntryRepository.insertWorkEntry(
      WorkEntryModel(timestamp: DateTime.now(), isEntry: true),
    );

    final lastWorkEntry = await _workEntryRepository.getLastWorkEntry();
    if (lastWorkEntry != null && lastWorkEntry.isEntry!) {
      emit(HomeExitButtonEnabled());
    } else {
      emit(HomeEntryButtonEnabled());
    }
  }

  /// Gestore dell'evento `ExitButtonPressed`.
  ///
  /// Quando viene premuto il pulsante di uscita:
  /// 1. Inserisce una nuova voce di lavoro di tipo "uscita" nel database.
  /// 2. Recupera l'ultima voce di lavoro dal database.
  /// 3. Emette lo stato `HomeEntryButtonEnabled` se l'ultima voce è di tipo "uscita",
  ///    altrimenti emette lo stato `HomeExitButtonEnabled`.
  Future<void> _onExitButtonPressed(
      ExitButtonPressed event, Emitter<HomeState> emit) async {
    await _workEntryRepository.insertWorkEntry(
      WorkEntryModel(timestamp: DateTime.now(), isEntry: false),
    );

    final lastWorkEntry = await _workEntryRepository.getLastWorkEntry();
    if (lastWorkEntry != null && !lastWorkEntry.isEntry!) {
      emit(HomeEntryButtonEnabled());
    } else {
      emit(HomeExitButtonEnabled());
    }
  }
}

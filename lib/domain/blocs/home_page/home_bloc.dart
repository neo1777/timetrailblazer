import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

/// Il BLoC che gestisce lo stato della schermata principale.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// Costruttore del BLoC.
  ///
  /// Inizializza lo stato iniziale del BLoC a `HomePageInitial`.
  HomeBloc() : super(const HomePageInitial()) {
    /// Gestisce l'evento `EntryButtonPressed`.
    on<EntryButtonPressed>(_onEntryButtonPressed);

    /// Gestisce l'evento `ExitButtonPressed`.
    on<ExitButtonPressed>(_onExitButtonPressed);
  }

  /// Gestore dell'evento `EntryButtonPressed`.
  ///
  /// Quando viene premuto il pulsante di entrata, emette lo stato `HomePageExitButtonDisabled`.
  void _onEntryButtonPressed(
      EntryButtonPressed event, Emitter<HomeState> emit) {
    emit(const HomePageExitButtonDisabled());
  }

  /// Gestore dell'evento `ExitButtonPressed`.
  ///
  /// Quando viene premuto il pulsante di uscita, emette lo stato `HomePageEntryButtonDisabled`.
  void _onExitButtonPressed(ExitButtonPressed event, Emitter<HomeState> emit) {
    emit(const HomePageEntryButtonDisabled());
  }
}

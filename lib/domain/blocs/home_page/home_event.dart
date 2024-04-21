part of 'home_bloc.dart';

/// Rappresenta un evento del BLoC `HomeBloc`.
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// Rappresenta l'evento di pressione del pulsante di entrata.
class EntryButtonPressed extends HomeEvent {
}

/// Rappresenta l'evento di pressione del pulsante di uscita.
class ExitButtonPressed extends HomeEvent {
}

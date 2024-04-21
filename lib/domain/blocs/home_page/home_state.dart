part of 'home_bloc.dart';

/// Rappresenta lo stato del BLoC `HomeBloc`.
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

/// Rappresenta lo stato iniziale del BLoC `HomeBloc`.
class HomeInitial extends HomeState {}

/// Rappresenta lo stato in cui il pulsante di entrata è abilitato e il pulsante di uscita è disabilitato.
class HomeEntryButtonEnabled extends HomeState {
}

/// Rappresenta lo stato in cui il pulsante di uscita è abilitato e il pulsante di entrata è disabilitato.
class HomeExitButtonEnabled extends HomeState {}
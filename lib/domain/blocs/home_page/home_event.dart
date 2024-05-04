import 'package:equatable/equatable.dart';

/// La classe base astratta per gli eventi del BLoC `HomeBloc`.
abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// L'evento che indica l'avvio della schermata principale.
class HomeStarted extends HomeEvent {}

/// L'evento che indica che il pulsante di entrata è stato premuto.
class EntryButtonPressed extends HomeEvent {}

/// L'evento che indica che il pulsante di uscita è stato premuto.
class ExitButtonPressed extends HomeEvent {}

/// L'evento che indica che il database è stato resettato.
class DatabaseReset extends HomeEvent {}

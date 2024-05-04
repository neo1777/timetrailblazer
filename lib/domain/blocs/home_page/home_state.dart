import 'package:equatable/equatable.dart';

/// La classe base astratta per gli stati del BLoC `HomeBloc`.
abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Lo stato iniziale del BLoC `HomeBloc`.
class HomeInitial extends HomeState {}

/// Lo stato che indica che il pulsante di entrata è abilitato.
class HomeEntryButtonEnabled extends HomeState {}

/// Lo stato che indica che il pulsante di uscita è abilitato.
class HomeExitButtonEnabled extends HomeState {}

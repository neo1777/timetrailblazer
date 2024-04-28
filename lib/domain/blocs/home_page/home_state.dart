part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Stato iniziale, quando l'applicazione è appena avviata o in attesa di azioni
class HomeInitial extends HomeState {}

// Stato quando il pulsante di entrata è disabilitato (perché l'ultima voce è stata un'entrata)
class HomeEntryButtonEnabled extends HomeState {}

// Stato quando il pulsante di uscita è disabilitato (perché l'ultima voce è stata un'uscita)
class HomeExitButtonEnabled extends HomeState {}

part of 'home_bloc.dart';

/// Rappresenta lo stato del BLoC `HomeBloc`.
abstract class HomeState extends Equatable {
  /// Indica se il pulsante di entrata è abilitato.
  final bool isEntryButtonEnabled;

  /// Indica se il pulsante di uscita è abilitato.
  final bool isExitButtonEnabled;

  const HomeState({
    required this.isEntryButtonEnabled,
    required this.isExitButtonEnabled,
  });

  @override
  List<Object> get props => [isEntryButtonEnabled, isExitButtonEnabled];
}

/// Rappresenta lo stato iniziale del BLoC `HomeBloc`.
class HomePageInitial extends HomeState {
  const HomePageInitial()
      : super(
          isEntryButtonEnabled: true,
          isExitButtonEnabled: false,
        );
}

/// Rappresenta lo stato in cui il pulsante di entrata è disabilitato.
class HomePageEntryButtonDisabled extends HomeState {
  const HomePageEntryButtonDisabled()
      : super(
          isEntryButtonEnabled: false,
          isExitButtonEnabled: true,
        );
}

/// Rappresenta lo stato in cui il pulsante di uscita è disabilitato.
class HomePageExitButtonDisabled extends HomeState {
  const HomePageExitButtonDisabled()
      : super(
          isEntryButtonEnabled: true,
          isExitButtonEnabled: false,
        );
}

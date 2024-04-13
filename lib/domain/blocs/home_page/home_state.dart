part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final bool isEntryButtonEnabled;
  final bool isExitButtonEnabled;

  const HomeState({
    required this.isEntryButtonEnabled,
    required this.isExitButtonEnabled,
  });

  @override
  List<Object> get props => [isEntryButtonEnabled, isExitButtonEnabled];
}

class HomePageInitial extends HomeState {
  const HomePageInitial()
      : super(
          isEntryButtonEnabled: true,
          isExitButtonEnabled: false,
        );
}

class HomePageEntryButtonDisabled extends HomeState {
  const HomePageEntryButtonDisabled()
      : super(
          isEntryButtonEnabled: false,
          isExitButtonEnabled: true,
        );
}

class HomePageExitButtonDisabled extends HomeState {
  const HomePageExitButtonDisabled()
      : super(
          isEntryButtonEnabled: true,
          isExitButtonEnabled: false,
        );
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomePageInitial()) {
    on<EntryButtonPressed>(_onEntryButtonPressed);
    on<ExitButtonPressed>(_onExitButtonPressed);
  }

  void _onEntryButtonPressed(
      EntryButtonPressed event, Emitter<HomeState> emit) {
    emit(const HomePageExitButtonDisabled());
  }

  void _onExitButtonPressed(ExitButtonPressed event, Emitter<HomeState> emit) {
    emit(const HomePageEntryButtonDisabled());
  }
}

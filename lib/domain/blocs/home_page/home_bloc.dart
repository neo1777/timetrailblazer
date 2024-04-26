
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_event.dart';
import 'package:timetrailblazer/domain/blocs/home_page/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WorkEntryRepository workEntryRepository;

  HomeBloc({required this.workEntryRepository}) : super(HomeInitial()) {
    // on<HomeEvent>((event, emit) async {
    //   print('event: ${event.runtimeType}');
    //   if (event is EntryButtonPressed || event is ExitButtonPressed) {
    //     bool isEntry = event is EntryButtonPressed;
    //     var now = DateTime.now();
    //     await workEntryRepository.insertWorkEntry(WorkEntryModel(
    //         timestamp: now, // ora corrente come timestamp
    //         isEntry: isEntry));
    //     emit(await _updateButtonState());
    //   }
    // });
    on<HomeStarted>((event, emit) async {
      final lastEntry = await workEntryRepository.getLastWorkEntry();
      if (lastEntry == null) {
        emit(HomeEntryButtonEnabled());
      } else {
        emit(lastEntry.isEntry!
            ? HomeExitButtonEnabled()
            : HomeEntryButtonEnabled());
      }
    });

    // Ascoltatore per reagire ai cambiamenti nel database
    on<EntryButtonPressed>((event, emit) async {
      await workEntryRepository.insertWorkEntry(WorkEntryModel(
          timestamp: DateTime.now(), // ora corrente come timestamp
          isEntry: true)); // Assumi che true indichi un'entrata
      emit(HomeExitButtonEnabled());
    });

    on<ExitButtonPressed>((event, emit) async {
      await workEntryRepository.insertWorkEntry(WorkEntryModel(
          timestamp: DateTime.now(), // ora corrente come timestamp
          isEntry: false)); // Assumi che false indichi un'uscita
      emit(HomeEntryButtonEnabled());
    });
    on<DatabaseReset>((event, emit) async {
      //await workEntryRepository.resetDatabase();
      emit(HomeEntryButtonEnabled());
    });
  }

  // Future<HomeState> _updateButtonState() async {
  //   var lastEntry = await workEntryRepository.getLastWorkEntry();
  //   print('_updateButtonState: ${lastEntry?.isEntry}');
  //   return _getButtonStateBasedOnLastEntry(lastEntry!.isEntry);
  // }

  // HomeState _getButtonStateBasedOnLastEntry(bool? isEntry) {
  //   print('_getButtonStateBasedOnLastEntry: ${isEntry}');

  //   if (isEntry == true) {
  //     return HomeExitButtonEnabled();
  //   } else {
  //     return HomeEntryButtonEnabled();
  //   }
  // }
}

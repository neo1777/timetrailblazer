import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timetrailblazer/data/datasources/repositories/work_entry_repository.dart';
import 'package:timetrailblazer/data/models/day_work_entries_model.dart';
import 'package:timetrailblazer/data/models/work_entry_model.dart';

part 'work_entries_event.dart';
part 'work_entries_state.dart';

class WorkEntriesBloc extends Bloc<WorkEntriesEvent, WorkEntriesState> {
  final WorkEntryRepository workEntryRepository;

  WorkEntriesBloc({required this.workEntryRepository})
      : super(WorkEntriesInitial()) {
    on<FetchWorkEntries>((event, emit) async {
      emit(WorkEntriesLoading());
      try {
        List<DateTime> days = getDaysInRange(event.startDate, event.endDate);
        var entries =
            await workEntryRepository.getWorkEntriesByDays(days, event.endDate);
        emit(WorkEntriesLoaded(entries));
      } catch (e) {
        emit(WorkEntriesError("Failed to load entries: ${e.toString()}"));
      }
    });

    // Ascoltatore per reagire ai cambiamenti nel database
    on<WorkEntriesUpdated>((event, emit) {
      emit(WorkEntriesLoaded(event.updatedEntries.cast<DayWorkEntriesModel>()));
    });

    on<ResetDatabase>((event, emit) async {
      emit(WorkEntriesLoading());
      try {
        await workEntryRepository.resetDatabase();
        add(FetchWorkEntries(event.startDate, event.endDate));

        emit(DatabaseResetSuccess());
      } catch (e) {
        emit(WorkEntriesError("Failed to reset database: ${e.toString()}"));
      }
    });
  }

  List<DateTime> getDaysInRange(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }
}

import 'package:timetrailblazer/data/models/work_entry_model.dart';

class DayWorkEntriesModel {
  final DateTime day;
  final List<WorkEntryModel>? workEntries;

  DayWorkEntriesModel({required this.day, this.workEntries});
}
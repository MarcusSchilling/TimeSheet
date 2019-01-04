
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

class AppointmentModel {

  TimeSheetData oldTimeSheetData;
  TimeSheetData updatedOrNewTimeSheetData;
  Stopwatch stopwatch;

  AppointmentModel.of(Optional<TimeSheetData> timeSheet) {
    this.oldTimeSheetData = timeSheet.isPresent ? timeSheet.value : TimeSheetData.from(0, null, Optional.of(DateTime.now()), Optional<DateTime>.empty(), null);
    this.updatedOrNewTimeSheetData = timeSheet.isPresent
    ? TimeSheetData.from(timeSheet.value.timeDone, timeSheet.value.name, timeSheet.value.startDate, timeSheet.value.endDate, timeSheet.value.initialTime):
    TimeSheetData.from(0, null, Optional.of(DateTime.now()), Optional<DateTime>.empty(), null);
    stopwatch = Stopwatch();
  }

  TimeSheetData getTimeSheet() {
    return updatedOrNewTimeSheetData;
  }

  void updateTime(double time) {
    updatedOrNewTimeSheetData.initialTime = time;
  }

  void updateDate(DateTime dateTime) {
    updatedOrNewTimeSheetData.endDate = Optional.ofNullable(dateTime);
  }

  void updateName(String name) {
    updatedOrNewTimeSheetData.name = name;
  }

  bool hasName() => oldTimeSheetData.name != null;
  bool hasTime() => oldTimeSheetData.initialTime != null;
  bool hasEndDate() => oldTimeSheetData.endDate != null && oldTimeSheetData.endDate.isPresent;

  TimeSheetData getOldTimeSheet() {
    return oldTimeSheetData;
  }

}
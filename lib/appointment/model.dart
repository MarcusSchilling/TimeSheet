
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

class AppointmentModel {

  TimeSheetData timeSheetData;
  TimeSheetData updatedOrNewTimeSheetData;

  AppointmentModel.of(Optional<TimeSheetData> timeSheet) {
    this.timeSheetData = timeSheet.isPresent ? timeSheet.value : TimeSheetData.from(null, null, Optional.of(DateTime.now()), Optional<DateTime>.empty(), null);
    this.updatedOrNewTimeSheetData = timeSheet.isPresent
    ? TimeSheetData.from(timeSheet.value.remainingTime, timeSheet.value.name, timeSheet.value.startDate, timeSheet.value.endDate, timeSheet.value.initialTime):
    TimeSheetData.from(null, null, Optional.of(DateTime.now()), Optional<DateTime>.empty(), null);
  }

  TimeSheetData getTimeSheet() {
    return updatedOrNewTimeSheetData;
  }

  void updateTime(double time) {
    updatedOrNewTimeSheetData.remainingTime = time;
    updatedOrNewTimeSheetData.initialTime = time;
  }

  void updateDate(DateTime dateTime) {
    updatedOrNewTimeSheetData.endDate = Optional.ofNullable(dateTime);
  }

  void updateName(String name) {
    updatedOrNewTimeSheetData.name = name;
  }

  bool hasName() => timeSheetData.name != null;
  bool hasTime() => timeSheetData.remainingTime != null;
  bool hasEndDate() => timeSheetData.endDate != null && timeSheetData.endDate.isPresent;

  TimeSheetData getOldTimeSheet() {
    return timeSheetData;
  }

}

import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

class AppointmentModel {

  TimeSheetData timeSheetData;

  AppointmentModel.of(Optional<TimeSheetData> timeSheet) {
    this.timeSheetData = timeSheet.isPresent ? timeSheet.value : TimeSheetData.from(null, null, null);
  }

  TimeSheetData getTimeSheet() {
    return timeSheetData;
  }

  void updateTime(double time) {
    timeSheetData.time = time;
  }

  void updateDate(DateTime dateTime) {
    timeSheetData.date = Optional.of(dateTime);
  }

  void updateName(String name) {
    timeSheetData.name = name;
  }

  bool hasName() => timeSheetData.name != null;
  bool hasTime() => timeSheetData.time != null;
  bool hasDate() => timeSheetData.date != null && timeSheetData.date.isPresent;

}
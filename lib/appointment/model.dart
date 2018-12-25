
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

class AppointmentModel {

  TimeSheetData timeSheetData;

  AppointmentModel.of(Optional<TimeSheetData> timeSheet) {
    this.timeSheetData = timeSheet.isPresent ? timeSheet.value : TimeSheetData.from(null, null, Optional.of(DateTime.now()), Optional<DateTime>.empty(), null);
  }

  TimeSheetData getTimeSheet() {
    return timeSheetData;
  }

  void updateTime(double time) {
    timeSheetData.time = time;
    timeSheetData.initialTime = time;
  }

  void updateDate(DateTime dateTime) {
    timeSheetData.endDate = Optional.ofNullable(dateTime);
  }

  void updateName(String name) {
    timeSheetData.name = name;
  }

  bool hasName() => timeSheetData.name != null;
  bool hasTime() => timeSheetData.time != null;
  bool hasEndDate() => timeSheetData.endDate != null && timeSheetData.endDate.isPresent;

}
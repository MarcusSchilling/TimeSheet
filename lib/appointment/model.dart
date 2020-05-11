
import 'package:flutter_app/timesheet.dart';
import 'package:optional/optional_internal.dart';
import 'package:flutter_app/stopwatch.dart';

class AppointmentModel {

  TimeSheetData oldTimeSheetData;
  TimeSheetData updatedOrNewTimeSheetData;
  Stopwatch stopwatch;

  AppointmentModel.of(Optional<TimeSheetData> timeSheet) {
    this.oldTimeSheetData = timeSheet.isPresent ? timeSheet.value : TimeSheetData.from(0, null, Optional.of(DateTime.now()), Optional<DateTime>.empty(), null, Optional.empty(), Optional.empty());
    this.updatedOrNewTimeSheetData = timeSheet.isPresent
    ? TimeSheetData.from(timeSheet.value.timeDone, timeSheet.value.name, timeSheet.value.startDate, timeSheet.value.endDate, timeSheet.value.initialTime, timeSheet.value.grade, timeSheet.value.ects):
    TimeSheetData.from(0, null, Optional.of(DateTime.now()), Optional<DateTime>.empty(), null, Optional.empty(), Optional.empty());
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

  void updateGrade(double grade) {
    updatedOrNewTimeSheetData.grade = Optional.of(grade);
  }

  void updateECTS(double ects) {
    updatedOrNewTimeSheetData.ects = Optional.of(ects);
  }

  bool hasName() => oldTimeSheetData.name != null;
  bool hasTime() => oldTimeSheetData.initialTime != null;
  bool hasEndDate() => oldTimeSheetData.endDate != null && oldTimeSheetData.endDate.isPresent;

  TimeSheetData getOldTimeSheet() {
    return oldTimeSheetData;
  }

  bool timerIsRunning() {
    return stopwatch.isRunning;
  }

  void decrementWithStopwatch() {
    updatedOrNewTimeSheetData.decrement(duration: stopwatch.getStoppedTime());
  }

  bool hasGrade() => oldTimeSheetData.grade.isPresent;

  bool hasECTS() => oldTimeSheetData.ects.isPresent;

}
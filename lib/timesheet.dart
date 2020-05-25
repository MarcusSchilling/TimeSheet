import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/critical.dart';
import 'package:flutter_app/grade.dart';
import 'package:optional/optional_internal.dart';

class TimeSheetData extends Comparable<TimeSheetData>{

  double timeDone;
  String name;
  double initialTime;
  Optional<DateTime> startDate;
  Optional<DateTime> endDate;
  Optional<double> grade;
  Optional<double> ects;
  CriticalTimeSpan criticalTimeSpan = const CriticalTimeSpan(Duration(days: 7), Duration(hours: 25));

  static const double stepsTimeDone = 0.25;

  // defines how much time you can be in delay and still being seen as in time.
  static const Duration acceptedTimeBuffer = Duration(hours: 3);

  TimeSheetData.from(this.timeDone, this.name, this.startDate, this.endDate, this.initialTime, this.grade, this.ects);


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TimeSheetData &&
              timeDone == other.timeDone &&
              name == other.name &&
              startDate == other.startDate;


  @override
  int get hashCode =>
      timeDone.hashCode ^
      name.hashCode ^
      startDate.hashCode;

  bool hasStartDate() {
    return startDate.isPresent;
  }

  bool hasEndDate() {
    return endDate.isPresent;
  }

  bool timePassed({DateTime currentTime}) {
    return endDate.isPresent && endDate.value.compareTo(currentTime) < 0;
  }

  /// calculates the color of the progress made by the user
  /// the criticalTime default is 7 days. For the time before of the last 7 days
  /// the user must accomplish 50% of the initialTime after that he must accomplish
  /// a linear curve from the start to end date and equal distribution of the
  /// initial time over the
  /// returns: Colors.red for being out of plan otherwise Colors.green
  Color progressColor({DateTime currentTime}) {
    assert (hasEndDate());
    if (currentTime.compareTo(endDate.value) > 0) {
      return Colors.black;
    }
    var timeTargetToToday = targetTimeToDate(currentTime);
    if (timeTargetToToday > timeDone) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  double targetTimeToDate(DateTime currentTime) {
    Duration daysToWork = endDate.value
        .difference(startDate.value);
    Duration daysTowardsCriticalTimePoint = daysToWork - criticalTimeSpan.timeSpan;
    Duration daysGone =
        currentTime
        .difference(startDate.value);
    var criticalTimeReached = daysToWork <= daysGone + criticalTimeSpan.timeSpan;
    double timeTargetToToday;
    if (daysToWork < daysGone) {
      timeTargetToToday = initialTime;
    } else if (criticalTimeReached){
      var percentageFromCriticalToEndPassed = ((daysToWork.inMilliseconds - daysGone.inMilliseconds) / criticalTimeSpan.timeSpan.inMilliseconds);
      timeTargetToToday = initialTime - criticalTimeSpan.timeToDo.inHours + criticalTimeSpan.timeToDo.inHours * (1.0 - percentageFromCriticalToEndPassed);
    } else {
      timeTargetToToday = min(1, daysGone.inMilliseconds / daysTowardsCriticalTimePoint.inMilliseconds) * max(0, initialTime - criticalTimeSpan.timeToDo.inHours);
    }
    return timeTargetToToday;
  }

  String get formattedGrade => grade.value.toString();

  String get formattedECTS => ects.value.toString();

  String get formattedTimeDone => ((timeDone * 100).round() / 100).toString();

  double get remainingTime => initialTime - timeDone;

  String get formattedDate =>
      endDate.isPresent?"${endDate.value.year.toString()}-"
          "${endDate.value.month.toString().padLeft(2, '0')}-"
          "${endDate.value.day.toString().padLeft(2, '0')}" : "";

  String get initialTimeFormatted => ((initialTime * 100).round() / 100).toString();

  @override
  String toString() {
    return initialTimeFormatted + "\n" + name + "\n" + formattedDate + '\n';
  }

  String title (DateTime currentTime) {
    return name + ": " + timeDone.toString() + (hasEndDate() ? "/ " +
        ((targetTimeToDate(currentTime) * 100).round() / 100).toString() : "");
  }

  bool isValid() {
    return timeDone != null && initialTime != null && name != null && startDate != null;
  }

  void decrement({Duration duration}) {
    assert (duration == null || !duration.isNegative);
    if (duration != null) {
      this.timeDone += duration.inSeconds / (60.0*60.0);
    } else {
      this.timeDone += stepsTimeDone;
    }
  }

  @override
  int compareTo(TimeSheetData other) {
    return this.endDate.orElseGet(() => DateTime(0))
        .compareTo(other.endDate.orElseGet(() => DateTime(0)));
  }
}

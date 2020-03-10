import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
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

  static const double stepsTimeDone = 0.25;

  // defines how much time you can be in delay and still being seen as in time.
  static const Duration acceptedTimeBuffer = Duration(hours: 3);

  TimeSheetData.from(this.timeDone, this.name, this.startDate, this.endDate, this.initialTime, this.grade, this.ects);

  get timePassed => endDate.isPresent && endDate.value.compareTo(DateTime.now()) < 0;

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

  /// calculates the color of the progress made by the user
  /// the criticalTime default is 7 days. For the time before of the last 7 days
  /// the user must accomplish 50% of the initialTime after that he must accomplish
  /// a linear curve from the start to end date and equal distribution of the
  /// initial time over the
  /// returns: Colors.red for being out of plan otherwise Colors.green
  Color progress({Duration criticalTime = const Duration(days: 7)}) {
    assert (hasEndDate());
    int daysToWork = endDate.value
        .difference(startDate.value)
        .inDays;
    int daysGone = DateTime
        .now()
        .difference(startDate.value)
        .inDays;
    double percentageGone = daysGone / daysToWork;
    var timeTargetToToday;
    if (DateTime.now().compareTo(endDate.value) > 0) {
      return Colors.black;
    }
    if (daysToWork - daysGone <= criticalTime.inDays) {
      timeTargetToToday = percentageGone * initialTime;
    } else {
      timeTargetToToday = (daysGone / (daysToWork - criticalTime.inDays)) * (initialTime / 2);
    }
    if (timeTargetToToday > timeDone) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  String get formattedGrade => grade.value.toString();

  String get formattedECTS => ects.value.toString();

  String get formattedTimeDone => ((timeDone * 100).round() / 100).toString();

  String get title => name + ": " + initialTimeFormatted + " done: " + formattedTimeDone;

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

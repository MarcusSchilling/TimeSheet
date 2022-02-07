import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/critical.dart';
import 'package:optional/optional_internal.dart';

class TimeSheetData extends Comparable<TimeSheetData> {
  double timeDone;
  String name;
  double timeTarget;
  Optional<DateTime> startDate;
  Optional<DateTime> endDate;
  Optional<double> grade;
  Optional<double> ects;
  CriticalTimeSpan criticalTimeSpan =
      const CriticalTimeSpan(Duration(days: 7), Duration(hours: 25));

  static const double stepsTimeDone = 0.25;

  // defines how much time you can be in delay and still being seen as in time.
  static const Duration acceptedTimeBuffer = Duration(hours: 3);

  TimeSheetData.from(this.timeDone, this.name, this.startDate, this.endDate,
      this.timeTarget, this.grade, this.ects);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSheetData &&
          timeDone == other.timeDone &&
          name == other.name &&
          startDate == other.startDate;

  @override
  int get hashCode => timeDone.hashCode ^ name.hashCode ^ startDate.hashCode;

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
    assert(hasEndDate());
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
    Duration daysToWork = endDate.value.difference(startDate.value);
    Duration startTimeToCriticalTimeZone =
        daysToWork - criticalTimeSpan.timeSpan;
    Duration daysGone = currentTime.difference(startDate.value);
    var criticalTimeReached =
        daysToWork <= daysGone + criticalTimeSpan.timeSpan;
    double timeTargetToToday;
    if (daysToWork < daysGone) {
      timeTargetToToday = timeTarget;
    } else if (criticalTimeReached) {
      var sundaysUntilFinalDay = 0;
      for (DateTime i = currentTime;
          0 < endDate.value.compareTo(i);
          i = i.add(Duration(days: 1))) {
        if (i.weekday == DateTime.sunday) {
          sundaysUntilFinalDay++;
        }
      }
      var daysUntilEndDate = endDate.value.difference(currentTime).inDays;
      var productiveDaysRemaining = max(
          1,
          daysUntilEndDate -
              sundaysUntilFinalDay); // - 1 because I wouldn't study on the exam date

      if (timeTarget < criticalTimeSpan.timeToDo.inHours) {
        return ((timeTarget) / productiveDaysRemaining);
      }
      var totalTimeForWork = endDate.value.difference(startDate.value);
      var criticalProductiveTimeSpanForItem =
          totalTimeForWork.compareTo(criticalTimeSpan.timeSpan) < 0
              ? totalTimeForWork.inDays - sundaysUntilFinalDay
              : criticalTimeSpan.timeSpan.inDays - sundaysUntilFinalDay;
      return ((criticalTimeSpan.timeToDo.inHours) /
                  (criticalProductiveTimeSpanForItem)) *
              ((criticalProductiveTimeSpanForItem) - productiveDaysRemaining) +
          (timeTarget - criticalTimeSpan.timeToDo.inHours);
    } else {
      timeTargetToToday = min(
              1,
              daysGone.inMilliseconds /
                  startTimeToCriticalTimeZone.inMilliseconds) *
          max(0, timeTarget - criticalTimeSpan.timeToDo.inHours);
    }
    return timeTargetToToday;
  }

  String get formattedGrade {
    if (!grade.isPresent) {
      return "";
    }
    return grade.value.toString();
  }

  String get formattedECTS {
    if (!ects.isPresent) {
      return "";
    }
    return ects.value.toString();
  }

  String get formattedTimeDone => ((timeDone * 100).round() / 100).toString();

  double get remainingTime => timeTarget - timeDone;

  String get formattedDate => endDate.isPresent
      ? "${endDate.value.year.toString()}-"
          "${endDate.value.month.toString().padLeft(2, '0')}-"
          "${endDate.value.day.toString().padLeft(2, '0')}"
      : "";

  String get initialTimeFormatted =>
      ((timeTarget * 100).round() / 100).toString();

  @override
  String toString() {
    return initialTimeFormatted + "\n" + name + "\n" + formattedDate + '\n';
  }

  String title(DateTime currentTime) {
    return name +
        ": " +
        timeDone.toString() +
        (hasEndDate()
            ? "/ " +
                ((targetTimeToDate(currentTime) * 100).round() / 100).toString()
            : "");
  }

  bool isValid() {
    return timeDone != null &&
        timeTarget != null &&
        name != null &&
        startDate != null;
  }

  void decrement({Duration duration}) {
    assert(duration == null || !duration.isNegative);
    if (duration != null) {
      this.timeDone += duration.inSeconds / (60.0 * 60.0);
    } else {
      this.timeDone += stepsTimeDone;
    }
  }

  @override
  int compareTo(TimeSheetData other) {
    return this
        .endDate
        .orElseGet(() => DateTime(0))
        .compareTo(other.endDate.orElseGet(() => DateTime(0)));
  }
}

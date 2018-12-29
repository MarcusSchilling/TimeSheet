import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:optional/optional_internal.dart';

class TimeSheetData extends Comparable<TimeSheetData>{
  double remainingTime;
  String name;
  double initialTime;
  Optional<DateTime> startDate;
  Optional<DateTime> endDate;

  // defines how much time you can be in delay and still being seen as in time.
  static const Duration acceptedTimeBuffer = Duration(hours: 3);

  TimeSheetData.from(this.remainingTime, this.name, this.startDate, this.endDate, this.initialTime);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TimeSheetData &&
              remainingTime == other.remainingTime &&
              name == other.name &&
              startDate == other.startDate;



  @override
  int get hashCode =>
      remainingTime.hashCode ^
      name.hashCode ^
      startDate.hashCode;

  bool hasDate() {
    return startDate.isPresent;
  }

  Color progress() {
    int daysToWork = endDate.value.difference(startDate.value).inDays;
    int daysGone = DateTime.now().difference(startDate.value).inDays;
    double percentageGone = daysGone / daysToWork;
    var timeTargetToToday = percentageGone * initialTime;
    if (timeTargetToToday - acceptedTimeBuffer.inHours > timeDone) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  double get timeDone => initialTime - remainingTime;

  String get title => name + ": " + timeFormatted + " done: " + done;

  String get done => ((((initialTime-remainingTime) / initialTime) * 100).roundToDouble()).toString() + " %";

  String get formattedDate =>
      endDate.isPresent?"${endDate.value.year.toString()}-"
          "${endDate.value.month.toString().padLeft(2, '0')}-"
          "${endDate.value.day.toString().padLeft(2, '0')}" : "";

  String get timeFormatted => ((remainingTime * 100).round() / 100).toString();

  @override
  String toString() {
    return timeFormatted + "\n" + name + "\n" + formattedDate + '\n';
  }

  bool isValid() {
    return remainingTime != null && name != null && startDate != null;
  }

  void decrement(double value) {
    this.remainingTime -= value;
  }

  @override
  int compareTo(TimeSheetData other) {
    return this.endDate.orElseGet(() => DateTime(0))
        .compareTo(other.endDate.orElseGet(() => DateTime(0)));
  }

  bool hasEndDate() {
    return endDate.isPresent;
  }
}

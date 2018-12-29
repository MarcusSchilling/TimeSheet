import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:optional/optional_internal.dart';

class TimeSheetData extends Comparable<TimeSheetData>{

  double timeDone;
  String name;
  double initialTime;
  Optional<DateTime> startDate;
  Optional<DateTime> endDate;

  // defines how much time you can be in delay and still being seen as in time.
  static const Duration acceptedTimeBuffer = Duration(hours: 3);

  TimeSheetData.from(this.timeDone, this.name, this.startDate, this.endDate, this.initialTime);

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

  String get title => name + ": " + initialTimeFormatted + " done: " + timeDone.toString();

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

  void decrement(double value) {
    this.timeDone += value;
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

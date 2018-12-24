import 'package:optional/optional_internal.dart';

class TimeSheetData extends Comparable<TimeSheetData>{
  double time;
  String name;
  Optional<DateTime> startDate;
  Optional<DateTime> endDate;

  TimeSheetData(String input) {
    var atoms = input.split("\n");
    var dateParts = atoms.elementAt(2).split("-");
    startDate = Optional.ofNullable(DateTime(int.parse(dateParts.elementAt(0)), int.parse(dateParts.elementAt(1)), int.parse(dateParts.elementAt(2))));
    time = double.parse(atoms.elementAt(0));
    name = atoms.elementAt(1);
  }

  TimeSheetData.from(this.time, this.name, this.startDate, this.endDate);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TimeSheetData &&
              time == other.time &&
              name == other.name &&
              startDate == other.startDate;



  @override
  int get hashCode =>
      time.hashCode ^
      name.hashCode ^
      startDate.hashCode;

  bool hasDate() {
    return startDate.isPresent;
  }

  String get title => name + ": " + ((time * 100).round() / 100).toString();

  String get formattedDate =>
      startDate.isPresent?"${startDate.value.year.toString()}-"
          "${startDate.value.month.toString().padLeft(2, '0')}-"
          "${startDate.value.day.toString().padLeft(2, '0')}" : "";

  String get timeFormatted => ((time * 100).round() / 100).toString();

  @override
  String toString() {
    return timeFormatted + "\n" + name + "\n" + formattedDate + '\n';
  }

  bool isValid() {
    return time != null && name != null && startDate != null;
  }

  void decrement(double value) {
    this.time -= value;
  }

  @override
  int compareTo(TimeSheetData other) {
    return this.startDate.orElseGet(() => DateTime(0))
        .compareTo(other.startDate.orElseGet(() => DateTime(0)));
  }
}

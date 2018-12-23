import 'package:optional/optional_internal.dart';

class TimeSheetData {
  double time;
  String name;
  Optional<DateTime> date;

  TimeSheetData(String input) {
    var atoms = input.split("\n");
    var dateParts = atoms.elementAt(2).split("-");
    date = Optional.ofNullable(DateTime(int.parse(dateParts.elementAt(0)), int.parse(dateParts.elementAt(1)), int.parse(dateParts.elementAt(2))));
    time = double.parse(atoms.elementAt(0));
    name = atoms.elementAt(1);
  }

  TimeSheetData.from(this.time, this.name, this.date);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TimeSheetData &&
              runtimeType == other.runtimeType &&
              time == other.time &&
              name == other.name &&
              date == other.date;

  @override
  int get hashCode =>
      time.hashCode ^
      name.hashCode ^
      date.hashCode;

  bool hasDate() {
    return date.isPresent;
  }

  String get title => name + ": " + ((time * 100).round() / 100).toString();

  String get formattedDate =>
      date.isPresent?"${date.value.year.toString()}-"
          "${date.value.month.toString().padLeft(2, '0')}-"
          "${date.value.day.toString().padLeft(2, '0')}" : "";

  String get timeFormatted => ((time * 100).round() / 100).toString();

  @override
  String toString() {
    return timeFormatted + "\n" + name + "\n" + formattedDate + '\n';
  }

  bool isValid() {
    return time != null && name != null && date != null;
  }

  void decrement(double value) {
    this.time += value;
  }
}

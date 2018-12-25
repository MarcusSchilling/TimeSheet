import 'package:flutter_app/timesheet_data.dart';
import "package:test/test.dart";
import 'package:optional/optional.dart';


void main() {
  var secondTimeSheet = TimeSheetData.from(12, "hallo", Optional.of(DateTime(2019, 2, 6)),Optional.of(DateTime(2019,3,6)), 12);
  var timeSheetData = TimeSheetData.from(50, "WASA", Optional.of(DateTime.utc(2019,2,6,14,30,0,0,0)), Optional.of(DateTime(2019,12,12,14,23,0,0,0)),50);
}

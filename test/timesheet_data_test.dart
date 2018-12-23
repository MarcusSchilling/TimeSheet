import 'package:flutter_app/timesheet_data.dart';
import "package:test/test.dart";
import 'package:optional/optional.dart';


void main() {
  var secondTimeSheet = TimeSheetData.from(12, "hallo", Optional.of(DateTime(2019, 2, 6)), null);
  var timeSheetData = TimeSheetData.from(50, "WASA", Optional.of(DateTime.utc(2019,2,6,14,30,0,0,0)),null);
  group("TimeSheetData toString() und from String",
    (){
  test("first", () {
  expect(TimeSheetData("12\nhallo\n2019-02-06"), secondTimeSheet);
  });
  test("second", () {
  expect(TimeSheetData("134\nhallo\n2232-12-06"), TimeSheetData.from(134, "hallo", Optional.ofNullable(DateTime(2232, 12, 6)), null));
  });
  });
}

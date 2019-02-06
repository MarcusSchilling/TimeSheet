import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional.dart';
import 'package:test_api/test_api.dart';


void main() {
  var secondTimeSheet = TimeSheetData.from(12, "hallo", Optional.of(DateTime(2019, 2, 6)),Optional.of(DateTime(2019,3,6)), 12);
  var timeSheetData = TimeSheetData.from(50, "WASA", Optional.of(DateTime.utc(2019,2,6,14,30,0,0,0)), Optional.of(DateTime(2019,12,12,14,23,0,0,0)),50);
  var timeSheetWithoutEndDate = TimeSheetData.from(50, "Never passed", Optional.of(DateTime.now()), Optional.empty(), 100);
  var timeSheetDone = TimeSheetData.from(50, "Never passed", Optional.of(DateTime.now().add(Duration(days: -2))), Optional.of(DateTime.now().add(Duration(days: -1))), 100);
  var timeSheetNotDone = TimeSheetData.from(50, "Never passed", Optional.of(DateTime.now().add(Duration(days: -2))), Optional.of(DateTime.now().add(Duration(days: 10))), 100);


  test('timesheet time passed', () {
    expect(timeSheetWithoutEndDate.timePassed, false);
    expect(timeSheetDone.timePassed, true);
    expect(timeSheetNotDone.timePassed, false);
  });
}

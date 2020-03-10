import 'package:flutter_app/timesheet.dart';
import 'package:optional/optional.dart';
import 'package:test_api/test_api.dart';


void main() {
  var secondTimeSheet = TimeSheetData.from(12, "hallo", Optional.of(DateTime(2019, 2, 6)),Optional.of(DateTime(2019,3,6)), 12,null,null);
  var timeSheetData = TimeSheetData.from(50, "WASA", Optional.of(DateTime.utc(2019,2,6,14,30,0,0,0)), Optional.of(DateTime(2019,12,12,14,23,0,0,0)),50,null, null);
  var timeSheetWithoutEndDate = TimeSheetData.from(50, "Never passed", Optional.of(DateTime.now()), Optional.empty(), 100, null, null);
  var timeSheetDone = TimeSheetData.from(50, "Never passed", Optional.of(DateTime.now().add(Duration(days: -2))), Optional.of(DateTime.now().add(Duration(days: -1))), 100, null, null);
  var timeSheetNotDone = TimeSheetData.from(50, "Never passed", Optional.of(DateTime.now().add(Duration(days: -2))), Optional.of(DateTime.now().add(Duration(days: 10))), 100, null, null);


  test('timesheet time passed', () {
    expect(timeSheetWithoutEndDate.timePassed, false);
    expect(timeSheetDone.timePassed, true);
    expect(timeSheetNotDone.timePassed, false);
  });
}

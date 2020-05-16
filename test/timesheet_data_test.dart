import 'package:flutter/material.dart';
import 'package:flutter_app/timesheet.dart';
import 'package:test/test.dart';
import 'package:optional/optional.dart';


void main() {
  var secondTimeSheet = TimeSheetData.from(12, "hallo", Optional.of(DateTime(2019, 2, 6)),Optional.of(DateTime(2019,3,6)), 12,null,null);
  var timeSheetData = TimeSheetData.from(50, "WASA", Optional.of(DateTime.utc(2019,2,6,14,30,0,0,0)), Optional.of(DateTime(2019,12,12,14,23,0,0,0)),50,null, null);
  var timeSheetWithoutEndDate = TimeSheetData.from(50, "Never passed", Optional.of(DateTime.now()), Optional.empty(), 100, null, null);
  var timeSheetDone = TimeSheetData.from(50, "Never passed", Optional.of(DateTime.now().add(Duration(days: -2))), Optional.of(DateTime.now().add(Duration(days: -1))), 100, null, null);
  var timeSheetNotDone = TimeSheetData.from(50, "Never passed", Optional.of(DateTime.now().add(Duration(days: -2))), Optional.of(DateTime.now().add(Duration(days: 10))), 100, null, null);
  var timeSheetReachedCriticalTime = TimeSheetData.from(50, "Never passed", Optional.of(DateTime(2017, 9, 7, 17, 30)), Optional.of(DateTime(2017, 9, 7, 17, 30).add(Duration(days: 10))), 100, null, null);


  test('timesheet time passed', () {

    expect(timeSheetWithoutEndDate.timePassed(currentTime: DateTime.now()), false);
    expect(timeSheetDone.timePassed(currentTime: DateTime.now()), true);
    expect(timeSheetNotDone.timePassed(currentTime: DateTime.now()), false);
  });
  
  test('timesheet current target time', () {
    var startDateTime = DateTime(2017, 9, 7, 17, 30);
    var uncriticalDateTime1 = DateTime(2017, 9, 8, 17, 30);
    var uncriticalDateTime2 = DateTime(2017, 9, 9, 17, 30);
    var criticalDateTime = DateTime(2017, 9, 10, 17, 30);
    var endDateTime = DateTime(2017, 9, 7, 17, 30).add(Duration(days: 10));
    expect(timeSheetReachedCriticalTime.targetTimeToDate(startDateTime), 0);
    expect(timeSheetReachedCriticalTime.targetTimeToDate(uncriticalDateTime1), timeSheetReachedCriticalTime.criticalTimeSpan.timeToDo.inHours);
    expect(timeSheetReachedCriticalTime.targetTimeToDate(uncriticalDateTime2), timeSheetReachedCriticalTime.criticalTimeSpan.timeToDo.inHours * 2);
    //test that on critical time returns targetTime - criticalTimeSpan.timeToDo.inHours
    expect(timeSheetReachedCriticalTime.targetTimeToDate(criticalDateTime), timeSheetReachedCriticalTime.initialTime - timeSheetReachedCriticalTime.criticalTimeSpan.timeToDo.inHours);
    var halfTimeOfCritical = timeSheetReachedCriticalTime.criticalTimeSpan.percentageOfTimeToDo(0.5);
    var matcher = timeSheetReachedCriticalTime.initialTime - timeSheetReachedCriticalTime.criticalTimeSpan.percentageOfTimeToDo(0.5).inHours;
    expect(timeSheetReachedCriticalTime.targetTimeToDate(criticalDateTime.add(Duration(hours: 84))), 87.5);
    expect(timeSheetReachedCriticalTime.targetTimeToDate(endDateTime), 100);
  });
}

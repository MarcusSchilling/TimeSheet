import 'package:flutter_app/critical.dart';
import 'package:flutter_app/timesheet.dart';
import 'package:test/test.dart';
import 'package:optional/optional.dart';

void main() {
  CriticalTimeSpan criticalTimeSpan = CriticalTimeSpan(Duration(days: 7), Duration(hours: 25));
  test('Critical Time get correct values', (){
    expect(criticalTimeSpan.timeToDo, Duration(hours: 25));
    expect(criticalTimeSpan.timeSpan, Duration(days: 7));
  });
  test('Critical Time calculate percentage of time todo', (){
    expect(criticalTimeSpan.percentageOfTimeToDo(0.5), Duration(minutes: 750));
  });
  test('Critical Time calculate percentage of time span', (){
    expect(criticalTimeSpan.percentageOfTimeSpan(0.5), Duration(hours: 84));
  });
}
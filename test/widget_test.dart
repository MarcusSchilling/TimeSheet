// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_app/data_service.dart';
import 'package:flutter_app/data_service_impl.dart';
import 'package:flutter_app/overview/overview.dart';
import 'package:flutter_app/overview/overview_controller.dart';
import 'package:flutter_app/overview/overview_model.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    OverviewModel overviewModel = OverviewModel(null);
    OverviewController overviewController = OverviewController(MockDataService());
    await tester.pumpWidget(overviewController.view);

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

class MockDataService implements DataService {

  List<TimeSheetData> timeSheets;

  @override
  Future<bool> exists(TimeSheetData timeSheet) async {
    return timeSheets.contains(timeSheet);
  }

  @override
  Future<List<TimeSheetData>> getTimeSheetData() async {
    return timeSheets;
  }

  @override
  Future<void> remove(TimeSheetData toDelete) async {
    return timeSheets.remove(toDelete);
  }

  @override
  Future<void> store(TimeSheetData timeSheet) async{
    exists(timeSheet).then((exist) {
      if (exist) {
        this.timeSheets.add(timeSheet);
      } else {
        throw new AssertionError("You cannot store an time sheet that exists you have to update such a timesheet");
      }
    });
    timeSheets.add(timeSheet);
  }

  @override
  Future<void> replace(TimeSheetData timeSheet, TimeSheetData oldTimeSheet) async {
    timeSheets.remove(oldTimeSheet);
    timeSheets.add(timeSheet);
  }

  @override
  Future<void> update(TimeSheetData timeSheet) async{
    exists(timeSheet).then((exist) {
      if (exist) {
        var timeSheetWhichShouldBeUpdated = this.timeSheets.firstWhere((e) => timeSheet.name == e.name);
        timeSheetWhichShouldBeUpdated.name = timeSheet.name;
        timeSheetWhichShouldBeUpdated.endDate = timeSheet.endDate;
        timeSheetWhichShouldBeUpdated.startDate = timeSheet.startDate;
        timeSheetWhichShouldBeUpdated.endDate = timeSheet.endDate;
        timeSheetWhichShouldBeUpdated.initialTime = timeSheet.initialTime;
        timeSheetWhichShouldBeUpdated.remainingTime = timeSheet.remainingTime;
      } else {
        throw new AssertionError("You cannot update a time sheet that doesn't exist");
      }
    });
  }

}
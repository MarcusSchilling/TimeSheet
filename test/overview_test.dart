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
import 'package:optional/optional_internal.dart';


void main() {

  testWidgets('widget is showed correct', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    var mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        Optional.of(DateTime.now()),
        Optional.of(DateTime.now().add(Duration(days: 10))),
        40);
    mockDataService.store(timeSheetData);
    OverviewController overviewController = OverviewController(mockDataService);
    await tester.pumpWidget(overviewController.view);

    expect(find.text(timeSheetData.title), findsOneWidget);
    expect(find.text(timeSheetData.title + " sodale"), findsNothing);

    expect(find.text(timeSheetData.formattedDate), findsOneWidget);


    // Tap the '+' icon and trigger a frame.
    //await tester.tap(find.byIcon(Icons.add));
    //await tester.pump();

  });

  testWidgets('test increment time done', (WidgetTester tester) async {
    var mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        Optional.of(DateTime.now()),
        Optional.of(DateTime.now().add(Duration(days: 10))),
        40);
    mockDataService.store(timeSheetData);
    OverviewController overviewController = OverviewController(mockDataService);
    await tester.pumpWidget(overviewController.view);

    var oldTitle = timeSheetData.title;

    //tap time done
    await tester.tap(find.byKey(Key("increment_button")));
    await tester.pump();

    expect(find.text(oldTitle), findsNothing);
    expect(find.text(timeSheetData.title), findsOneWidget);
  });

  testWidgets('test finished', (WidgetTester tester) async {
    var mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        Optional.of(DateTime.now()),
        Optional.of(DateTime.now().add(Duration(days: 10))),
        TimeSheetData.stepsTimeDone);
    mockDataService.store(timeSheetData);
    OverviewController overviewController = OverviewController(mockDataService);
    await tester.pumpWidget(overviewController.view);
    //tap time done

    var oldTitle = timeSheetData.title;

    await tester.tap(find.byKey(Key("increment_button")));
    await tester.pump();

    expect(find.text(timeSheetData.title), findsOneWidget);
    expect(find.text(oldTitle), findsNothing);
    expect(find.byKey(Key("increment_button")), findsNothing);

  });
}

class MockDataService implements DataService {

  List<TimeSheetData> timeSheets = List();

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
      if (!exist) {
        this.timeSheets.add(timeSheet);
      } else {
        throw new AssertionError("You cannot store an time sheet that exists you have to update such a timesheet");
      }
    });
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
        timeSheetWhichShouldBeUpdated.endDate = timeSheet.endDate;
        timeSheetWhichShouldBeUpdated.startDate = timeSheet.startDate;
        timeSheetWhichShouldBeUpdated.endDate = timeSheet.endDate;
        timeSheetWhichShouldBeUpdated.initialTime = timeSheet.initialTime;
        timeSheetWhichShouldBeUpdated.timeDone = timeSheet.timeDone;
      } else {
        throw new AssertionError("You cannot update a time sheet that doesn't exist");
      }
    });
  }

}
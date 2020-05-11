// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_app/appointment/appointment_controller.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/services/data_service.dart';
import 'package:flutter_app/services/data_service_impl.dart';
import 'package:flutter_app/overview/overview.dart';
import 'package:flutter_app/overview/overview_controller.dart';
import 'package:flutter_app/overview/overview_model.dart';
import 'package:flutter_app/timesheet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optional/optional_internal.dart';

import 'mock_extensions/MockDataService.dart';

void main() {

  var timeNow = Optional.of(DateTime.now());
  var endTime = Optional.of(DateTime.now().add(Duration(days: 10)));
  var timeDone = Optional.of(DateTime.now().add(Duration(days: -10)));
  testWidgets('widget is showed correct', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    MockDataService mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        timeNow,
        endTime,
        40, Optional.empty(), Optional.empty());
    await mockDataService.store(timeSheetData);
    OverviewController overviewController = OverviewController(mockDataService);
    await tester.pumpWidget(overviewController.view);
    expect(find.byKey(Constants.listElementKey), findsOneWidget);

    expect(find.text(timeSheetData.title), findsOneWidget);
    expect(find.text(timeSheetData.title + " sodale"), findsNothing);



    // Tap the '+' icon and trigger a frame.
    //await tester.tap(find.byIcon(Icons.add));
    //await tester.pump();

  });

  testWidgets('test increment time done', (WidgetTester tester) async {
    MockDataService mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        timeNow,
        endTime,
        40, Optional.empty(), Optional.empty());
    await mockDataService.store(timeSheetData);
    OverviewController overviewController = OverviewController(mockDataService);
    await tester.pumpWidget(overviewController.view);

    var oldTitle = timeSheetData.title;

    //tap time done
    await tester.tap(find.byKey(Constants.incrementButtonKey));
    await tester.pump();

    expect(find.text(oldTitle), findsNothing);
    expect(find.text(timeSheetData.title), findsOneWidget);

    TimeSheetData expected = TimeSheetData.from(
        TimeSheetData.stepsTimeDone,
        "WASA",
        timeNow,
        endTime,
        40,
        null,
        null);
    var result = mockDataService.timeSheets.first;
    expect(result, expected);
  });

  testWidgets('test finished appointment doesnt appears after end date time passed', (WidgetTester tester) async {
    MockDataService mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        Optional.of(DateTime.now().add(Duration(days: -12))),
        Optional.of(DateTime.now().add(Duration(days: -10))),
        TimeSheetData.stepsTimeDone,
        null, null);
    mockDataService.store(timeSheetData);
    OverviewController overviewController = OverviewController(mockDataService);
    await tester.pumpWidget(overviewController.view);
    //tap time done

    expect(find.text(timeSheetData.title), findsNothing);
    expect(find.byKey(Constants.incrementButtonKey), findsNothing);
    List list = List();
    list.add(timeSheetData);
    expect(mockDataService.timeSheets, list);
  });

  testWidgets('test move to other activity after clicking button which creates new Appointment', (WidgetTester tester) async {
    MockDataService mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        timeNow,
        endTime,
        TimeSheetData.stepsTimeDone, null, null);
    mockDataService.store(timeSheetData);
    AppointmentController appointmentController;
    OverviewController overviewController = OverviewController(mockDataService, moveToDetailView: (timeSheet) {
      appointmentController = AppointmentController(timeSheet, mockDataService);
    });
    await tester.pumpWidget(overviewController.view);
    //tap time done

    expect(find.text(timeSheetData.title), findsOneWidget);
    expect(find.text(timeSheetData.title + " sodale"), findsNothing);

    expect(find.text(timeSheetData.formattedDate), findsOneWidget);
    expect(find.byKey(Constants.overviewScaffoldKey), findsOneWidget);

    await tester.tap(find.byKey(Constants.newAppointmentButtonKey));
    await tester.pumpWidget(appointmentController.view);
    expect(find.text(timeSheetData.title), findsNothing);
    expect(find.byKey(Constants.overviewScaffoldKey), findsNothing);
    expect(find.byKey(Constants.appointmentScaffoldKey), findsOneWidget);
    expect(mockDataService.timeSheets.elementAt(0), timeSheetData);
  });

  testWidgets('test move to other activity after clicking timesheet', (WidgetTester tester) async {
    MockDataService mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        timeNow,
        endTime,
        TimeSheetData.stepsTimeDone, Optional.empty(), Optional.empty());
    mockDataService.store(timeSheetData);
    AppointmentController appointmentController;
    OverviewController overviewController = OverviewController(mockDataService, moveToDetailView: (timeSheet) {
      appointmentController = AppointmentController(timeSheet, mockDataService);
    });
    await tester.pumpWidget(overviewController.view);

    //tap time done
    expect(find.text(timeSheetData.title), findsOneWidget);
    expect(find.text(timeSheetData.title + " sodale"), findsNothing);

    expect(find.text(timeSheetData.formattedDate), findsOneWidget);
    expect(find.byKey(Constants.overviewScaffoldKey), findsOneWidget);

    await tester.tap(find.byKey(Constants.listElementKey));
    await tester.pumpWidget(appointmentController.view);
    expect(find.text(timeSheetData.title), findsNothing);
    expect(find.byKey(Constants.overviewScaffoldKey), findsNothing);
    expect(find.byKey(Constants.appointmentScaffoldKey), findsOneWidget);
    expect(mockDataService.timeSheets.elementAt(0), timeSheetData);
  });

  testWidgets('test correct text color of activity', (WidgetTester tester) async {
    MockDataService mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        Optional.of(DateTime.now().add(Duration(days: -10))),
        endTime,
        100, Optional.empty(), Optional.empty());
    mockDataService.store(timeSheetData);
    OverviewController overviewController = OverviewController(mockDataService);
    await tester.pumpWidget(overviewController.view);
  });

  testWidgets('test without enddate', (WidgetTester tester) async {
    MockDataService mockDataService = MockDataService();
    var timeSheetData = TimeSheetData.from(0, "WASA",
        Optional.of(DateTime.now().add(Duration(days: -10))),
        Optional<DateTime>.empty(),
        100, Optional.empty(), Optional.empty());
    mockDataService.store(timeSheetData);
    OverviewController overviewController = OverviewController(mockDataService);
    await tester.pumpWidget(overviewController.view);
  });
  //TODO test coloring of list items

}


import 'package:flutter/material.dart';
import 'package:flutter_app/appointment/appointment_controller.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/services/data_service.dart';
import 'package:flutter_app/overview/overview_controller.dart';
import 'package:flutter_app/timesheet.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optional/optional_internal.dart';

import 'mock_extensions/MockDataService.dart';
import 'dart:io';

void main() {

  var timeNow = Optional.of(DateTime.now());
  var endTime = Optional.of(DateTime.now().add(Duration(days: 10)));


  testWidgets('new item without date', (WidgetTester tester) async {
    DataService dataService = MockDataService();
    AppointmentController emptyAppointmentController
    = AppointmentController(Optional<TimeSheetData>.empty(), dataService);

    await tester.pumpWidget(emptyAppointmentController.view);
    await tester.enterText(find.byKey(Constants.timeTFKey), '230');
    await tester.enterText(find.byKey(Constants.nameTFKey), 'Hallo');
    await tester.tap(find.byKey(Constants.saveButtonKey));

    List<TimeSheetData> timeSheetData = await dataService.getTimeSheetData();
    var target = timeSheetData.elementAt(0);
    expect(target.name, 'Hallo');
    expect(target.timeDone, 0);
    expect(target.initialTime, 230);
    expect(target.startDate.value.difference(DateTime.now()).inMinutes < 3, isTrue);
    expect(target.endDate, Optional<DateTime>.empty());
  });


  testWidgets('update item without date', (WidgetTester tester) async {

    DataService dataService = MockDataService();
    var timeSheetToUpdate = TimeSheetData.from(0,
        "Hallo",
        Optional.of(DateTime.now()),
        Optional<DateTime>.empty(), 100);
    await dataService.store(timeSheetToUpdate);
    OverviewController overviewController;
    AppointmentController emptyAppointmentController
    = AppointmentController(Optional.of(timeSheetToUpdate), dataService, 
    moveToOverview: (dataService) => overviewController = OverviewController(dataService)
    );

    await tester.pumpWidget(emptyAppointmentController.view);
    await tester.enterText(find.byKey(Constants.timeTFKey), '230');
    await tester.tap(find.byKey(Constants.saveButtonKey));


    List<TimeSheetData> timeSheetData = await dataService.getTimeSheetData();
    var target = timeSheetData.elementAt(0);
    expect(target.name, 'Hallo');
    expect(target.timeDone, 0);
    expect(target.initialTime, 230);
    expect(target.startDate.value.difference(DateTime.now()).inMinutes < 3, isTrue);
    expect(target.endDate, Optional<DateTime>.empty());
  });

  testWidgets('use stopwatch', (WidgetTester tester) async {
    DataService dataService = MockDataService();
    var timeSheetToUpdate = TimeSheetData.from(0,
        "Hallo",
        Optional.of(DateTime.now()),
        Optional<DateTime>.empty(), 100);
    await dataService.store(timeSheetToUpdate);
    OverviewController overviewController;
    AppointmentController emptyAppointmentController
    = AppointmentController(Optional.of(timeSheetToUpdate), dataService, moveToOverview: (timeSheet) {
        overviewController = OverviewController(dataService);
    });
    await tester.pumpWidget(emptyAppointmentController.view);


    await tester.tap(find.byKey(Constants.startStopWatch));
    sleep(Duration(minutes: 1, seconds: 10));
    await tester.tap(find.byKey(Constants.startStopWatch));
    await tester.tap(find.byKey(Constants.saveButtonKey));
    //await tester.pumpWidget(overviewController.view);
    List<TimeSheetData> timeSheets = await dataService.getTimeSheetData();
    expect(timeSheets.elementAt(0).timeDone > 0.0, true);

  });

}
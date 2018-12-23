
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/appointment/appointment_controller.dart';
import 'package:flutter_app/data_service.dart';
import 'package:flutter_app/overview/overview.dart';
import 'package:flutter_app/overview/overview_model.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';
void main() => OverviewController();

class OverviewController {

  OverviewModel model;
  Overview view;
  DataService dataService;

  OverviewController () {
    dataService = DataService();
    model = OverviewModel(dataService.getTimeSheetData());
    view = Overview(model, () {
      if(model.selectedTimeSheet.isPresent) {
        changeTimeSheet(model.selectedTimeSheet.value);
      } else {
        newTimeSheetData();
      }
    }, (TimeSheetData timeSheet) {
      timeSheet.decrement(-0.25);
      dataService.update(timeSheet);
      model.update();
      return;
    });
    runApp(view);
  }

  void changeTimeSheet (TimeSheetData timeSheet) {
    AppointmentController controller = AppointmentController(Optional.of(timeSheet));
    runApp(controller.view);
  }

  void newTimeSheetData() {
    AppointmentController controller = AppointmentController(Optional.empty());
    runApp(controller.view);
  }

}

abstract class ChangeTimeSheet{
  void changeTimeSheet();
}
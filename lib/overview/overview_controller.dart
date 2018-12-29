import 'package:flutter/cupertino.dart';
import 'package:flutter_app/appointment/appointment_controller.dart';
import 'package:flutter_app/data_service.dart';
import 'package:flutter_app/data_service_impl.dart';
import 'package:flutter_app/overview/overview.dart';
import 'package:flutter_app/overview/overview_model.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

void main() {
  OverviewController(DataServiceImpl());
}

class OverviewController {

  OverviewModel model;
  Overview view;
  DataService dataService;

  OverviewController(DataService dataService) {
    this.dataService = dataService;
    var loadedTimeSheets = this.dataService.getTimeSheetData();
    model = OverviewModel();
    view = Overview(model,
      performClickOnTimeSheet: (TimeSheetData timeSheet) {
        timeSheet.decrement();
        this.dataService.update(timeSheet);
        model.updateAll();
        return;
      },
      changeTimeSheet: () {
        if (model.selectedTimeSheet.isPresent) {
          changeTimeSheet(model.selectedTimeSheet.value);
        } else {
          newTimeSheetData();
        }
      },
    );
    runApp(view);
    model.setTimeSheets(loadedTimeSheets);
  }

  void changeTimeSheet(TimeSheetData timeSheet) {
    AppointmentController controller = AppointmentController(
        Optional.of(timeSheet));
    runApp(controller.view);
  }

  void newTimeSheetData() {
    AppointmentController controller = AppointmentController(Optional.empty());
    runApp(controller.view);
  }

}

abstract class ChangeTimeSheet {
  void changeTimeSheet();
}
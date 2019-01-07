import 'package:flutter/cupertino.dart';
import 'package:flutter_app/appointment/appointment_controller.dart';
import 'package:flutter_app/data_service.dart';
import 'package:flutter_app/data_service_impl.dart';
import 'package:flutter_app/overview/overview.dart';
import 'package:flutter_app/overview/overview_model.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

void main() {
  var overviewController = OverviewController(DataServiceImpl());
  runApp(overviewController.view);
}
typedef void MoveToDetailView(Optional<TimeSheetData> timeSheet);

class OverviewController {

  OverviewModel model;
  Overview view;
  DataService dataService;
  MoveToDetailView moveToDetailView;

  OverviewController(DataService dataService, {MoveToDetailView moveToDetailView}) {
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
        var timeSheet = model.selectedTimeSheet;
        this.moveToDetailView(timeSheet);
      },
    );
    runApp(view);
    model.setTimeSheets(loadedTimeSheets);
    this.moveToDetailView = moveToDetailView != null ? moveToDetailView : (timeSheet) {
      AppointmentController controller = AppointmentController(timeSheet, dataService);
      runApp(controller.view);
    };
  }

}

abstract class ChangeTimeSheet {
  void changeTimeSheet();
}
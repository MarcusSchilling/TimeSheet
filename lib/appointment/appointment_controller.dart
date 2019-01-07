import 'package:flutter/cupertino.dart';
import 'package:flutter_app/appointment/model.dart';
import 'package:flutter_app/appointment/view.dart';
import 'package:flutter_app/services/data_service.dart';
import 'package:flutter_app/services/data_service_impl.dart';
import 'package:flutter_app/overview/overview_controller.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';
import 'package:flutter_app/stopwatch.dart';

typedef void MoveToOverview(DataService dataService);

class AppointmentController {

  AppointmentView view;
  AppointmentModel model;
  DataService dataService;
  MoveToOverview moveToOverview;

  AppointmentController(Optional<TimeSheetData> timeSheet, DataService dataService, {MoveToOverview moveToOverview}) {
    this.moveToOverview = moveToOverview == null ? (dataService) {
      var overviewController = OverviewController(dataService);
      runApp(overviewController.view);
    } : moveToOverview;
    model = AppointmentModel.of(timeSheet);
    view = AppointmentView(timeSheet.isPresent ? update : save,
        model,
        exit,
        delete,
        stopWatchAction,
        resetAction
    );
    this.dataService = dataService;
    runApp(view);
  }

  void stopWatchAction() {
    if (model.stopwatch.isRunning) {
      model.stopwatch.stop();
    } else {
      model.stopwatch.start();
    }
  }

  void resetAction() {
    model.stopwatch.reset();
  }

  Future<bool> exit() async {
    moveToOverview(dataService);
  }

  void save() {
    if (model.getTimeSheet().isValid()) {
      model.decrementWithStopwatch();
      dataService.store(model.getTimeSheet());
      moveToOverview(dataService);
    } else {
      view.error("The Input is not valid");
    }
  }

  void delete() {
    dataService.exists(model.getTimeSheet()).then((exists) {
      if (exists) {
        view.checkIfUserIsSure("Do you realy want to delete the TimeSheet?")
        .then((sure) {
          if (sure) {
            dataService.remove(model.getTimeSheet()).then((v) => exit());
          }
        });
      } else {
        view.error("There is no TimeSheet stored with the given values");
      }
    });
  }

  void update() {
    if (model.getTimeSheet().isValid()) {
      model.decrementWithStopwatch();
      dataService.replace(model.getTimeSheet(), model.getOldTimeSheet())
      .then((v) => moveToOverview(dataService));
    } else {
      view.error("This input cannot be updated. It is not Valid.");
    }
  }

}
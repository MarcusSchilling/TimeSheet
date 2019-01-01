import 'package:flutter_app/appointment/model.dart';
import 'package:flutter_app/appointment/view.dart';
import 'package:flutter_app/data_service.dart';
import 'package:flutter_app/data_service_impl.dart';
import 'package:flutter_app/overview/overview_controller.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

class AppointmentController {

  AppointmentView view;
  AppointmentModel model;
  DataService dataService;

  AppointmentController(Optional<TimeSheetData> timeSheet, DataService dataService) {
    model = AppointmentModel.of(timeSheet);
    view = AppointmentView(timeSheet.isPresent ? update : save,
        model,
        exit,
        delete
    );
    this.dataService = dataService;
  }

  Future<bool> exit() async {
    OverviewController(dataService);
  }

  void save() {
    if (model.getTimeSheet().isValid()) {
      dataService.store(model.getTimeSheet());
      OverviewController(dataService);
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
      dataService.replace(model.getOldTimeSheet(), model.getTimeSheet())
      .then((v) => OverviewController(dataService));
    } else {
      view.error("This input cannot be updated. It is not Valid.");
    }
  }

}
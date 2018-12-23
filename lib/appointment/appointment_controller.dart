

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/appointment/model.dart';
import 'package:flutter_app/appointment/view.dart';
import 'package:flutter_app/data_service.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

class AppointmentController{

  AppointmentView view;
  AppointmentModel model;
  DataService dataService;

  AppointmentController(Optional<TimeSheetData> timeSheet) {
    List<ValueChanged<dynamic>> list = List();
    model = AppointmentModel.of(timeSheet);
    view = AppointmentView(list, timeSheet.isPresent ? update : save, model);
    dataService = DataService();
  }

  void save() {
    if (model.getTimeSheet().isValid()) {
      dataService.store(model.getTimeSheet());
      runApp(MyApp());
    } else {
      view.error("The Input is not valid");
    }
  }

  void update() {
    if (model.getTimeSheet().isValid()) {
      dataService.update(model.getTimeSheet());
      runApp(MyApp());
    } else {
      view.error("This input cannot be updated. It is not Valid.");
    }
  }

}
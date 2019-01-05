

import 'package:flutter_app/data_service_impl.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

class OverviewModel {
  List<TimeSheetData> timeSheets = List();
  var updateView;
  Optional<TimeSheetData> selectedTimeSheet;

  OverviewModel() {
    selectedTimeSheet = Optional.empty();
  }

  void setTimeSheets(Future<List<TimeSheetData>> timeSheets) {
    timeSheets
        .then((loadedTimeSheets){
      this.timeSheets = loadedTimeSheets;
      updateAll();
    });
  }

  void register(void updateView(List<TimeSheetData> timeSheetData)) {
    this.updateView = updateView;
  }

  void updateAll() {
    timeSheets.sort();
    if (updateView != null) {
      updateView(timeSheets);
    } else {
      //throw new Exception("There is no OverviewModel update method registered");
    }
  }

  void selectTimeSheet(Optional<TimeSheetData> optionalSelectedTimeSheet) {
    this.selectedTimeSheet = optionalSelectedTimeSheet;
  }


  void delete(TimeSheetData toDelete) {
      timeSheets
        .removeWhere((timeSheet) => timeSheet == toDelete);
  }

}


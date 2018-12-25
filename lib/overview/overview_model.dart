

import 'package:flutter_app/data_service_impl.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';

class OverviewModel {
  List<TimeSheetData> timeSheets;
  var updateView;
  Optional<TimeSheetData> selectedTimeSheet;

  OverviewModel(Future<List<TimeSheetData>> timeSheets) {
    timeSheets
        .then((loadedTimeSheets){
          this.timeSheets = loadedTimeSheets;
          updateAll(loadedTimeSheets);
        });
    selectedTimeSheet = Optional.empty();
  }

  void register(void updateView(List<TimeSheetData> timeSheetData)) {
    this.updateView = updateView;
  }

  void updateAll(List<TimeSheetData> timeSheet) {
    timeSheet.sort();
    updateView(timeSheet);
  }

  void selectTimeSheet(Optional<TimeSheetData> optionalSelectedTimeSheet) {
    this.selectedTimeSheet = optionalSelectedTimeSheet;
  }

  void update() {
    updateAll(timeSheets);
  }

  void delete(TimeSheetData toDelete) {
    timeSheets
        .removeWhere((timeSheet) => timeSheet == toDelete);
  }

}


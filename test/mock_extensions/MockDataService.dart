import 'package:flutter_app/services/data_service.dart';
import 'package:flutter_app/timesheet.dart';

class MockDataService implements DataService {

  List<TimeSheetData> timeSheets = List();

  @override
  Future<bool> exists(TimeSheetData timeSheet) async {
    return timeSheets.contains(timeSheet);
  }

  @override
  Future<List<TimeSheetData>> getTimeSheetData() async {
    return timeSheets;
  }

  @override
  Future<void> remove(TimeSheetData toDelete) async {
    return timeSheets.remove(toDelete);
  }

  @override
  Future<void> store(TimeSheetData timeSheet) async{
    exists(timeSheet).then((exist) {
      if (!exist) {
        this.timeSheets.add(timeSheet);
      } else {
        throw new AssertionError("You cannot store an time sheet that exists you have to update such a timesheet");
      }
    });
  }

  @override
  Future<void> replace(TimeSheetData timeSheet, TimeSheetData oldTimeSheet) async {
    timeSheets.remove(oldTimeSheet);
    timeSheets.add(timeSheet);
  }

  @override
  Future<void> update(TimeSheetData timeSheet) async{
    exists(timeSheet).then((exist) {
      if (exist) {
        var timeSheetWhichShouldBeUpdated = this.timeSheets.firstWhere((e) => timeSheet.name == e.name);
        timeSheetWhichShouldBeUpdated.endDate = timeSheet.endDate;
        timeSheetWhichShouldBeUpdated.startDate = timeSheet.startDate;
        timeSheetWhichShouldBeUpdated.endDate = timeSheet.endDate;
        timeSheetWhichShouldBeUpdated.initialTime = timeSheet.initialTime;
        timeSheetWhichShouldBeUpdated.timeDone = timeSheet.timeDone;
      } else {
        throw new AssertionError("You cannot update a time sheet that doesn't exist");
      }
    });
  }

}
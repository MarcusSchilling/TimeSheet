import 'package:flutter_app/services/data_service.dart';
import 'package:flutter_app/storage.dart';
import 'package:flutter_app/timesheet.dart';

class DataServiceImpl implements DataService {
  Storage storage = Storage();

  Future<List<TimeSheetData>> getTimeSheetData() {
    return storage.getAll();
  }

  Future<void> store(TimeSheetData timeSheet) {
    return storage.writeCounter(timeSheet);
  }

  Future<void> updateTimeDone(TimeSheetData timeSheet) {
    return storage.updateTimeDone(timeSheet);
  }

  Future<void> replace(TimeSheetData timeSheet, TimeSheetData oldTimeSheet) {
    return storage
        .delete(oldTimeSheet)
        .then((v) => storage.writeCounter(timeSheet));
  }

  Future<bool> exists(TimeSheetData timeSheet) {
    return storage
        .readCounter(timeSheet.name)
        .then((value) => true, onError: (err) => false);
  }

  Future<void> remove(TimeSheetData toDelete) {
    return storage.delete(toDelete);
  }
}

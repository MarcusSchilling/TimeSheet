
import 'dart:io';

import 'package:flutter_app/data_service.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional.dart';

import 'package:flutter_app/storage.dart';
import 'package:logging/logging.dart';

class DataServiceImpl implements DataService{
  Storage storage = Storage();

  Future<List<TimeSheetData>> getTimeSheetData() {
    return storage.getAll();
  }

  Future<void> store(TimeSheetData timeSheet) {
    return storage.writeCounter(timeSheet);
  }

  Future<void> update(TimeSheetData timeSheet) {
    return storage.updateTimeSheet(timeSheet);
  }

  Future<bool> exists(TimeSheetData timeSheet) {
    return storage.readCounter(timeSheet.name)
        .then((value) => true, onError: () => false);
  }

  Future<void> remove(TimeSheetData toDelete) {
    return storage.delete(toDelete);
  }

}


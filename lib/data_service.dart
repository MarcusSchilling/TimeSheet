
import 'dart:io';

import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional.dart';

import 'package:flutter_app/storage.dart';
import 'package:logging/logging.dart';

class DataService {
  Storage storage = Storage();

  Future<List<TimeSheetData>> getTimeSheetData() {
    return storage.getAll();
  }

  Future<void> store(TimeSheetData timeSheet) async {
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


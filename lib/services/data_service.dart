
import 'package:flutter_app/timesheet.dart';

abstract class DataService {

    Future<List<TimeSheetData>> getTimeSheetData();

    Future<void> store(TimeSheetData timeSheet);

    Future<void> update(TimeSheetData timeSheet);

    Future<void> replace(TimeSheetData timeSheet, TimeSheetData oldTimeSheet);

    Future<bool> exists(TimeSheetData timeSheet);

    Future<void> remove(TimeSheetData toDelete);

}
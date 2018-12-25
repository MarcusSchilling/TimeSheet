
import 'package:flutter_app/timesheet_data.dart';

abstract class DataService {

    Future<List<TimeSheetData>> getTimeSheetData();

    Future<void> store(TimeSheetData timeSheet);

    Future<void> update(TimeSheetData timeSheet);

    Future<bool> exists(TimeSheetData timeSheet);

    Future<void> remove(TimeSheetData toDelete);

}
import 'dart:io';
import 'package:flutter_app/data_service_impl.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Storage {
  Future<Database> database;

  Storage() {
    this.database = getDatabase();
  }

  Future<void> writeCounter(TimeSheetData timeSheet) async {
    return database.then((db) => db.transaction((tr) => tr.execute(
            "INSERT INTO Tasks(name, time_done, start_date, end_date, initial_time) VALUES(?,?,?,?,?)",
            [
              timeSheet.name,
              timeSheet.timeDone,
              timeSheet.hasStartDate() ? timeSheet.startDate.value.toIso8601String() : null,
              timeSheet.hasEndDate() ? timeSheet.endDate.value.toIso8601String() : null,
              timeSheet.initialTime
            ])));
  }

  Future<void> updateTimeSheet(TimeSheetData timeSheet) {
    return database.then((db) => db.transaction((tr) => tr.execute(
            "UPDATE Tasks SET time_done = ?, start_date = ?, end_date = ?, initial_time = ? WHERE name == ?",
            [
              timeSheet.timeDone,
              timeSheet.hasStartDate() ? timeSheet.startDate.value.toIso8601String() : null,
              timeSheet.hasEndDate() ? timeSheet.endDate.value.toIso8601String() : null,
              timeSheet.initialTime,
              timeSheet.name
            ])));
  }

  Future<List<TimeSheetData>> readCounter(String name) async {
    return database
        .then((db) => db.transaction(
            (tr) => tr.rawQuery("SELECT * FROM Tasks WHERE name = ?", [name])))
        .then((list) => transform(list));
  }

  Future<List<TimeSheetData>> getAll() async {
    return database.then((db) => db
        .transaction((tr) => tr.rawQuery("SELECT * FROM Tasks"))
        .then((value) => transform(value)));
  }

  Future<void> delete(TimeSheetData toDelete) {
    return database.then((db) => db.transaction((tr) =>
        tr.delete("Tasks", where: "name = ?", whereArgs: [toDelete.name])));
  }

  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    return await openDatabase(path, version: 4,
        onUpgrade: (db, oldVersion, newVersion) {
          switch (oldVersion) {
            case 1:
              db
                  .transaction((tr) => tr.execute(
                  "ALTER TABLE Tasks ADD end_date TEXT DEFAULT('" +
                      DateTime.now().toIso8601String() +
                      "')"))
                  .then((v) => db.execute(
                  'CREATE TABLE Tasks (name TEXT PRIMARY KEY, time REAL, date TEXT, end_date TEXT)'));
              continue secondVersionUpdate;
            secondVersionUpdate:
            case 2:
              db.transaction((tr) =>
                  tr.execute("ALTER TABLE Tasks ADD initial_time REAL DEFAULT(0)"))
                    .then((v) => db.execute(
                    'CREATE TABLE Tasks (name TEXT PRIMARY KEY, time REAL, date TEXT, end_date TEXT, initial_time REAL)'))
              .then((v) => db.execute("UPDATE Tasks SET initial_time = time"));
              continue thirdVersionUpdate;
            thirdVersionUpdate:  
            case 3:
              String update =
                  "Alter table Tasks rename to temp_Tasks;"+
                  "CREATE TABLE Tasks (name TEXT PRIMARY KEY, time_done REAL, start_date TEXT, end_date TEXT, initial_time REAL);"+
                  "INSERT INTO Tasks(name, time_done, start_date, end_date, initial_time) Select name, initial_time - time, date, end_date, initial_time from temp_Tasks;" +
                  "Drop table temp_Tasks";
              db.transaction((tr) => tr.execute(update));
              break;
            default:
              break;
          }
        },
        onCreate: (Database db, int version) async {
          db.execute('CREATE TABLE Tasks (name TEXT PRIMARY KEY, time_done REAL, start_date TEXT, end_date TEXT, initial_time REAL)');
        });
  }

  List<TimeSheetData> transform(List<Map<String, dynamic>> list) {
    List<TimeSheetData> timeSheets = List();
    for (var value in list) {
      var iterator = value.values.iterator;
      iterator.moveNext();
      var name = iterator.current;
      iterator.moveNext();
      var timeDone = iterator.current;
      iterator.moveNext();
      var startDate = Optional.of(DateTime.parse(iterator.current));
      iterator.moveNext();
      var end = iterator.current;
      var endDate;
      if (end == null) {
        endDate = Optional<DateTime>.empty();
      } else {
        endDate = Optional.ofNullable(DateTime.parse(iterator.current));
      }
      iterator.moveNext();
      var initialTime = iterator.current;
      var timeSheetData =
          TimeSheetData.from(timeDone, name, startDate, endDate, initialTime);
      timeSheets.add(timeSheetData);
    }
    return timeSheets;
  }
}

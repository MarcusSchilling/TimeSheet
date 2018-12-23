import 'dart:io';
import 'package:flutter_app/data_service.dart';
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
    return database.then((db) => db.transaction((tr) => tr.execute("INSERT INTO Tasks(name, time, date) VALUES(?,?,?)",
                    [timeSheet.name, timeSheet.time, timeSheet.date.value.toIso8601String()])));
  }

  Future<void> updateTimeSheet(TimeSheetData timeSheet) {
    return database.then((db) => db.transaction((tr) =>
        tr.execute("UPDATE Tasks SET time = ?, date = ? WHERE name == ?",
            [timeSheet.time, timeSheet.date.value.toIso8601String(), timeSheet.name])));
  }
  

  Future<List<TimeSheetData>> readCounter(String name) async {
    return database
        .then((db) => db.transaction((tr) => tr.rawQuery("SELECT * FROM Tasks WHERE name = ?", [name])))
        .then((list) => transform(list));
  }

  Future<List<TimeSheetData>> getAll() async {
    return database.then((db) => db.transaction((tr) => tr.rawQuery("SELECT * FROM Tasks"))
        .then((value) => transform(value)));
  }

  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Tasks (name TEXT PRIMARY KEY, time REAL, date TEXT)');
        });
  }

  List<TimeSheetData> transform(List<Map<String, dynamic>> list) {
    List<TimeSheetData> timeSheets = List();
    for (var value in list) {
      var iterator = value.values.iterator;
      iterator.moveNext();
      var name = iterator.current;
      iterator.moveNext();
      var time = iterator.current;
      iterator.moveNext();
      var date = Optional.ofNullable(DateTime.parse(iterator.current));
      var timeSheetData = TimeSheetData.from(time, name, date);
      timeSheets.add(timeSheetData);
    }
    return timeSheets;
  }
}
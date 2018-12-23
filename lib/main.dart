import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/appointment/appointment_controller.dart';
import 'package:flutter_app/data_service.dart';
import 'package:flutter_app/storage.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:optional/optional.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'TimeSheet',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'LearningtimeSheet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your applic  key);ation. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DataService dataService;

  bool loading = true;

  List<_MyRowItem> myRowItems;

  _MyHomePageState() {
    dataService = new DataService();
    myRowItems = List();
    dataService.getTimeSheetData()
        .then((list) {
      for (var timeSheet in list) {
        myRowItems.add(_MyRowItem(timeSheet));
      }
      setState(() {
        loading = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var list = ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            child: myRowItems.elementAt(index),
            onTap: () {
              _move(Optional.of(myRowItems.elementAt(index).timeSheet));
            },
          );
        },
      itemCount: loading ? 0 : myRowItems.length,
    );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: list, // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _move(Optional<TimeSheetData>.of(null)),
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void _move(Optional<TimeSheetData> timeSheet) {
    AppointmentController controller = AppointmentController(timeSheet);
    runApp(controller.view);
  }

}

class _MyRowItem extends StatefulWidget {

  TimeSheetData timeSheet;


  _MyRowItem(this.timeSheet);

  @override
  State<StatefulWidget> createState() {
    return _MyRowItemState(timeSheet);
  }

}

class _MyRowItemState extends State<_MyRowItem> {
  TimeSheetData timeSheet;

  void _incrementCounter() {
    setState(() {
     timeSheet.time -= 0.15;
    });
  }

  _MyRowItemState(TimeSheetData timeSheet) {
    this.timeSheet = timeSheet;
  }

  @override
  Widget build(BuildContext context) {
    if(timeSheet.hasDate()) {
      var dateTime = timeSheet.date.value;
      String dateSlug ="${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}";
      return ListTile(title: Text(timeSheet.title, textDirection: TextDirection.ltr,textAlign: TextAlign.left),
          trailing: IconButton(onPressed: _incrementCounter,icon: Icon(Icons.add)),
          leading: Text(dateSlug));
    }
    return ListTile(title: Text(timeSheet.title, textDirection: TextDirection.ltr,textAlign: TextAlign.left),
        trailing: IconButton(onPressed: _incrementCounter,icon: Icon(Icons.add)));
  }


}
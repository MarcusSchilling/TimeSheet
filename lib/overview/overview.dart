import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/appointment/appointment_controller.dart';
import 'package:flutter_app/data_service.dart';
import 'package:flutter_app/overview/overview_controller.dart';
import 'package:flutter_app/overview/overview_model.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:optional/optional_internal.dart';


class Overview extends StatelessWidget {

  OverviewModel model;
  var changeTimeSheet;
  var performClickOnTimeSheet;

  Overview(this.model, void changeTimeSheet(), void performClickOnTimeSheet(TimeSheetData timeSheetData)){
    this.model = model;
    this.changeTimeSheet = changeTimeSheet;
    this.performClickOnTimeSheet = performClickOnTimeSheet;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: OverviewPage(model, changeTimeSheet, performClickOnTimeSheet ,title: 'LearningtimeSheet'),
    );
  }
}

class OverviewPage extends StatefulWidget {

  OverviewModel model;
  var changeTimeSheet;
  var performClickOnTimeSheet;

  OverviewPage(this.model, void changeTimeSheet(), void performClickOnTimeSheet(TimeSheetData timeSheetData), {Key key, this.title}) : super(key: key) {
    this.model = model;
    this.changeTimeSheet = changeTimeSheet;
    this.performClickOnTimeSheet = performClickOnTimeSheet;
  }

  // This widget is the home page of your applic  key);ation. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  OverviewState createState() => OverviewState(model, changeTimeSheet, performClickOnTimeSheet);
}

class OverviewState extends State<OverviewPage> {
  bool loading = true;

  List<_MyRowItem> myRowItems;
  OverviewModel model;
  var changeTimeSheet;
  var performClickOnTimeSheet;

  OverviewState(OverviewModel model, void changeTimeSheet(), void performClickOnTimeSheet(TimeSheetData timeSheet)) {
    this.model = model;
    myRowItems = List();
    model.register(updateView);
    this.changeTimeSheet = changeTimeSheet;
    this.performClickOnTimeSheet = performClickOnTimeSheet;
  }

  void updateAll(Optional<TimeSheetData> timeSheet) {
    model.selectTimeSheet(timeSheet);
    changeTimeSheet();
  }

  void updateView(List<TimeSheetData> timeSheets) {
    myRowItems.clear();
    for (var value in timeSheets) {
      myRowItems.add(new _MyRowItem(value, performClickOnTimeSheet));
    }
    setState(() {
      loading = false;
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
            updateAll(Optional.of(myRowItems.elementAt(index).timeSheet));
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
      body: list,
      // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
          onPressed: () => updateAll(Optional.empty()),
      child: Icon(Icons.add),
    ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}



class _MyRowItemState extends State<_MyRowItem> {
  TimeSheetData timeSheet;
  var performClickOnTimeSheet;

  _MyRowItemState(TimeSheetData timeSheet, void performClickOnTimeSheet(TimeSheetData timeSheet)) {
    this.timeSheet = timeSheet;
    this.performClickOnTimeSheet = performClickOnTimeSheet;
  }

  void click() {
    performClickOnTimeSheet(timeSheet);
  }

  @override
  Widget build(BuildContext context) {
    if (timeSheet.hasDate()) {
      return ListTile(
          title: Text(timeSheet.title,
              textDirection: TextDirection.ltr, textAlign: TextAlign.left),
          trailing:
          IconButton(onPressed: click, icon: Icon(Icons.add)),
          leading: Text(timeSheet.formattedDate));
    }
    return ListTile(
        title: Text(timeSheet.title,
            textDirection: TextDirection.ltr, textAlign: TextAlign.left),
        trailing:
        IconButton(onPressed: click, icon: Icon(Icons.add)));
  }
}

class _MyRowItem extends StatefulWidget {
  final TimeSheetData timeSheet;
  var performClickOnTimeSheet;

  _MyRowItem(this.timeSheet, void performClickOnTimeSheet(TimeSheetData timeSheetData)) {
    this.performClickOnTimeSheet = performClickOnTimeSheet;
  }

  @override
  State<StatefulWidget> createState() {
    return _MyRowItemState(timeSheet, performClickOnTimeSheet);

  }
}

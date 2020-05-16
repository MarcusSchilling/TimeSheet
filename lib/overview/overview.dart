import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/appointment/appointment_controller.dart';
import 'package:flutter_app/services/data_service_impl.dart';
import 'package:flutter_app/overview/overview_controller.dart';
import 'package:flutter_app/overview/overview_model.dart';
import 'package:flutter_app/timesheet.dart';
import 'package:optional/optional_internal.dart';
import 'package:flutter_app/constants.dart';

typedef void ChangeTimeSheet();
typedef void PerformClickOnTimeSheet(TimeSheetData timeSheetData);

class Overview extends StatelessWidget {

  OverviewModel model;
  ChangeTimeSheet changeTimeSheet;
  PerformClickOnTimeSheet performClickOnTimeSheet;

  Overview(
      this.model,
      {ChangeTimeSheet changeTimeSheet,
      PerformClickOnTimeSheet performClickOnTimeSheet}){
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
        primarySwatch: Colors.red,
      ),
      home: OverviewPage(model,
          changeTimeSheet: changeTimeSheet,
          performClickOnTimeSheet: performClickOnTimeSheet,
          title: 'LearningtimeSheet'),
    );
  }
}


class OverviewPage extends StatefulWidget {

  OverviewModel model;
  ChangeTimeSheet changeTimeSheet;
  PerformClickOnTimeSheet performClickOnTimeSheet;

  OverviewPage(this.model,
      {ChangeTimeSheet changeTimeSheet,
      PerformClickOnTimeSheet performClickOnTimeSheet,
      Key key,
      this.title}) : super(key: key) {
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
  OverviewState createState() => OverviewState(
      model,
      changeTimeSheet: changeTimeSheet,
      performClickOnTimeSheet: performClickOnTimeSheet);
}

class OverviewState extends State<OverviewPage> {
  bool loading = true;

  List<_MyRowItem> myRowItems;
  ListView listView;
  OverviewModel model;
  var changeTimeSheet;
  PerformClickOnTimeSheet performClickOnTimeSheet;

  OverviewState(
        OverviewModel model,
        {ChangeTimeSheet changeTimeSheet,
        PerformClickOnTimeSheet performClickOnTimeSheet}) {
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
    loading = true;
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
    listView = ListView.builder(
      itemBuilder: (context, index) {
        return GestureDetector(child: myRowItems.elementAt(index),
        key: Constants.listElementKey,
        onTap: () => updateAll(Optional.of(myRowItems.elementAt(index).timeSheet)),);
      },
      itemCount: loading ? 0 : myRowItems.length,
    );
    return Scaffold(
      key: Constants.overviewScaffoldKey,
      appBar: AppBar(
// Here we take the value from the MyHomePage object that was created by
// the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: listView,
      // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
          onPressed: () => updateAll(Optional.empty()),
          key: Constants.newAppointmentButtonKey,
      child: Icon(Icons.add),
    ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}

class _MyRowItemState extends State<_MyRowItem> {
  TimeSheetData timeSheet;
  PerformClickOnTimeSheet performClickOnTimeSheet;

  _MyRowItemState(TimeSheetData timeSheet, PerformClickOnTimeSheet performClickOnTimeSheet) {
    this.timeSheet = timeSheet;
    this.performClickOnTimeSheet = performClickOnTimeSheet;
  }

  void click() {
    performClickOnTimeSheet(timeSheet);
  }

  @override
  Widget build(BuildContext context) {
    var incrementTimeDoneButton = IconButton(onPressed: click,
        icon: Icon(Icons.add),
        key: Constants.incrementButtonKey,
    );
    if (timeSheet.hasEndDate()) {
      return ListTile(
          title: Text(timeSheet.title(DateTime.now()),
              textDirection: TextDirection.ltr, textAlign: TextAlign.left,
          style: TextStyle(color: timeSheet.progressColor(currentTime: DateTime.now())),),
          trailing:
          incrementTimeDoneButton,
          leading: Text(timeSheet.formattedDate));
    }
    return ListTile(
        title: Text(timeSheet.title(DateTime.now()),
            textDirection: TextDirection.ltr, textAlign: TextAlign.left),
        trailing:
        incrementTimeDoneButton);
  }
}

class _MyRowItem extends StatefulWidget {
  final TimeSheetData timeSheet;
  PerformClickOnTimeSheet performClickOnTimeSheet;

  _MyRowItem(this.timeSheet, this.performClickOnTimeSheet);

  @override
  State<StatefulWidget> createState() {
    return _MyRowItemState(timeSheet, performClickOnTimeSheet);
  }
}

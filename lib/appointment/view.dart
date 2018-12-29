import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/appointment/model.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:intl/intl.dart';
import 'package:optional/optional_internal.dart';

typedef void DeleteTimeSheet();
typedef Future<bool> Exit();

class AppointmentView extends StatelessWidget {
  VoidCallback save;
  MyAppointmentView view;
  AppointmentModel model;
  Exit exit;
  DeleteTimeSheet deleteTimeSheet;

  AppointmentView(this.save, this.model, this.exit, this.deleteTimeSheet);

  @override
  Widget build(BuildContext context) {
    view = MyAppointmentView(model, save, exit, deleteTimeSheet,
        title: "Appointment");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Appointment",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: view,
    );
  }

  void error(String errorMessage) {
    view.error(errorMessage);
  }

  Future<bool> checkIfUserIsSure(String message) {
    return view.checkIfUserWantsAction(message);
  }
}

class MyAppointmentView extends StatefulWidget {
  MyAppointmentView(this.model, this.save, this.exit, this.delete,
      {Key key, title})
      : super(key: key);

  AppointmentModel model;
  VoidCallback save;
  _MyAppointmentViewState viewState;
  Exit exit;
  DeleteTimeSheet delete;

  @override
  _MyAppointmentViewState createState() {
    viewState =
        _MyAppointmentViewState(this.model, this.save, this.exit, this.delete);
    return viewState;
  }

  void error(String errorMessage) {
    viewState.error(errorMessage);
  }

  Future<bool> checkIfUserWantsAction(String message) {
    return viewState.checkIfUserWantsAction(message);
  }
}

class _MyAppointmentViewState extends State<MyAppointmentView> {
  TextField nameTF;
  TextField timeTF;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController timeEditingController = TextEditingController();
  VoidCallback save;
  AppointmentModel model;
  BuildContext context;
  Exit exit;
  DeleteTimeSheet delete;
  static const double edge = 10;

  _MyAppointmentViewState(this.model, this.save, this.exit, this.delete);

  Future<bool> _onWillPop() {
    return exit();
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView(
      children: <Widget>[
        nameRow(),
        timeRow(),
        dateFormatRow(),
        deleteSaveRow()
      ],
      // This trailing comma makes auto-formatting nicer for build methods.
    );
    Scaffold scaffold = new Scaffold(
        key: Key("Scaffold"),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Appointment"),
        ),
        body: new Builder(
          builder: (BuildContext context) {
            this.context = context;
            return listView;
          },
        ));
    return new WillPopScope(child: scaffold, onWillPop: _onWillPop);
  }

  Padding deleteSaveRow() {
    return new Padding(
        padding: EdgeInsets.only(left: edge, right: edge),
        child: new Row(
          children: <Widget>[
            Flexible(child: deleteButton(), fit: FlexFit.tight),
            SizedBox(width: 15),
            Flexible(child: saveButton(), fit: FlexFit.tight)
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }

  RaisedButton deleteButton() {
    return RaisedButton(
        onPressed: delete, padding: EdgeInsets.all(edge), child: Text("Löschen"));
  }

  RaisedButton saveButton() {
    return RaisedButton(
        onPressed: save, padding: EdgeInsets.all(edge), child: Text("Speichern"));
  }

  Row nameRow() {
    Text name = Text("Name: ", textAlign: TextAlign.left);
    if (model.hasName()) {
      nameTF = TextField(
        controller: nameEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Bitte Namen der Aufgabe eingeben",
          labelText: model.timeSheetData.name,
        ),
        onChanged: model.updateName,
      );
    } else {
      nameTF = TextField(
        controller: nameEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Bitte Namen der Aufgabe eingeben",
        ),
        onChanged: model.updateName,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(edge),
          child: name,
        ),
        new Flexible(
            child: Container(
          padding: const EdgeInsets.all(edge),
          child: nameTF,
        ))
      ],
    );
  }

  Row timeRow() {
    Text time = Text("Zeit: ", textAlign: TextAlign.left);
    if (model.hasTime()) {
      timeTF = TextField(
        controller: timeEditingController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Bitte Zeit der Aufgabe eingeben",
            labelText: model.timeSheetData.timeFormatted),
        keyboardType: TextInputType.number,
        onChanged: (value) => model.updateTime(double.parse(value)),
      );
    } else {
      timeTF = TextField(
        controller: timeEditingController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Bitte Zeit der Aufgabe eingeben",
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) => model.updateTime(double.parse(value)),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(edge),
          child: time,
        ),
        new Flexible(
            child: Container(
          padding: const EdgeInsets.all(edge),
          child: timeTF,
        ))
      ],
    );
  }

  Padding dateFormatRow() {
    final dateFormatter = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
    if (model.hasEndDate()) {
      return new Padding(padding: EdgeInsets.only(left: edge, right: edge), child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        new Flexible(
          child: DateTimePickerFormField(
            format: dateFormatter,
            decoration: InputDecoration(labelText: 'Date'),
            onChanged: model.updateDate,
            initialValue: model.timeSheetData.endDate.value,
          ),
        ),
      ]));
    } else {
      return new Padding(padding: EdgeInsets.only(left: edge, right: edge), child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        new Flexible(
          child: DateTimePickerFormField(
            format: dateFormatter,
            decoration: InputDecoration(labelText: 'Date'),
            onChanged: model.updateDate,
          ),
        ),
      ]));
    }
  }

  void error(String errorMessage) {
    Scaffold.of(this.context).showSnackBar(new SnackBar(
      content: new Text(errorMessage),
    ));
  }

  Future<bool> checkIfUserWantsAction(String message) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('Do it!'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }
}

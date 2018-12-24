

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/appointment/model.dart';
import 'package:flutter_app/timesheet_data.dart';
import 'package:intl/intl.dart';
import 'package:optional/optional_internal.dart';



class AppointmentView extends StatelessWidget {

  VoidCallback save;
  MyAppointmentView view;
  AppointmentModel model;
  var exit;

  AppointmentView(this.save, this.model, Future<bool> exit()) {
    this.exit = exit;
  }

  @override
  Widget build(BuildContext context) {
    view = MyAppointmentView(model, save, exit ,title: "Appointment");
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

}

class MyAppointmentView extends StatefulWidget {
  MyAppointmentView(this.model, this.save, this.exit , {Key key, title}) : super(key: key);

  AppointmentModel model;
  VoidCallback save;
  _MyAppointmentViewState viewState;
  var exit;

  @override
  _MyAppointmentViewState createState() {
    viewState = _MyAppointmentViewState(this.model, this.save, this.exit);
    return viewState;
  }

  void error(String errorMessage) {
    viewState.error(errorMessage);
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
  var exit;

  _MyAppointmentViewState(this.model, this.save, this.exit);


  Future<bool> _onWillPop() {
    return exit();
  }

    @override
  Widget build(BuildContext context) {
    var listView = ListView(children: <Widget>[
        nameRow(),
        timeRow(),
        dateFormatRow()
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: Icon(Icons.add),
      ),

    );
    return new WillPopScope(child: scaffold, onWillPop: _onWillPop);
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
            padding: const EdgeInsets.all(20),
            child: name,
          ),
          new Flexible(child: Container(
            padding: const EdgeInsets.all(20),
            child: nameTF,
          ))
        ],
      );
  }


  Row timeRow() {
    Text time = Text("Zeit: ", textAlign: TextAlign.left);
    if(model.hasTime()){
      timeTF =  TextField(
        controller: timeEditingController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Bitte Zeit der Aufgabe eingeben",
            labelText: model.timeSheetData.timeFormatted
        ),
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
          padding: const EdgeInsets.all(20),
          child: time,
        ),
        new Flexible(child: Container(
          padding: const EdgeInsets.all(20),
          child: timeTF,
        ))
      ],
    );

  }

  Row dateFormatRow() {
    final dateFormatter = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
    if (model.hasDate()) {
      return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Flexible(child: DateTimePickerFormField(
              format: dateFormatter,
              decoration: InputDecoration(labelText: 'Date'),
              onChanged: model.updateDate,
              initialValue: model.timeSheetData.endDate.value,
            ),
            ),
          ]
      );
    } else {
      return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Flexible(child: DateTimePickerFormField(
              format: dateFormatter,
              decoration: InputDecoration(labelText: 'Date'),
              onChanged: model.updateDate,
            ),
            ),
          ]
      );
    }
  }

  void error(String errorMessage) {
    Scaffold.of(this.context).showSnackBar(new SnackBar(
      content: new Text(errorMessage),
    ));
  }

}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timesheet',
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
      home: MyHomePage(title: 'Learning timesheet'),
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


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              _MyRowItem(time: 50, name: "WASA", date: DateTime.utc(2019,2,6,14,30,0,0,0)),
              _MyRowItem(time: 70,name: "Organisationsmanagement",date: DateTime.utc(2019,2,14,14,30,0,0,0)),
              _MyRowItem(time: 80,name: "Rewe", date: DateTime.utc(2019,2,15,9,0,0,0,0)),
              _MyRowItem(time: 70,name: "Finanzwirtschaft-Rewe", date: DateTime.utc(2019,2,28,8,0,0,0,0)),
              _MyRowItem(time: 100,name: "Mobile-Computing"),
              _MyRowItem(time: 120,name: "Programmierparadigmen", date: DateTime.utc(2019,4,4,11,00,0,0,0)),
            ],
          ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _MyRowItem extends StatefulWidget {

  double time;
  String name;
  DateTime date;

  _MyRowItem({double time, String name, DateTime date}) {
    this.time = time;
    this.name = name;
    this.date = date;
  }

  @override
  State<StatefulWidget> createState() {
    return date==null? _MyRowItemState(time: time, name: name):_MyRowItemStateWithDate(time: time, name: name, date: date);
  }

}

class _MyRowItemState extends State<_MyRowItem> {
  double time;
  String name;
  _Storage storage;

  void _incrementCounter() {
    setState(() {
      time -= 0.1;
    });
    storage.writeCounter(name, time);
  }

  _MyRowItemState({double time, String name}) {
    storage = _Storage();
    this.time = 0;
    storage.readCounter(name)
          .then((double a) => this.time += a)
          .catchError((e) => this.time = time);
    this.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(name + ": " + ((time*10).round()/10).toString(), textDirection: TextDirection.ltr,textAlign: TextAlign.left),
        trailing: IconButton(onPressed: _incrementCounter,icon: Icon(Icons.add)));
  }

}
class _MyRowItemStateWithDate extends _MyRowItemState {

  DateTime date;

  _MyRowItemStateWithDate({double time, String name, DateTime date}): super(time: time, name: name) {
    this.date = date;
  }

  @override
  Widget build(BuildContext context) {
    String dateSlug ="${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
    return ListTile(title: Text(name + ": " + ((time*10).round()/10).toString(), textDirection: TextDirection.ltr,textAlign: TextAlign.left),
      trailing: IconButton(onPressed: _incrementCounter,icon: Icon(Icons.add)),
      leading: Text(dateSlug));
  }

}

class _Storage {

  Future<File> writeCounter(String name, double time) async{
    final file = await _localFile(name);
    return file.writeAsString(((time*10).round()/10).toString());
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String name) async {
    final path = await _localPath;
    return File('$path/' + name + '.txt');
  }

  Future<double> readCounter(String name) async {
    try {
      final file = await _localFile(name);

      // Read the file
      String contents = await file.readAsString();

      return double.parse(contents);
    } catch (e) {
      // If we encounter an error, return 0
      throw FileSystemException("file not saved");
    }
  }

}
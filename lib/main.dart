import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ssa/charts.dart';
import 'package:ssa/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:ssa/contract/sadhana.dart';
import 'package:ssa/view_sadhana.dart';
import './personal_details_form.dart';
import './sadhana_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Local Storage
  Directory document = await getApplicationDocumentsDirectory();
  Hive
    ..init(document.path)
    ..registerAdapter(SadhanaAdapter());

  await Hive.openBox(HIVE_BOX_PERSONAL_DETAILS);
  await Hive.openBox<Sadhana>(HIVE_BOX_SADHANA_RECORD);

  runApp(const SSA());
}

class SSA extends StatelessWidget {
  const SSA({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool showPersonalDetailsForm = false;
    Box hivePersonalDetailsBox = Hive.box(HIVE_BOX_PERSONAL_DETAILS);
    var devoteeName = hivePersonalDetailsBox.get('name');
    if (devoteeName == null) {
      showPersonalDetailsForm = true;
    }

    return MaterialApp(
      title: 'Flutter Demo',
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
        primarySwatch: Colors.blue,
      ),
      home: showPersonalDetailsForm ? Scaffold(appBar: AppBar(title: Text('SSA'),), body: const PersonalDetailsForm()) : const MyHomePage(title: 'Sadhana Record'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box hivePersonalDetailsBox = Hive.box(HIVE_BOX_PERSONAL_DETAILS);

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    ViewSadhana(),
    SadhanaForm(DateTime.now()),
    PersonalDetailsForm(),
    // Charts(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      _widgetOptions[index] = SadhanaForm(DateTime.now());
    }
    setState(() {
      _selectedIndex = index;
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
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Saved Sadhana',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Fill Sadhana',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.auto_graph),
            //   label: 'Analytics',
            // ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ));
  }
}

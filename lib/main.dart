import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kit305_assignment_4/model/nappy.dart';
import 'package:kit305_assignment_4/model/feed.dart';
import 'package:kit305_assignment_4/model/sleep.dart';
import 'package:kit305_assignment_4/view/new/newFeed.dart';
import 'package:kit305_assignment_4/view/new/newNappy.dart';
import 'package:kit305_assignment_4/view/new/newSleep.dart';
import 'package:kit305_assignment_4/view/summary.dart';
import 'package:kit305_assignment_4/view/tables/feedsTableView.dart';
import 'package:kit305_assignment_4/view/tables/nappiesTableView.dart';
import 'package:kit305_assignment_4/view/tables/sleepsTableView.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("\n\nConnected to Firebase App ${app.options.projectId}\n\n");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NappyModel()),
        ChangeNotifierProvider(create: (_) => FeedModel()),
        ChangeNotifierProvider(create: (_) => SleepModel()),
      ],
      child: const MaterialApp(
        // Your app configuration...
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final tabs = [
    const NappiesListView(),
    const FeedsListView(),
    const SleepsListView(),
    const Summary(),
  ];

  Widget buildFloatingActionButton() {
    if (_currentIndex != 3) {
      return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              if(_currentIndex == 0) {
                return const NewNappy();
              }
              else if( _currentIndex == 1) {
                return const NewFeed();
              }
              else if(_currentIndex == 2) {
                return const NewSleep();
              } else {
                // Handle the default case when _currentIndex doesn't match any condition
                return Container(); // or any other widget you want to return, or null
              }
            },
          );
        },
        child: const Icon(Icons.add),
      );
    } else {
      return Container(); // Return an empty container if _currentIndex is 3
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Baby Tracker App"),
      ),
      floatingActionButton: buildFloatingActionButton(),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'poo.png',
              width: 24,  // adjust the width to your desired size
              height: 24,
              color: Colors.white),
            label: "Nappies",
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'feed.png',
              width: 24,  // adjust the width to your desired size
              height: 24,
              color: Colors.white,),
            label: "Feeds",
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'sleep.png',
              width: 24,  // adjust the width to your desired size
              height: 24,
              color: Colors.white),
            label: "Sleeps",
            backgroundColor: Colors.purple,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.summarize),
            label: "Nappies",
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}


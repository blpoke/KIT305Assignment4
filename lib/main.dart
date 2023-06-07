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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Baby Tracker App"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(context: context, builder: (context) {
            switch (_currentIndex) {
              case 0:
                return const NewNappy();
              case 1:
                  return const NewFeed();
              case 2:
                return const NewSleep();
              default:
                return const Summary();
            }
          });
        },
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.border_inner),
            label: "Nappies",
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_inner),
            label: "Feeds",
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_inner),
            label: "Sleeps",
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_inner),
            label: "Summary",
            backgroundColor: Colors.blue,
          )
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


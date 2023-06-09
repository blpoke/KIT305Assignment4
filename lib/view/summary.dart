import 'package:flutter/material.dart';
import 'package:kit305_assignment_4/model/feed.dart';
import 'package:kit305_assignment_4/model/nappy.dart';
import 'package:provider/provider.dart';

import '../model/sleep.dart';
import '../util/util.dart';

class Summary extends StatefulWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {

    final nappies = Provider.of<NappyModel>(context);
    final feeds = Provider.of<FeedModel>(context);
    final sleeps = Provider.of<SleepModel>(context);

    List<Sleep> selectedSleeps = sleeps.filterByDate(_selectedDate);
    List<Nappy> selectedNappies = nappies.filterByDate(_selectedDate);
    List<Feed> selectedFeeds = feeds.filterByDate(_selectedDate);

    int wet = countWet(selectedNappies);
    int dirty = countDirty(selectedNappies);
    int totalSleepDuration = totalSleep(selectedSleeps);
    int feedTimeLeft = totalLeft(selectedFeeds);
    int feedTimeRight = totalRight(selectedFeeds);
    int feedTimeBottle = totalBottle(selectedFeeds);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: const Text('Date and Time'),
            subtitle: Text(formatDate(_selectedDate)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final DateTime? date = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(3000),
              );
              if (date != null) {
                setState(() => {
                  _selectedDate = date
                });
              }
            },
          ),
          const Text("Total Nappies"),
          ListTile(
            title: const Text("Wet"),
            subtitle: Text("$wet"),
          ),
          ListTile(
            title: const Text("Dirty"),
            subtitle: Text("$dirty"),
          ),
          const Text("Total Feed Time"),
          ListTile(
            title: const Text("Left"),
            subtitle: Text("$feedTimeLeft Mins"),
          ),
          ListTile(
            title: const Text("Right"),
            subtitle: Text("$feedTimeRight Mins"),
          ),
          ListTile(
            title: const Text("Bottle"),
            subtitle: Text("$feedTimeBottle Mins"),
          ),
          const Text("Total Sleep Time"),
          ListTile(
            title: Text("$totalSleepDuration Mins"),
          ),
        ],
      ),
    );
  }
}

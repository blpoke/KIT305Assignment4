import 'package:flutter/material.dart';
import 'package:kit305_assignment_4/model/feed.dart';
import 'package:kit305_assignment_4/model/sleep.dart';
import 'package:kit305_assignment_4/util/util.dart';
import 'package:provider/provider.dart';

class SleepsListView extends StatelessWidget {
  const SleepsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sleepModel = Provider.of<SleepModel>(context);

    if (sleepModel.loading)
    {
      return const Center(
          child:CircularProgressIndicator()
      );
    }
    else
    {
      return ListView.builder(
        itemBuilder: (_, index) {
          var sleep = sleepModel.items[index];
          return ListTile(
            title: Text(formatTimestamp(sleep.dateTime)),
            subtitle: Text("${sleep.duration} Mins"),
          );
        },
        itemCount: sleepModel.items.length,
      );
    }
  }
}
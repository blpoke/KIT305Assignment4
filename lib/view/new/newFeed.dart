import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../model/feed.dart';
import '../../util/util.dart';

class NewFeed extends StatefulWidget {
  const NewFeed({Key? key}) : super(key: key);

  @override
  State<NewFeed> createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> {

  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDateTime = DateTime.now();
  final noteController = TextEditingController();
  final durationController = TextEditingController();
  int? groupValue = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Feed"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: const Text('Date and Time'),
                          subtitle: Text(formatDateTime(_selectedDateTime)),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: _selectedDateTime,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(3000),
                            );
                            if (date != null) {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                              );

                              if (time != null) {
                                setState(() {
                                  _selectedDateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                });
                              }
                            }
                          },
                        ),
                        CupertinoSlidingSegmentedControl(
                            padding: const EdgeInsets.all(4),
                            groupValue: groupValue,
                            children: {
                              0: Text(capitalizeEnumString(FeedingOption.left.toString().split('.').last)),
                              1: Text(capitalizeEnumString(FeedingOption.right.toString().split('.').last)),
                              2: Text(capitalizeEnumString(FeedingOption.bottle.toString().split('.').last))
                            },
                            onValueChanged: (groupValue) {
                              print(groupValue);

                              setState(() => this.groupValue = groupValue as int?);
                            }
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Duration"),
                          controller: durationController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Note"),
                          controller: noteController,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ?? false) {

                                    Timestamp dateTime = Timestamp.fromMillisecondsSinceEpoch(_selectedDateTime.millisecondsSinceEpoch);
                                    FeedingOption feedOpt;

                                    if(groupValue == 0)
                                    {
                                      feedOpt = FeedingOption.left;
                                    }
                                    else if (groupValue == 1)
                                    {
                                      feedOpt = FeedingOption.right;
                                    }
                                    else
                                    {
                                      feedOpt = FeedingOption.bottle;
                                    }

                                    int duration = int.parse(durationController.text);

                                    String note = noteController.text;

                                    Feed feed = Feed(dateTime: dateTime, duration: duration, feedOpt: feedOpt, note: note);

                                    await Provider.of<FeedModel>(context, listen: false).add(feed);

                                    Navigator.pop(context);
                                  }
                                },
                                icon: const Icon(Icons.save),
                                label: const Text("Save")
                            )
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        )
    );
  }
}

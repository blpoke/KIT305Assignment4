import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kit305_assignment_4/model/feed.dart';
import 'package:kit305_assignment_4/util/util.dart';
import 'package:provider/provider.dart';

class FeedDetails extends StatefulWidget {
  const FeedDetails({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<FeedDetails> createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {

  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDateTime = DateTime.now();
  final noteController = TextEditingController();
  final durationController = TextEditingController();
  int? groupValue = 0;

  @override
  Widget build(BuildContext context) {

    var feed = Provider.of<FeedModel>(context, listen:false).get(widget.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Feed"),
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
                        subtitle: Text(FormatDateTime(_selectedDateTime)),
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

                                  feed!.dateTime = Timestamp.fromMillisecondsSinceEpoch(_selectedDateTime.millisecondsSinceEpoch);
                                  if(groupValue == 0)
                                  {
                                    feed.feedOpt = FeedingOption.left;
                                  }
                                  else if (groupValue == 1)
                                  {
                                    feed.feedOpt = FeedingOption.right;
                                  }
                                  else
                                  {
                                    feed.feedOpt = FeedingOption.bottle;
                                  }

                                  feed.duration = int.parse(durationController.text);

                                  feed.note = noteController.text;

                                  await Provider.of<FeedModel>(context, listen: false).updateItem(widget.id!, feed);

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

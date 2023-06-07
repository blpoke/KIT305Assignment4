import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/nappy.dart';
import '../../util/util.dart';

class NewNappy extends StatefulWidget {
  const NewNappy({Key? key}) : super(key: key);

  @override
  State<NewNappy> createState() => _NewNappyState();
}

class _NewNappyState extends State<NewNappy> {

  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  int? groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Nappy"),
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
                                      print(FormatDateTime(_selectedDateTime));
                                    });
                                  }
                                }
                              },
                            ),
                            CupertinoSlidingSegmentedControl(
                                padding: const EdgeInsets.all(4),
                                groupValue: groupValue,
                                children: {
                                  0: Text(capitalizeEnumString("Wet")),
                                  1: Text(capitalizeEnumString("Dirty")),
                                },
                                onValueChanged: (groupValue) {
                                  setState(() => this.groupValue = groupValue as int?);
                                }
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: "Note"),
                              controller: noteController,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false)
                                {
                                  Timestamp dateTime = Timestamp.fromMillisecondsSinceEpoch(_selectedDateTime.millisecondsSinceEpoch);

                                  bool dirty;
                                  if (groupValue == 1)
                                  {
                                    dirty = true;
                                  }
                                  else {
                                    dirty = false;
                                  }

                                  String note = noteController.text;

                                  Nappy nappy = Nappy(dateTime: dateTime, dirty: dirty, note: note);

                                  await Provider.of<NappyModel>(context, listen:false).add(nappy);
                                  //return to previous screen
                                  Navigator.pop(context);
                                }
                              }, icon: const Icon(Icons.save), label: const Text("Save Values")),
                            )
                          ],
                        ),
                      )
                  )

                  //we will add form fields etc here

                ]
            )
        )
    );
  }
}

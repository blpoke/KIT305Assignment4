import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kit305_assignment_4/model/nappy.dart';
import 'package:kit305_assignment_4/util/util.dart';
import 'package:provider/provider.dart';

class NappyDetails extends StatefulWidget {
  const NappyDetails({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<NappyDetails> createState() => _NappyDetailsState();
}

class _NappyDetailsState extends State<NappyDetails> {

  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  int? groupValue = 0;

  @override
   Widget build(BuildContext context)
  {
    var nappy = Provider.of<NappyModel>(context, listen:false).get(widget.id);
    Nappy? temp = nappy;

    _selectedDateTime = temp!.dateTime.toDate();
    noteController.text = temp.note;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Nappy"),
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
                                      temp.dateTime = toTimestamp(_selectedDateTime);

                                      if(groupValue == 1)
                                      {
                                        temp.dirty =  true;
                                      }
                                      else
                                      {
                                        temp.dirty = false;
                                      }

                                      temp.note = noteController.text;

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
                                  nappy!.dateTime = toTimestamp(_selectedDateTime);
                                  if (groupValue == 1) {
                                    nappy.dirty = true;
                                  }
                                  else {
                                    nappy.dirty = false;
                                  }
                                  nappy.note = noteController.text;

                                  await Provider.of<NappyModel>(context, listen:false).updateItem(widget.id!, nappy);
                                  //return to previous screen
                                  Navigator.pop(context);
                                }
                              }, icon: const Icon(Icons.save), label: const Text("Save Values")),
                            )
                          ],
                        ),
                      )
                  )
                ]
            )
        )
    );
  }
}

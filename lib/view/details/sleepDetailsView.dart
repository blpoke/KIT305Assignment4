import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kit305_assignment_4/model/sleep.dart';
import 'package:provider/provider.dart';
import '../../util/util.dart';

class SleepDetails extends StatefulWidget {
  const SleepDetails({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<SleepDetails> createState() => _SleepDetailsState();
}

class _SleepDetailsState extends State<SleepDetails> {

  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDateTime = DateTime.now();
  final noteController = TextEditingController();
  final durationController = TextEditingController();
  int? groupValue = 0;

  @override
  Widget build(BuildContext context) {
    var sleep = Provider.of<SleepModel>(context, listen:false).get(widget.id);
    Sleep? temp = sleep;
    
    _selectedDateTime = temp!.dateTime.toDate();
    noteController.text = temp.note;
    durationController.text = temp.duration.toString();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Sleep"),
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
                                  temp.duration = int.parse(durationController.text);
                                  temp.note = noteController.text;
                                });
                              }
                            }
                          },
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

                                    sleep!.dateTime = toTimestamp(_selectedDateTime);
                                    sleep.duration = int.parse(durationController.text);

                                    sleep.note = noteController.text;

                                    await Provider.of<SleepModel>(context, listen: false).updateItem(widget.id!, sleep);

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

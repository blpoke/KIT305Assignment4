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
  late DateTime _selectedDate;
  bool _isChecked = false;

  bool light0 = true;
  bool light1 = true;

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          print(FormatDate(_selectedDate));
        });
      }
    }
  }

  @override
   Widget build(BuildContext context)
  {
    var nappy = Provider.of<NappyModel>(context, listen:false).get(widget.id);

    noteController.text = nappy!.note;
    _selectedDate = nappy.dateTime.toDate();
    if(nappy.dirty == true){
      _isChecked = true;
    }
    else{
      _isChecked = false;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Movie"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  //Display movie id
                  Text("Chose Movie ID ${widget.id}"),
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text('Date and Time'),
                              subtitle: Text(FormatDate(_selectedDate)),
                              trailing: Icon(Icons.calendar_today),
                              onTap: () => _selectDateTime(context),
                            ),
                            const SizedBox(height: 16.0),
                            Center(
                              child: Column(
                                children: [
                                  Text("Dirty?"),
                                  Switch(
                                  value: light1,
                                  onChanged: (bool value) {
                                    setState(() {
                                      light1 = value;
                                      _isChecked = value;
                                      print(value);
                                    });
                                  },
                                  )
                                ],
                              ),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(labelText: "Note"),
                              controller: noteController,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(onPressed: () {
                                if (_formKey.currentState?.validate() ?? false)
                                {
                                  //TODO: save the movie
                                  //await Provider.of<NappyModel>(context, listen:false).updateItem(widget.id!, nappy!);
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

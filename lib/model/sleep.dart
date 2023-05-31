import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Sleep
{
  Timestamp dateTime;
  int duration;
  String note;

  Sleep({ required this.dateTime, required this.duration, required this.note});

  Sleep.fromJson(Map<String, dynamic> json)
      :
        dateTime = json['dateTime'],
        duration = json['duration'],
        note = json['note'];

  Map<String, dynamic> toJson() =>
      {
        'dateTime': dateTime,
        'duration': duration,
        'note' : note
      };
}

class SleepModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<Sleep> items = [];

  CollectionReference sleepCollection = FirebaseFirestore.instance.collection('sleeps');
  bool loading = false;

  //Normally a model would get from a database here, we are just hardcoding some data for this week
  SleepModel()
  {
    fetch();
  }

  void add(Sleep item) {
    items.add(item);
    update();
  }

  void removeAll() {
    items.clear();
    update();
  }


  Future fetch() async
  {
    //clear any existing data we have gotten previously, to avoid duplicate data
    items.clear();

    //indicate that we are loading
    loading = true;
    notifyListeners(); //tell children to redraw, and they will see that the loading indicator is on

    //get all nappies
    var querySnapshot = await sleepCollection.orderBy("dateTime", descending: true).get();

    //iterate over the movies and add them to the list
    for (var doc in querySnapshot.docs) {
      //note not using the add(Movie item) function, because we don't want to add them to the db
      var sleep = Sleep.fromJson(doc.data()! as Map<String, dynamic>);
      items.add(sleep);
    }

    //put this line in to artificially increase the load time, so we can see the loading indicator (when we add it in a few steps time)
    //comment this out when the delay becomes annoying
    await Future.delayed(const Duration(seconds: 2));

    //we're done, no longer loading
    loading = false;
    update();
  }

  //update any listeners
  // This call tells the widgets that are listening to this model to rebuild.
  void update() { notifyListeners(); }
}



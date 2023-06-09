import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../util/util.dart';

class Nappy
{
  late String id;
  Timestamp dateTime;
  bool dirty;
  String note;

  Nappy({ required this.dateTime, required this.dirty, required this.note});

  Nappy.fromJson(Map<String, dynamic> json, this.id)
      :
        dateTime = json['dateTime'],
        dirty = json['dirty'],
        note = json['note'];

  Map<String, dynamic> toJson() =>
      {
        'dateTime': dateTime,
        'dirty': dirty,
        'note' : note
      };
}

class NappyModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<Nappy> items = [];

  CollectionReference nappiesCollection = FirebaseFirestore.instance.collection('nappies');
  bool loading = false;

  //Normally a model would get from a database here, we are just hardcoding some data for this week
  NappyModel()
  {
    fetch();
  }

  Nappy? get(String? id)
  {
    if (id == null) return null;
    return items.firstWhere((nappy) => nappy.id == id);
  }

  Future add(Nappy item) async {
    loading = true;
    update();
    
    await nappiesCollection.add(item.toJson());

    await fetch();
  }

  Future updateItem(String id, Nappy item) async
  {
    loading = true;
    update();

    await nappiesCollection.doc(id).set(item.toJson());

    await fetch();
  }

  Future delete(String id) async
  {
    loading = true;
    update();

    await nappiesCollection.doc(id).delete();

    await fetch();
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
    var querySnapshot = await nappiesCollection.orderBy("dateTime", descending: true).get();

    //iterate over the movies and add them to the list
    for (var doc in querySnapshot.docs) {
      //note not using the add(Movie item) function, because we don't want to add them to the db
      var nappy = Nappy.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      items.add(nappy);
    }

    //put this line in to artificially increase the load time, so we can see the loading indicator (when we add it in a few steps time)
    //comment this out when the delay becomes annoying
    await Future.delayed(const Duration(seconds: 2));

    //we're done, no longer loading
    loading = false;
    update();
  }

  List<Nappy> filterByDate(DateTime selectedDate) {
    List<Nappy> filteredList = [];

    DateTime justDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    Timestamp filterLowerBound = toTimestamp(justDate);
    Timestamp filterUpperBound = toTimestamp(justDate.add(const Duration(days: 1)));

    for (var nappy in items) {
      if(timeStampToInt(nappy.dateTime) >= timeStampToInt(filterLowerBound) && timeStampToInt(nappy.dateTime) <= timeStampToInt(filterUpperBound))
      {
        print("yay");
        filteredList.add(nappy);
      }
    }
    return filteredList;
  }

  //update any listeners
  // This call tells the widgets that are listening to this model to rebuild.
  void update() { notifyListeners(); }
}



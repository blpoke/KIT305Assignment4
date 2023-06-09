import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../util/util.dart';

enum FeedingOption {
  left,
  right,
  bottle
}

class Feed
{
  late String id;
  Timestamp dateTime;
  int duration;
  FeedingOption feedOpt;
  String note;

  Feed({ required this.dateTime, required this.duration, required this.feedOpt, required this.note});

  Feed.fromJson(Map<String, dynamic> json, this.id)
      :
        dateTime = json['dateTime'],
        duration = json['duration'],
        feedOpt = parseFeedingOption(json['feedOpt']),
        note = json['note'];

  Map<String, dynamic> toJson() =>
      {
        'dateTime': dateTime,
        'duration': duration,
        'feedOpt': feedOpt.toString().split('.').last,
        'note' : note
      };
}

FeedingOption parseFeedingOption(String option) {
  switch (option) {
    case 'left':
      return FeedingOption.left;
    case 'right':
      return FeedingOption.right;
    case 'bottle':
      return FeedingOption.bottle;
    default:
      throw ArgumentError('Invalid FeedingOption: $option');
  }
}

class FeedModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<Feed> items = [];

  CollectionReference feedsCollection = FirebaseFirestore.instance.collection('feeds');
  bool loading = false;

  //Normally a model would get from a database here, we are just hardcoding some data for this week
  FeedModel()
  {
    fetch();
  }

  Feed? get(String? id)
  {
    if (id == null) return null;
    return items.firstWhere((feed) => feed.id == id);
  }

  Future add(Feed item) async {
    loading = true;
    update();

    await feedsCollection.add(item.toJson());

    //refresh the db
    await fetch();
  }

  Future delete(String id) async
  {
    loading = true;
    update();

    await feedsCollection.doc(id).delete();

    await fetch();
  }

  Future updateItem(String id, Feed item) async {
    loading = true;
    update();

    await feedsCollection.doc(id).set(item.toJson());

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
    var querySnapshot = await feedsCollection.orderBy("dateTime", descending: true).get();

    //iterate over the movies and add them to the list
    for (var doc in querySnapshot.docs) {
      //note not using the add(Movie item) function, because we don't want to add them to the db
      var feed = Feed.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      items.add(feed);
    }

    //put this line in to artificially increase the load time, so we can see the loading indicator (when we add it in a few steps time)
    //comment this out when the delay becomes annoying
    await Future.delayed(const Duration(seconds: 2));

    //we're done, no longer loading
    loading = false;
    update();
  }

  List<Feed> filterByDate(DateTime selectedDate) {
    List<Feed> filteredList = [];

    DateTime justDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    Timestamp filterLowerBound = toTimestamp(justDate);
    Timestamp filterUpperBound = toTimestamp(justDate.add(const Duration(days: 1)));

    for (var feed in items) {
      if(timeStampToInt(feed.dateTime) >= timeStampToInt(filterLowerBound) && timeStampToInt(feed.dateTime) <= timeStampToInt(filterUpperBound))
      {
        print("yay");
        filteredList.add(feed);
      }
    }
    return filteredList;
  }

  //update any listeners
  // This call tells the widgets that are listening to this model to rebuild.
  void update() { notifyListeners(); }
}



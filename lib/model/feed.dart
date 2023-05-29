import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Feed
{
  Timestamp dateTime;
  bool dirty;
  String note;

  Feed({ required this.dateTime, required this.dirty, required this.note});

  Feed.fromJson(Map<String, dynamic> json)
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

class FeedModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<Feed> items = [];

  CollectionReference feedsCollection = FirebaseFirestore.instance.collection('nappies');
  bool loading = false;

  //Normally a model would get from a database here, we are just hardcoding some data for this week
  FeedModel()
  {
    fetch();
  }

  void add(Feed item) {
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
    var querySnapshot = await feedsCollection.orderBy("dateTime").get();

    //iterate over the movies and add them to the list
    for (var doc in querySnapshot.docs) {
      //note not using the add(Movie item) function, because we don't want to add them to the db
      var feed = Feed.fromJson(doc.data()! as Map<String, dynamic>);
      items.add(feed);
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



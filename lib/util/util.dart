import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../model/feed.dart';
import '../model/nappy.dart';
import '../model/sleep.dart';

String formatTimestamp(Timestamp t)
{
  DateTime dateTime = t.toDate();
  DateFormat formatter = DateFormat('MMMM d, y - HH:mm'); // Choose your desired date format
  String formattedDate = formatter.format(dateTime);

  return formattedDate;
}

String formatDateTime(DateTime d)
{
  DateFormat formatter = DateFormat('MMMM d, y - HH:mm'); // Choose your desired date format
  String formattedDate = formatter.format(d);

  return formattedDate;
}

String formatDate(DateTime d)
{
  DateFormat formatter = DateFormat('MMMM d, y'); // Choose your desired date format
  String formattedDate = formatter.format(d);

  return formattedDate;
}

String capitalizeEnumString(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

Timestamp toTimestamp(DateTime d) {
  return Timestamp.fromMillisecondsSinceEpoch(d.millisecondsSinceEpoch);
}

int timeStampToInt(Timestamp t){
  return t.millisecondsSinceEpoch;
}

int countWet(List<Nappy> n) {
  int count = 0;

  for (var i in n) {
    if (i.dirty != true) {
      count++;
    }
  }

  return count;
}

int countDirty(List<Nappy> n) {
  int count = 0;

  for (var i in n) {
    if (i.dirty == true) {
      count++;
    }
  }

  return count;
}

int totalSleep(List<Sleep> s) {
  int total = 0;

  for (var i in s) {
    total = total + i.duration;
  }

  return total;
}

int totalLeft(List<Feed> f) {
  int total = 0;

  for (var i in f) {
    if(i.feedOpt == FeedingOption.left){
      total = total + i.duration;
    }
  }
  return total;
}

int totalRight(List<Feed> f) {
  int total = 0;

  for (var i in f) {
    if(i.feedOpt == FeedingOption.right){
      total = total + i.duration;
    }
  }
  return total;
}
int totalBottle(List<Feed> f) {
  int total = 0;

  for (var i in f) {
    if(i.feedOpt == FeedingOption.bottle){
      total = total + i.duration;
    }
  }
  return total;
}

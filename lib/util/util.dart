import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp t)
{
  DateTime dateTime = t.toDate();
  DateFormat formatter = DateFormat('MMMM d, y - HH:mm'); // Choose your desired date format
  String formattedDate = formatter.format(dateTime);

  return formattedDate;
}

String FormatDate(DateTime d)
{
  DateFormat formatter = DateFormat('MMMM d, y - HH:mm'); // Choose your desired date format
  String formattedDate = formatter.format(d);

  return formattedDate;
}

String capitalizeEnumString(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
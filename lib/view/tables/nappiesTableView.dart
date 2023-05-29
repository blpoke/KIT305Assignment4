import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kit305_assignment_4/model/nappy.dart';

class NappiesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var nappyModel = Provider.of<NappyModel>(context);

    return ListView.builder(
      itemBuilder: (_, index) {
        var nappy = nappyModel.items[index];
        return ListTile(
          title: Text(nappy.dateTime.toString()),
          subtitle: Text(nappy.dirty.toString()),
        );
      },
      itemCount: nappyModel.items.length,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:kit305_assignment_4/view/details/nappyDetailsView.dart';
import 'package:provider/provider.dart';
import 'package:kit305_assignment_4/model/nappy.dart';

import '../../util/util.dart';

class NappiesListView extends StatelessWidget {
  const NappiesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nappyModel = Provider.of<NappyModel>(context);

    if (nappyModel.loading)
    {
      return const Center(
          child:CircularProgressIndicator()
      );
    }
    else {
      return ListView.builder(
        itemBuilder: (_, index) {
          var nappy = nappyModel.items[index];
          return Dismissible(
            key: ValueKey(nappy.id),
            background: Container (
                color: Colors.red
            ),
            child: ListTile(
              title: Text(formatTimestamp(nappy.dateTime)),
              subtitle: Text(nappy.dirty ? 'Dirty' : 'Wet'),

              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NappyDetails(id: nappy.id);
                }));
              },
            ),
            onDismissed: (direction) {
              nappyModel.delete(nappy.id);
            },
          );
        },
        itemCount: nappyModel.items.length,
      );
    }
  }
}
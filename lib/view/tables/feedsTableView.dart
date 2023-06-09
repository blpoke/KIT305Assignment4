import 'package:flutter/material.dart';
import 'package:kit305_assignment_4/model/feed.dart';
import 'package:kit305_assignment_4/util/util.dart';
import 'package:kit305_assignment_4/view/details/feedDetailsView.dart';
import 'package:provider/provider.dart';

class FeedsListView extends StatelessWidget {
  const FeedsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var feedModel = Provider.of<FeedModel>(context);

    if (feedModel.loading)
    {
      return const Center(
          child:CircularProgressIndicator()
      );
    }
    else
    {
      return ListView.builder(
        itemBuilder: (_, index) {
          var feed = feedModel.items[index];
          return Dismissible(
              key: ValueKey(feed.id),
              background: Container(
                  color: Colors.red
              ),
              child: ListTile(
                  title: Text(formatTimestamp(feed.dateTime)),
                  subtitle: Text(capitalizeEnumString(feed.feedOpt.toString().split('.').last)),

                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return FeedDetails(id: feed.id);
                    }));
                  }
              ),
            onDismissed: (direction) {
              feedModel.delete(feed.id);
            } ,
          ) ;
        },
        itemCount: feedModel.items.length,
      );
    }
  }
}
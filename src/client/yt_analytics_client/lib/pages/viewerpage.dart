import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/components/filterselection.dart';
import 'package:yt_analytics_client/components/searchresults.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';

class ViewerPage extends StatelessWidget {
  const ViewerPage();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const FilterSelection(),
        const SizedBox(height: 40),
        Flexible(
          child: Consumer<EntityManager>(
            builder: (context, model, child) {
              return SearchResults(
                results: model.entities ?? Future<List<Entity>>(() => null),
              );
            },
          ),
        ),
      ],
    );
  }
}

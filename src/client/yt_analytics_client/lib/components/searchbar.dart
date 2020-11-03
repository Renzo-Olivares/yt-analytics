import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/components/filterselection.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';
import 'package:yt_analytics_client/models/filtermanager.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: TextField(
            controller: _searchBarController,
            decoration: const InputDecoration(
              filled: true,
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              labelText: 'Search by video name',
            ),
          ),
        ),
        Consumer<FilterManager>(
          builder: (context, model, child) {
            return IconButton(
              onPressed: () {
                if (filterFormKey.currentState == null ||
                    filterFormKey.currentState.validate()) {
                  Provider.of<EntityManager>(context, listen: false)
                      .loadFilteredEntities(
                    model.category,
                    (!model.commentsDisabled).toString(),
                    _searchBarController.text,
                    model.views,
                    model.likes,
                    model.dislikes,
                    model.channelName,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please check all fields and try again',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.search_outlined),
              color: Colors.grey,
            );
          },
        ),
      ],
    );
  }
}

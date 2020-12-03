import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/components/filterselection.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';
import 'package:yt_analytics_client/models/filtermanager.dart';
import 'package:yt_analytics_client/models/routemanager.dart';

class SearchBar extends StatefulWidget {
  const SearchBar();

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteManager>(
      builder: (context, routemodel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: TextField(
                controller: _searchBarController,
                enabled: routemodel.route == 'About' ? false : true,
                onChanged: (value) {
                  Provider.of<FilterManager>(context, listen: false).videoName =
                      value;
                },
                decoration: InputDecoration(
                  filled: true,
                  enabled: routemodel.route == 'About' ? false : true,
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(),
                  labelText: 'Search by video name',
                ),
              ),
            ),
            Consumer<FilterManager>(
              builder: (context, model, child) {
                return IconButton(
                  onPressed: () {
                    if (Provider.of<RouteManager>(context, listen: false)
                            .route ==
                        'About') {
                      return null;
                    }
                    if (filterFormKey.currentState == null ||
                        filterFormKey.currentState.validate()) {
                      if (Provider.of<RouteManager>(context, listen: false)
                              .route ==
                          'Analytics') {
                        print('analytics');
                        Provider.of<EntityManager>(context, listen: false)
                            .loadFilteredAnalytics(
                          model.category,
                          (!model.commentsDisabled).toString(),
                          _searchBarController.text,
                          model.views,
                          model.likes,
                          model.dislikes,
                          model.channelName,
                        );
                        Provider.of<EntityManager>(context, listen: false)
                            .setTopTrendingN(model.trendingN);
                        Provider.of<EntityManager>(context, listen: false)
                            .setTrendingNDays(model.numofdays);
                      } else if (Provider.of<RouteManager>(context,
                                  listen: false)
                              .route ==
                          'Viewer') {
                        print('viewer');
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
                      }
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
      },
    );
  }
}

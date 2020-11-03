import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/components/filterselection.dart';
import 'package:yt_analytics_client/components/searchbar.dart';
import 'package:yt_analytics_client/components/searchresults.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/icon.png', width: 48),
            const Icon(
              Icons.analytics_outlined,
              color: Colors.black,
            ),
          ],
        ),
        elevation: 0,
        title: SearchBar(),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.table_chart_outlined),
                label: Text('Viewer'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics_outlined),
                label: Text('Stats'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                label: Text('About'),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const FilterSelection(),
                const SizedBox(height: 40),
                Flexible(
                  child: Consumer<EntityManager>(
                    builder: (context, model, child) {
                      return SearchResults(
                        results:
                            model.entities ?? Future<List<Entity>>(() => null),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

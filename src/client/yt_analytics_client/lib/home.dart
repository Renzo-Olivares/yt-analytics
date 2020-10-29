import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/components/filterselection.dart';
import 'package:yt_analytics_client/components/searchbar.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';
import 'package:yt_analytics_client/searchresults.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/icon.png', width: 48),
            Icon(
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
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
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
                SizedBox(height: 20),
                FilterSelection(),
                SizedBox(height: 40),
                Consumer<EntityManager>(
                  builder: (context, model, child) {
                    return SearchResults(
                      mockModel: model.entities,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

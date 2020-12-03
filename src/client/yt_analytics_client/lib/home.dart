import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/components/searchbar.dart';
import 'package:yt_analytics_client/models/filtermanager.dart';
import 'package:yt_analytics_client/models/routemanager.dart';
import 'package:yt_analytics_client/pages/aboutpage.dart';
import 'package:yt_analytics_client/pages/analyticspage.dart';
import 'package:yt_analytics_client/pages/viewerpage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final _pages = [
    const ViewerPage(),
    const AnalyticsPage(),
    const AboutPage(),
  ];

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
        elevation: 2,
        title: const SearchBar(),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            labelType: NavigationRailLabelType.all,
            onDestinationSelected: (index) {
              if (_selectedIndex != index) {
                Provider.of<FilterManager>(context, listen: false)
                    .resetFilters();
              }

              switch (index) {
                case 0:
                  Provider.of<RouteManager>(context, listen: false).route =
                      'Viewer';
                  break;
                case 1:
                  Provider.of<RouteManager>(context, listen: false).route =
                      'Analytics';
                  break;
                case 2:
                  Provider.of<RouteManager>(context, listen: false).route =
                      'About';
                  break;
                default:
                  break;
              }

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
                label: Text('Analytics'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                label: Text('About'),
              ),
            ],
          ),
          Expanded(
            child: _PageSwitcher(
              currentScreen: _pages.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageSwitcher extends StatelessWidget {
  const _PageSwitcher({this.currentScreen});
  final Widget currentScreen;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      child: currentScreen,
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
        );
      },
    );
  }
}

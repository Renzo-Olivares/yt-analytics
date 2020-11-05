import 'package:flutter/material.dart';

class RouteManager with ChangeNotifier {
  String _route = 'Viewer';

  String get route => _route;

  set route(String newRoute) {
    _route = newRoute;
    notifyListeners();
  }
}

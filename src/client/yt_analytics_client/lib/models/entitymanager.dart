import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/services/apiservice.dart';

class EntityManager with ChangeNotifier {
  Future<List<Entity>> _entities;

  Future<List<Entity>> get entities => _entities;

  final ApiService api = ApiService();

  void loadFilteredEntities(
    String category,
    String commentsDisabled,
    String videoName,
    String views,
    String likes,
    String dislikes,
    String channelName,
  ) {
    if ((category == '' || category == 'None') &&
        commentsDisabled == 'null' &&
        videoName == '' &&
        views == '' &&
        likes == '' &&
        dislikes == '' &&
        channelName == '') {
      loadAllEntities();
      notifyListeners();
      return;
    }

    _entities = api.getFilteredEntities(
      category: category,
      commentsDisabled: commentsDisabled,
      videoName: videoName,
      views: views,
      likes: likes,
      dislikes: dislikes,
      channelName: channelName,
    );

    notifyListeners();
  }

  void loadAllEntities() {
    _entities = api.getAllEntities();
    notifyListeners();
  }

  void deleteSelected() {
    _entities.then((entities) {
      for (final entity in entities) {
        if (entity.selected) {
          entities.remove(entity);
        }
      }
    });

    notifyListeners();
  }

  void addEntity(Entity entity) {
    _entities.then((entities) => entities.add(entity));
    notifyListeners();
  }
}

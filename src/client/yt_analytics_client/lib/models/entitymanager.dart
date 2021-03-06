import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/trendingchartdata.dart';
import 'package:yt_analytics_client/services/apiservice.dart';

class EntityManager with ChangeNotifier {
  Future<List<Entity>> _entities;

  Future<List<Entity>> get entities => _entities;

  Future<List<Entity>> _topTrendingN;
  Future<List<Entity>> _trendingNDays;

  Future<List<Entity>> get topTrendingN => _topTrendingN;
  Future<List<Entity>> get trendingNDays => _trendingNDays;

  void setTopTrendingN(String n) {
    _topTrendingN = api.getTopTrendingN(n);
    notifyListeners();
  }

  void setTrendingNDays(String n) {
    _trendingNDays = api.getTrendingNDays(n);
    notifyListeners();
  }

  Future<List<TrendingChartData>> _trendingCategories;
  Future<List<TrendingChartData>> _trendingChannels;
  Future<List<TrendingChartData>> _avgTagsCategories;

  Future<List<TrendingChartData>> get trendingCategories => _trendingCategories;
  Future<List<TrendingChartData>> get trendingChannels => _trendingChannels;
  Future<List<TrendingChartData>> get avgTagsCategories => _avgTagsCategories;

  int _selectedCount = 0;

  // ignore: unnecessary_getters_setters
  set selectedCount(int value) {
    _selectedCount = value;
  }

  // ignore: unnecessary_getters_setters
  int get selectedCount => _selectedCount;

  Future<Entity> get currentSelected => _entities.then(
        (entities) {
          for (final entity in entities) {
            if (entity.selected) {
              return entity;
            }
          }
          return null;
        },
      );

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
      minViews: views,
      minLikes: likes,
      minDislikes: dislikes,
      channelName: channelName,
    );

    notifyListeners();
  }

  void loadTrendingChannelsAnalytics(
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
      _trendingChannels = api.getFilteredAnalytics(
        category: '',
        commentsDisabled: '',
        videoName: '',
        views: '',
        likes: '',
        dislikes: '',
        channelName: '',
        type: 'Channels',
      );
    } else {
      _trendingChannels = api.getFilteredAnalytics(
        category: category,
        commentsDisabled: commentsDisabled,
        videoName: videoName,
        views: views,
        likes: likes,
        dislikes: dislikes,
        channelName: channelName,
        type: 'Channels',
      );
    }
    notifyListeners();
  }

  void loadTrendingCategoriesAnalytics(
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
      _trendingCategories = api.getFilteredAnalytics(
        category: '',
        commentsDisabled: '',
        videoName: '',
        views: '',
        likes: '',
        dislikes: '',
        channelName: '',
        type: 'Categories',
      );
    } else {
      _trendingCategories = api.getFilteredAnalytics(
        category: category,
        commentsDisabled: commentsDisabled,
        videoName: videoName,
        views: views,
        likes: likes,
        dislikes: dislikes,
        channelName: channelName,
        type: 'Categories',
      );
    }
    notifyListeners();
  }

  void loadAvgTagsCategoriesAnalytics(
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
      _avgTagsCategories = api.getFilteredAnalytics(
        category: '',
        commentsDisabled: '',
        videoName: '',
        views: '',
        likes: '',
        dislikes: '',
        channelName: '',
        type: 'Tags',
      );
    } else {
      _avgTagsCategories = api.getFilteredAnalytics(
        category: category,
        commentsDisabled: commentsDisabled,
        videoName: videoName,
        views: views,
        likes: likes,
        dislikes: dislikes,
        channelName: channelName,
        type: 'Tags',
      );
    }
    notifyListeners();
  }

  void loadFilteredAnalytics(
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
      loadAllAnalytics();
      notifyListeners();
      return;
    }

    _trendingChannels = api.getFilteredAnalytics(
      category: category,
      commentsDisabled: commentsDisabled,
      videoName: videoName,
      views: views,
      likes: likes,
      dislikes: dislikes,
      channelName: channelName,
      type: 'Channels',
    );

    _trendingCategories = api.getFilteredAnalytics(
      category: category,
      commentsDisabled: commentsDisabled,
      videoName: videoName,
      views: views,
      likes: likes,
      dislikes: dislikes,
      channelName: channelName,
      type: 'Categories',
    );

    _avgTagsCategories = api.getFilteredAnalytics(
      category: category,
      commentsDisabled: commentsDisabled,
      videoName: videoName,
      views: views,
      likes: likes,
      dislikes: dislikes,
      channelName: channelName,
      type: 'Tags',
    );

    notifyListeners();
  }

  void loadAllAnalytics() {
    _trendingChannels = api.getFilteredAnalytics(
      category: '',
      commentsDisabled: '',
      videoName: '',
      views: '',
      likes: '',
      dislikes: '',
      channelName: '',
      type: 'Channels',
    );

    _trendingCategories = api.getFilteredAnalytics(
      category: '',
      commentsDisabled: '',
      videoName: '',
      views: '',
      likes: '',
      dislikes: '',
      channelName: '',
      type: 'Categories',
    );

    _avgTagsCategories = api.getFilteredAnalytics(
      category: '',
      commentsDisabled: '',
      videoName: '',
      views: '',
      likes: '',
      dislikes: '',
      channelName: '',
      type: 'Tags',
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
          api.deleteEntity(entity.videoID, entity.views.toString());
        }
      }
    });

    notifyListeners();
  }

  void addEntity(Entity entity) {
    api.addNewEntity(entity);
    _entities.then((entities) => entities.add(entity));
    notifyListeners();
  }

  void updateEntity(String views, String likes, String dislikes) {
    _entities.then((entities) {
      for (var entity in entities) {
        if (entity.selected) {
          final oldViews = entity.views.toString();
          entity.likes = int.parse(likes);
          entity.dislikes = int.parse(dislikes);
          entity.views = int.parse(views);
          print(entities.length);
          entities[entities.indexOf(entity)] = entity;
          print(entities.length);
          print(entity.videoID);
          api.updateEntity(entity.videoID, oldViews, views, likes, dislikes);
          return;
        }
      }
    });
    notifyListeners();
  }

  void backupData(String filePath) {
    api.backup(filePath);
  }

  void restoreData(String filePath) {
    api.restore(filePath);
    notifyListeners();
  }
}

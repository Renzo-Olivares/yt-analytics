import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/trendingchartdata.dart';

class ApiService {
  final String apiUrl = 'user:pass@localhost:8080';

  Future<List<Entity>> getAllEntities() async {
    print('fetching all data');
    final uri = Uri.http(apiUrl, 'ytanalytics/entities');

    final response = await http.get(uri);

    print('all data fetched');
    final entities = <Entity>[];

    if (response.statusCode == 200) {
      print('response for all data fetch is okay');
      final responseJson = jsonDecode(response.body) as List<dynamic>;

      for (var response in responseJson) {
        entities.add(Entity.fromJson(response as Map<String, dynamic>));
      }

      return entities;
    } else {
      print('response for all data fetch not okay');
      throw Exception('Failed to load all server data');
    }
  }

  Future<List<Entity>> getFilteredEntities({
    String category = '',
    String commentsDisabled = '',
    String videoName = '',
    String views = '',
    String likes = '',
    String dislikes = '',
    String channelName = '',
  }) async {
    print('fetching filtered data');

    final uri = Uri.http(
      apiUrl,
      'ytanalytics/entitiesFiltered/'
      'channel/{$channelName}/'
      'category/{$category}/'
      'commentsDisabled/{$commentsDisabled}/'
      'videoName/{$videoName}/'
      'views/{$views}/'
      'likes/{$likes}/'
      'dislikes/{$dislikes}',
    );

    final response = await http.get(uri);

    print('filtered data fetched');
    final entities = <Entity>[];

    if (response.statusCode == 200) {
      print('response for filtered data request is okay');
      final responseJson = jsonDecode(response.body) as List<dynamic>;

      for (var response in responseJson) {
        entities.add(Entity.fromJson(response as Map<String, dynamic>));
      }

      return entities;
    } else {
      print('response for filtered data request not okay');
      throw Exception('Failed to load filtered server data');
    }
  }

  Future<List<TrendingChartData>> getFilteredAnalytics({
    String category = '',
    String commentsDisabled = '',
    String videoName = '',
    String views = '',
    String likes = '',
    String dislikes = '',
    String channelName = '',
    String type = '',
  }) async {
    print('fetching filtered analytics');

    final uri = Uri.http(
      apiUrl,
      'ytanalytics/analyticsFiltered/'
      'channel/{$channelName}/'
      'category/{$category}/'
      'commentsDisabled/{$commentsDisabled}/'
      'videoName/{$videoName}/'
      'views/{$views}/'
      'likes/{$likes}/'
      'dislikes/{$dislikes}/'
      'type/$type',
    );

    final response = await http.get(uri);

    print('filtered analytics fetched');
    final entities = <TrendingChartData>[];

    if (response.statusCode == 200) {
      print('response for filtered analytics request is okay');
      final responseJson = jsonDecode(response.body) as List<dynamic>;

      for (var response in responseJson) {
        entities
            .add(TrendingChartData.fromJson(response as Map<String, dynamic>));
      }

      return entities;
    } else {
      print('response for filtered analytics request not okay');
      throw Exception('Failed to load filtered server analytics');
    }
  }

  Future<void> addNewEntity(Entity entity) async {
    print('adding new entity');

    final uri = Uri.http(
      apiUrl,
      'ytanalytics/insert/'
      'videoID/{${entity.videoID}}/'
      'trendingDate/{${entity.trendingDate}}/'
      'title/{"${entity.title}"}/'
      'channelTitle/{"${entity.channelTitle}"}/'
      'category/{${entity.category}}/'
      'publishTime/{${entity.publishTime}}/'
      'tags/{${entity.tags}}/'
      'views/{${entity.views.toString()}}/'
      'likes/{${entity.likes.toString()}}/'
      'dislikes/{${entity.dislikes.toString()}}/'
      'comments/{${entity.commentCount.toString()}}/'
      'thumbnailLink/{${entity.thumbnailLink}}/'
      'commentsDisabled/{${entity.commentsDisabled.toString()}}/'
      'ratingsDisabled/{${entity.ratingsDisabled.toString()}}/'
      'videoErrorOrRemoved/{${entity.videoErrorOrRemoved.toString()}}/'
      'description/{"${entity.description}"}',
    );

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('New entity added response okay');
    } else {
      throw Exception('Failed to insert new entity');
    }
  }

  Future<void> deleteEntity(String videoID, String views) async {
    print('deleting entity');

    final uri = Uri.http(
      apiUrl,
      'ytanalytics/remove/'
      'videoID/{$videoID}/'
      'views/{$views}',
    );

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('data deleted successfully');
    } else {
      throw Exception('Failed to delete data');
    }
  }

  Future<void> updateEntity(
    String videoID,
    String oldViews,
    String views,
    String likes,
    String dislikes,
  ) async {
    print('updating entity');

    final uri = Uri.http(
      apiUrl,
      'ytanalytics/'
      'update/{$videoID}/'
      'oldViews/{$oldViews}/'
      'views/{$views}/'
      'likes/{$likes}/'
      'dislikes/{$dislikes}',
    );

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('data updated successfully');
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> restore(String filePath) async {
    print('restoring data from $filePath');

    final uri = Uri.http(apiUrl, 'ytanalytics/restore/{$filePath}');

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('data successfully restored');
    } else {
      throw Exception('Failed to restore data');
    }
  }

  Future<void> backup(String filePath) async {
    print('backing up data to $filePath');
    final uri = Uri.http(apiUrl, 'ytanalytics/backup/{$filePath}');

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('data successfully backed up');
    } else {
      throw Exception('Failed to backup data');
    }
  }
}

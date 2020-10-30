import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yt_analytics_client/models/entity.dart';

class ApiService {
  final String apiUrl = 'user:pass@localhost:8080';

  Future<List<Entity>> getAllEntities() async {
    print('fetching server info');
    final uri = Uri.http(apiUrl, 'ytanalytics/entities');

    final response = await http.get(uri);

    print('server info fetched');
    final List<Entity> entities = [];

    if (response.statusCode == 200) {
      print('response good');
      List<dynamic> responseJson = jsonDecode(response.body);

      print('Mock data received from server: ${responseJson[0]}');

      for (var response in responseJson) {
        entities.add(Entity.fromJson(response));
      }

      return entities;
    } else {
      print('response not good');
      throw Exception('Failed to load server data');
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
    print('fetching server info');

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

    print('server info fetched');
    final List<Entity> entities = [];

    if (response.statusCode == 200) {
      print('response good');
      List<dynamic> responseJson = jsonDecode(response.body);

      print('Mock data received from server: ${responseJson[0]}');

      for (var response in responseJson) {
        entities.add(Entity.fromJson(response));
      }

      return entities;
    } else {
      print('response not good');
      throw Exception('Failed to load server data');
    }
  }

  Future<void> addNewEntity(Entity entity) async {
    final uri = Uri.http(
      apiUrl,
      'ytanalytics/insert/'
      'videoID/{${entity.videoID}}/'
      'trendingDate/{${entity.trendingDate}}/'
      'title/{${entity.title}}/'
      'channelTitle/{${entity.channelTitle}}/'
      'category/{${entity.category}}/'
      'publishTime/{${entity.publishTime}}/'
      'tags/{${''}}/'
      'views/{${entity.views.toString()}}/'
      'likes/{${entity.likes.toString()}}/'
      'dislikes/{${entity.dislikes.toString()}}/'
      'comments/{${entity.commentCount.toString()}}/'
      'thumbnailLink/{${entity.thumbnailLink}}/'
      'commentsDisabled/{${entity.commentsDisabled.toString()}}/'
      'ratingsDisabled/{${entity.ratingsDisabled.toString()}}/'
      'videoErrorOrRemoved/{${entity.videoErrorOrRemoved.toString()}}/'
      'description/{${entity.description}}',
    );

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('data inserted');
      //TODO: Success snackbar?
    } else {
      throw Exception('Failed to insert data');
    }
  }

  Future<void> deleteEntity(String videoID) async {
    final uri = Uri.http(
      apiUrl,
      'ytanalytics/remove/{$videoID}',
    );

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('data deleted');
      //TODO: Success snackbar?
    } else {
      throw Exception('Failed to delete data');
    }
  }

  Future<void> updateEntity(String videoID, String oldViews, String views,
      String likes, String dislikes) async {
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
      print('data updated');
      //TODO: Success snackbar?
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<void> restore(String filePath) async {
    print(filePath);
    final uri = Uri.http(apiUrl, 'ytanalytics/restore/{$filePath}');

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('data restored');
      //TODO: Success snackbar?
    } else {
      throw Exception('Failed to restore data');
    }
  }

  Future<void> backup(String filePath) async {
    print(filePath);
    final uri = Uri.http(apiUrl, 'ytanalytics/backup/{$filePath}');

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('data backed up');
      //TODO: Success snackbar?
    } else {
      throw Exception('Failed to backup data');
    }
  }
}

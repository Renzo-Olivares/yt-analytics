import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yt_analytics_client/models/entity.dart';

class EntityService {
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
}

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yt_analytics_client/models/mockmodel.dart';

Future<MockModel> fetchServerInfo() async {
  print('fetching server info');
  final response = await http.get("http://localhost:8080/demo/test/");

  print('server info fetched');

  if (response.statusCode == 200) {
    print('response good');
    List<String> responseJson =
        (json.decode(response.body) as List<dynamic>).cast<String>();
    print('Mock data received from server: $responseJson');

    return MockModel(mockData: responseJson);
  } else {
    print('response not good');
    throw Exception('Failed to load server data');
  }
}

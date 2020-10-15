import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yt_analytics_client/mockservice.dart';
import 'package:yt_analytics_client/models/mockmodel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Future<MockModel> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchServerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                label: Text('Demo'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                label: Text('About'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: MockPage(
                    mockModel: futureData,
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

class MockPage extends StatelessWidget {
  MockPage({this.mockModel});

  final _addEntryController = TextEditingController();
  final Future<MockModel> mockModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FutureBuilder(
            future: this.mockModel,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: (snapshot.data).mockData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text('${snapshot.data.mockData[index]}'),
                        );
                      },
                    );
                  }
              }
            },
          ),
        ),
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: _addEntryController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Enter a new youtube channel',
                ),
              ),
              OutlinedButton(
                child: Text('Add entry'),
                onPressed: () => addData(_addEntryController.text),
                style: OutlinedButton.styleFrom(elevation: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<http.Response> addData(String data) {
    return http.post(
      "http://localhost:8080/demo/add/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        data: data,
      }),
    );
  }
}

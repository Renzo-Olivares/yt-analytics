import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yt_analytics_client/components/filter_selection.dart';
import 'package:yt_analytics_client/components/searchbar.dart';
import 'package:yt_analytics_client/models/mockmodel.dart';
import 'package:yt_analytics_client/services/mockservice.dart';

typedef onDataUpdate = void Function();

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

  void _updateData() {
    setState(() {
      futureData = fetchServerInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    onDataUpdate updateData = _updateData;

    return Scaffold(
      appBar: AppBar(
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
                // Expanded(
                //   child: MockPage(
                //     mockModel: futureData,
                //     updater: updateData,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MockPage extends StatefulWidget {
  MockPage({this.mockModel, this.updater});

  final Future<MockModel> mockModel;
  final onDataUpdate updater;

  @override
  _MockPageState createState() => _MockPageState();
}

class _MockPageState extends State<MockPage> {
  final _addEntryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FutureBuilder(
            future: this.widget.mockModel,
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
                onPressed: () {
                  addData(_addEntryController.text);
                  widget.updater();
                },
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
        'New entry': data,
      }),
    );
  }
}

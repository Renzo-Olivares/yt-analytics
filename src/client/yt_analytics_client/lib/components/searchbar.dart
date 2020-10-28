import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchBarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: TextField(
            controller: _searchBarController,
            decoration: InputDecoration(
              filled: true,
              labelStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              labelText: 'Search analytics',
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
          color: Colors.grey,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add),
          color: Colors.grey,
        ),
      ],
    );
  }
}

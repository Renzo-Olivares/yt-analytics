import 'package:flutter/material.dart';

class FilterSelection extends StatefulWidget {
  @override
  _FilterSelectionState createState() => _FilterSelectionState();
}

class _FilterSelectionState extends State<FilterSelection> {
  DateTime _currentDate = DateTime.now();

  final _tagsController = TextEditingController();
  final _viewsController = TextEditingController();
  final _likesController = TextEditingController();
  final _dislikesController = TextEditingController();
  final _commentsController = TextEditingController();
  final _channelController = TextEditingController();

  bool commentsToggle = false;

  Future<void> _showDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null && selectedDate != _currentDate) {
      setState(() {
        _currentDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.filter_list_outlined),
      title: Text(
        'FILTER',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: SizedBox(),
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 40,
            end: 40,
            top: 16,
            bottom: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FilterColumn(
                title: 'STATS',
                filters: Column(
                  children: [
                    SizedBox(height: 32),
                    _FilterInput(
                      controller: _viewsController,
                      hint: 'More than x views',
                    ),
                    SizedBox(height: 16),
                    _FilterInput(
                      controller: _likesController,
                      hint: 'More than x likes',
                    ),
                    SizedBox(height: 16),
                    _FilterInput(
                      controller: _dislikesController,
                      hint: 'More than x dislikes',
                    ),
                    SizedBox(height: 16),
                    _FilterInput(
                      controller: _commentsController,
                      hint: 'More than x comments',
                    ),
                  ],
                ),
              ),
              _FilterColumn(
                title: 'DATES',
                filters: Column(
                  children: [
                    SizedBox(height: 32),
                    ElevatedButton(
                      child: Text('Trending Date'),
                      onPressed: () {
                        _showDatePicker(context);
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      child: Text('Publish Date'),
                      onPressed: () {
                        _showDatePicker(context);
                      },
                    ),
                  ],
                ),
              ),
              _FilterColumn(
                title: 'TAGS',
                filters: Column(
                  children: [
                    SizedBox(height: 32),
                    _FilterInput(
                      controller: _tagsController,
                      hint: 'Video Tags',
                    ),
                  ],
                ),
              ),
              _FilterColumn(
                title: 'VIDEO PROPERTIES',
                filters: Column(
                  children: [
                    SizedBox(height: 32),
                    Row(children: [
                      Switch(
                        value: commentsToggle,
                        onChanged: (value) {
                          setState(() {
                            commentsToggle = value;
                          });
                        },
                      ),
                      Text(
                        'Comments ${commentsToggle ? 'Enabled' : 'Disabled'}',
                      )
                    ]),
                    SizedBox(height: 16),
                    _FilterInput(
                      controller: _channelController,
                      hint: 'Channel Name',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 1,
      width: 200,
    );
  }
}

class _FilterInput extends StatelessWidget {
  const _FilterInput({this.controller, this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200, maxHeight: 50),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(),
          labelText: hint,
        ),
      ),
    );
  }
}

class _FilterColumn extends StatelessWidget {
  const _FilterColumn({this.title, this.filters});
  final String title;
  final Widget filters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.bold),
        ),
        _Divider(),
        filters,
      ],
    );
  }
}

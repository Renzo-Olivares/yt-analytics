import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/constants.dart' as Constants;
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';

class InsertForm extends StatefulWidget {
  @override
  _InsertFormState createState() => _InsertFormState();
}

class _InsertFormState extends State<InsertForm> {
  DateTime _trendingDate = DateTime.now();
  DateTime _publishedDate = DateTime.now();
  final _viewsController = TextEditingController();
  final _likesController = TextEditingController();
  final _commentsController = TextEditingController();
  final _dislikesController = TextEditingController();
  final _channelController = TextEditingController();
  final _videoNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailLinkController = TextEditingController();
  final _videoIDController = TextEditingController();
  String _selectedCategory;
  bool commentsToggle = false;
  bool ratingsToggle = false;
  bool videoErrorOrRemovedToggle = false;

  Future<void> _showTrendingDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _trendingDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null && selectedDate != _trendingDate) {
      setState(() {
        _trendingDate = selectedDate;
      });
    }
  }

  Future<void> _showPublishedDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _publishedDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null && selectedDate != _publishedDate) {
      setState(() {
        _publishedDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create a New Trending Entry',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _videoIDController,
            hint: 'Video ID',
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            hint: Text('Category'),
            value: _selectedCategory,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            items: Constants.categories.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _videoNameController,
            hint: 'Video Name',
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _channelController,
            hint: 'Channel Name',
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _descriptionController,
            hint: 'Video Description',
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _thumbnailLinkController,
            hint: 'Thumbnail Link',
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _viewsController,
            hint: '# of Views',
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _likesController,
            hint: '# of Likes',
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _dislikesController,
            hint: '# of Dislikes',
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _commentsController,
            hint: '# of Comments',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text('Trending Date'),
            onPressed: () {
              _showTrendingDatePicker(context);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text('Publish Date'),
            onPressed: () {
              _showPublishedDatePicker(context);
            },
          ),
          const SizedBox(height: 16),
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
            ),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Switch(
              value: ratingsToggle,
              onChanged: (value) {
                setState(() {
                  ratingsToggle = value;
                });
              },
            ),
            Text(
              'Ratings ${ratingsToggle ? 'Enabled' : 'Disabled'}',
            ),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Switch(
              value: videoErrorOrRemovedToggle,
              onChanged: (value) {
                setState(() {
                  videoErrorOrRemovedToggle = value;
                });
              },
            ),
            Text(
              'Video Error or Removed ${videoErrorOrRemovedToggle ? 'Enabled' : 'Disabled'}',
            ),
          ]),
          const SizedBox(height: 16),
          ButtonBar(
            children: [
              OutlinedButton(
                onPressed: () {
                  Provider.of<EntityManager>(context, listen: false).addEntity(
                    Entity(
                      title: _videoNameController.text,
                      channelTitle: _channelController.text,
                      category: _selectedCategory,
                      publishTime: _publishedDate.toIso8601String(),
                      tags: [],
                      views: int.parse(_viewsController.text),
                      likes: int.parse(_likesController.text),
                      dislikes: int.parse(_dislikesController.text),
                      commentCount: int.parse(_commentsController.text),
                      thumbnailLink: _thumbnailLinkController.text,
                      commentsDisabled: commentsToggle,
                      ratingsDisabled: ratingsToggle,
                      videoErrorOrRemoved: videoErrorOrRemovedToggle,
                      description: _descriptionController.text,
                      videoID: _videoIDController.text,
                      trendingDate: _trendingDate.toString().split(' ')[0],
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({this.controller, this.hint});

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

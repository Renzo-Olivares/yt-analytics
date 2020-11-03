import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';
import 'package:yt_analytics_client/tools/constants.dart' as constants;
import 'package:yt_analytics_client/tools/utils.dart';

enum InputType { num, alpha }

class InsertForm extends StatefulWidget {
  @override
  _InsertFormState createState() => _InsertFormState();
}

class _InsertFormState extends State<InsertForm> {
  final _insertFormKey = GlobalKey<FormState>();
  DateTime _trendingDate = DateTime.now();
  DateTime _publishedDate = DateTime.now();
  TimeOfDay _publishedTime = TimeOfDay.fromDateTime(DateTime.now());
  final _viewsController = TextEditingController();
  final _likesController = TextEditingController();
  final _commentsController = TextEditingController();
  final _dislikesController = TextEditingController();
  final _channelController = TextEditingController();
  final _videoNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailLinkController = TextEditingController();
  final _videoIDController = TextEditingController();
  final _tagsController = TextEditingController();
  String _selectedCategory;
  bool commentsToggle = false;
  bool ratingsToggle = false;
  bool videoErrorOrRemovedToggle = false;

  Future<void> _showTrendingDatePicker() async {
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

  Future<void> _showPublishedDatePicker() async {
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

  Future<void> _showPublishedTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _publishedTime,
    );

    if (picked != null && picked != _publishedTime) {
      setState(() {
        _publishedTime = picked;
      });
    }
  }

  String quotenizer(String orig) {
    var splitArr = orig.split(',');

    for (var i = 0; i < splitArr.length; i++) {
      splitArr[i] = '"${splitArr[i]}"';
    }

    return splitArr.join(',');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _insertFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a New Trending Entry',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              hint: const Text('Category'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              value: _selectedCategory,
              validator: (value) =>
                  value == null ? 'Please select a value' : null,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items:
                  constants.categories.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _videoIDController,
              hint: 'Video ID',
              type: InputType.alpha,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _videoNameController,
              hint: 'Video Name',
              type: InputType.alpha,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _channelController,
              hint: 'Channel Name',
              type: InputType.alpha,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _descriptionController,
              hint: 'Video Description',
              type: InputType.alpha,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _thumbnailLinkController,
              hint: 'Thumbnail Link',
              type: InputType.alpha,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _tagsController,
              hint: 'Tags Comma Separated',
              type: InputType.alpha,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _viewsController,
              hint: '# of Views',
              type: InputType.num,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _likesController,
              hint: '# of Likes',
              type: InputType.num,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _dislikesController,
              hint: '# of Dislikes',
              type: InputType.num,
            ),
            const SizedBox(height: 16),
            _InputField(
              controller: _commentsController,
              hint: '# of Comments',
              type: InputType.num,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Trending Date'),
              onPressed: () {
                _showTrendingDatePicker();
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  child: const Text('Publish Date'),
                  onPressed: () {
                    _showPublishedDatePicker();
                  },
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  child: const Text('Publish Time'),
                  onPressed: () {
                    _showPublishedTimePicker();
                  },
                ),
              ],
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
            Row(
              children: [
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
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
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
              ],
            ),
            const SizedBox(height: 16),
            ButtonBar(
              children: [
                OutlinedButton(
                  onPressed: () {
                    if (_insertFormKey.currentState.validate()) {
                      final pubDateTime = DateTime(
                        _publishedDate.year,
                        _publishedDate.month,
                        _publishedDate.day,
                        _publishedTime.hour,
                        _publishedTime.minute,
                      );
                      Provider.of<EntityManager>(context, listen: false)
                          .addEntity(
                        Entity(
                          title: _videoNameController.text,
                          channelTitle: _channelController.text,
                          category: _selectedCategory,
                          publishTime:
                              pubDateTime.toIso8601String().split('.')[0],
                          tags: quotenizer(_tagsController.text),
                          views: int.parse(_viewsController.text),
                          likes: int.parse(_likesController.text),
                          dislikes: int.parse(_dislikesController.text),
                          commentCount: int.parse(_commentsController.text),
                          thumbnailLink: _thumbnailLinkController.text,
                          commentsDisabled: !commentsToggle,
                          ratingsDisabled: !ratingsToggle,
                          videoErrorOrRemoved: !videoErrorOrRemovedToggle,
                          description: _descriptionController.text,
                          videoID: _videoIDController.text,
                          trendingDate: _trendingDate.toString().split(' ')[0],
                        ),
                      );

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please fill in all fields before submitting',
                          ),
                        ),
                      );
                    }
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
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    @required this.controller,
    @required this.hint,
    @required this.type,
  })  : assert(controller != null),
        assert(hint != null),
        assert(type != null);

  final TextEditingController controller;
  final String hint;
  final InputType type;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 50),
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          print(value);
          switch (type) {
            case InputType.num:
              if (!Utils.isDigit(value)) {
                return 'Please enter a number';
              } else {
                if (value.isEmpty) {
                  return 'Please enter a number';
                }
              }
              break;
            case InputType.alpha:
              if (value.isEmpty) {
                return 'Please enter a value';
              }
              break;
            default:
              return null;
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(),
          labelText: hint,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/models/filtermanager.dart';

enum FilterType {
  channelName,
  category,
  commentsDisabled,
  videoName,
  views,
  likes,
  comments,
  tags,
  dislikes
}

class FilterSelection extends StatefulWidget {
  @override
  _FilterSelectionState createState() => _FilterSelectionState();
}

class _FilterSelectionState extends State<FilterSelection> {
  DateTime _trendingDate = DateTime.now();
  DateTime _publishedDate = DateTime.now();
  String _dropdownValue;
  final List<String> _categories = [
    'None',
    'Film & Animation',
    'Autos & Vehicles',
    'Music',
    'Pets & Animals',
    'Sports',
    'Short Movies',
    'Travel & Events',
    'Gaming',
    'Videoblogging',
    'People & Blogs',
    'Comedy',
    'Entertainment',
    'News & Politics',
    'Howto & Style',
    'Education',
    'Science & Technology',
    'Nonprofits & Activism',
    'Movies',
    'Anime/Animation',
    'Action/Adventure',
    'Classics',
    'Comedy',
    'Documentary',
    'Drama',
    'Family',
    'Foreign',
    'Horror',
    'Sci-Fi/Fantasy',
    'Thriller',
    'Shorts',
    'Shows',
    'Trailers',
  ];

  // final _tagsController = TextEditingController();
  final _viewsController = TextEditingController();
  final _likesController = TextEditingController();
  final _dislikesController = TextEditingController();
  // final _commentsController = TextEditingController();
  final _channelController = TextEditingController();

  bool commentsToggle = false;

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
                      type: FilterType.views,
                    ),
                    SizedBox(height: 16),
                    _FilterInput(
                      controller: _likesController,
                      hint: 'More than x likes',
                      type: FilterType.likes,
                    ),
                    SizedBox(height: 16),
                    _FilterInput(
                      controller: _dislikesController,
                      hint: 'More than x dislikes',
                      type: FilterType.dislikes,
                    ),
                    SizedBox(height: 16),
                    // _FilterInput(
                    //   controller: _commentsController,
                    //   hint: 'More than x comments',
                    //   type: FilterType.comments,
                    // ),
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
                        _showTrendingDatePicker(context);
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      child: Text('Publish Date'),
                      onPressed: () {
                        _showPublishedDatePicker(context);
                      },
                    ),
                  ],
                ),
              ),
              // _FilterColumn(
              //   title: 'TAGS',
              //   filters: Column(
              //     children: [
              //       SizedBox(height: 32),
              //       _FilterInput(
              //         controller: _tagsController,
              //         hint: 'Video Tags',
              //         type: FilterType.tags,
              //       ),
              //     ],
              //   ),
              // ),
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
                            Provider.of<FilterManager>(context, listen: false)
                                .commentsDisabled = value;
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
                      type: FilterType.channelName,
                    ),
                    SizedBox(height: 16),
                    DropdownButton<String>(
                      hint: Text('Category'),
                      value: _dropdownValue,
                      onChanged: (value) {
                        setState(() {
                          _dropdownValue = value;
                          Provider.of<FilterManager>(context, listen: false)
                              .category = value;
                        });
                      },
                      items: _categories.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
  const _FilterInput({this.controller, this.hint, this.type});

  final TextEditingController controller;
  final String hint;
  final FilterType type;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200, maxHeight: 50),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          switch (type) {
            case FilterType.channelName:
              Provider.of<FilterManager>(context, listen: false).channelName =
                  value;
              break;
            case FilterType.category:
              Provider.of<FilterManager>(context, listen: false).category =
                  value;
              break;
            case FilterType.comments:
              Provider.of<FilterManager>(context, listen: false).comments =
                  value;
              break;
            case FilterType.videoName:
              Provider.of<FilterManager>(context, listen: false).videoName =
                  value;
              break;
            case FilterType.views:
              Provider.of<FilterManager>(context, listen: false).views = value;
              break;
            case FilterType.likes:
              Provider.of<FilterManager>(context, listen: false).likes = value;
              break;
            case FilterType.dislikes:
              Provider.of<FilterManager>(context, listen: false).dislikes =
                  value;
              break;
            default:
          }
        },
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

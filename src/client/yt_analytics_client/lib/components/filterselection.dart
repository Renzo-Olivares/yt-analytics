import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/models/filtermanager.dart';
import 'package:yt_analytics_client/tools/constants.dart' as constants;
import 'package:yt_analytics_client/tools/utils.dart';

enum FilterType {
  channelName,
  commentsDisabled,
  videoName,
  views,
  likes,
  comments,
  tags,
  dislikes,
}
final filterFormKey = GlobalKey<FormState>();

class FilterSelection extends StatefulWidget {
  const FilterSelection();

  @override
  _FilterSelectionState createState() => _FilterSelectionState();
}

class _FilterSelectionState extends State<FilterSelection> {
  String _dropdownValue;
  final _viewsController = TextEditingController();
  final _likesController = TextEditingController();
  final _dislikesController = TextEditingController();
  final _channelController = TextEditingController();

  bool commentsToggle = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.filter_list_outlined),
      title: Text(
        'FILTER',
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: const SizedBox(),
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 40,
            end: 40,
            top: 16,
            bottom: 16,
          ),
          child: Form(
            key: filterFormKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilterColumn(
                  title: 'STATS',
                  filters: Column(
                    children: [
                      const SizedBox(height: 32),
                      _FilterInput(
                        controller: _viewsController,
                        hint: 'More than x views',
                        type: FilterType.views,
                      ),
                      const SizedBox(height: 16),
                      _FilterInput(
                        controller: _likesController,
                        hint: 'More than x likes',
                        type: FilterType.likes,
                      ),
                      const SizedBox(height: 16),
                      _FilterInput(
                        controller: _dislikesController,
                        hint: 'More than x dislikes',
                        type: FilterType.dislikes,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
                _FilterColumn(
                  title: 'VIDEO PROPERTIES',
                  filters: Column(
                    children: [
                      const SizedBox(height: 32),
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
                      const SizedBox(height: 16),
                      _FilterInput(
                        controller: _channelController,
                        hint: 'Channel Name',
                        type: FilterType.channelName,
                      ),
                      const SizedBox(height: 16),
                      DropdownButton<String>(
                        hint: const Text('Category'),
                        value: _dropdownValue,
                        onChanged: (value) {
                          setState(() {
                            _dropdownValue = value;
                            Provider.of<FilterManager>(context, listen: false)
                                .category = value;
                          });
                        },
                        items: constants.categories
                            .map<DropdownMenuItem<String>>((value) {
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
  const _FilterInput({
    @required this.controller,
    @required this.hint,
    @required this.type,
  })  : assert(controller != null),
        assert(hint != null),
        assert(type != null);

  final TextEditingController controller;
  final String hint;
  final FilterType type;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 50),
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          switch (type) {
            case FilterType.channelName:
              Provider.of<FilterManager>(context, listen: false).channelName =
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
              break;
          }
        },
        decoration: InputDecoration(
          filled: true,
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(),
          labelText: hint,
        ),
        validator: (value) {
          switch (type) {
            case FilterType.views:
            case FilterType.likes:
            case FilterType.dislikes:
              if (!Utils.isDigit(value)) {
                return 'Please enter a number';
              }
              break;
            case FilterType.channelName:
              break;
            case FilterType.comments:
              break;
            case FilterType.videoName:
              break;
            default:
              return null;
          }
          return null;
        },
      ),
    );
  }
}

class _FilterColumn extends StatelessWidget {
  const _FilterColumn({@required this.title, @required this.filters})
      : assert(title != null),
        assert(filters != null);
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

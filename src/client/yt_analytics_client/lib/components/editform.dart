import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';
import 'package:yt_analytics_client/tools/utils.dart';

class EditForm extends StatelessWidget {
  final Future<Entity> entity;
  EditForm({@required this.entity}) : assert(entity != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: FutureBuilder(
        future: entity,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _EditContents(
                  entity: snapshot.data as Entity,
                );
              }
          }
        },
      ),
    );
  }
}

class _EditContents extends StatefulWidget {
  _EditContents({@required this.entity}) : assert(entity != null);
  final Entity entity;

  @override
  _EditContentsState createState() => _EditContentsState();
}

class _EditContentsState extends State<_EditContents> {
  final _editFormKey = GlobalKey<FormState>();
  TextEditingController _videoIDController;
  TextEditingController _titleController;
  TextEditingController _channelController;
  TextEditingController _descController;
  TextEditingController _viewsController;
  TextEditingController _likesController;
  TextEditingController _dislikesController;

  @override
  void initState() {
    super.initState();
    _videoIDController = TextEditingController(text: widget.entity.videoID);
    _titleController = TextEditingController(
      text: widget.entity.title.substring(1, widget.entity.title.length - 1),
    );
    _channelController = TextEditingController(
      text: widget.entity.channelTitle
          .substring(1, widget.entity.channelTitle.length - 1),
    );
    _descController = TextEditingController(
      text: widget.entity.description
          .substring(1, widget.entity.description.length - 1),
    );
    _viewsController =
        TextEditingController(text: widget.entity.views.toString());
    _likesController =
        TextEditingController(text: widget.entity.likes.toString());
    _dislikesController =
        TextEditingController(text: widget.entity.dislikes.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _editFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Editing Entry',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _videoIDController,
            hint: 'Video ID',
            enabled: false,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _titleController,
            hint: 'Video Title',
            enabled: false,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _channelController,
            hint: 'Channel',
            enabled: false,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _descController,
            hint: 'Description',
            enabled: false,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _viewsController,
            hint: 'Views',
            enabled: true,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _likesController,
            hint: 'Likes',
            enabled: true,
          ),
          const SizedBox(height: 16),
          _InputField(
            controller: _dislikesController,
            hint: 'Dislikes',
            enabled: true,
          ),
          const SizedBox(height: 16),
          ButtonBar(
            children: [
              OutlinedButton(
                onPressed: () {
                  if (_editFormKey.currentState.validate()) {
                    Provider.of<EntityManager>(context, listen: false)
                        .updateEntity(
                      _viewsController.text,
                      _likesController.text,
                      _dislikesController.text,
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please check all fields and try again',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    @required this.controller,
    @required this.hint,
    @required this.enabled,
  })  : assert(controller != null),
        assert(hint != null),
        assert(enabled != null);

  final TextEditingController controller;
  final String hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 50),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          enabled: enabled,
          filled: true,
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(),
          labelText: hint,
        ),
        validator: (value) => enabled
            ? !Utils.isDigit(value)
                ? 'Please enter a number'
                : null
            : null,
      ),
    );
  }
}

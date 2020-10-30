import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_analytics_client/models/entity.dart';
import 'package:yt_analytics_client/models/entitymanager.dart';

class EditForm extends StatelessWidget {
  final Future<Entity> entity;
  EditForm({this.entity});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: FutureBuilder(
        future: this.entity,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _EditContents(
                  entity: snapshot.data,
                );
              }
          }
        },
      ),
    );
  }
}

class _EditContents extends StatefulWidget {
  _EditContents({this.entity});
  final Entity entity;

  @override
  __EditContentsState createState() => __EditContentsState();
}

class __EditContentsState extends State<_EditContents> {
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
        text: widget.entity.title.substring(1, widget.entity.title.length - 1));
    _channelController = TextEditingController(
        text: widget.entity.channelTitle
            .substring(1, widget.entity.channelTitle.length - 1));
    _descController = TextEditingController(
        text: widget.entity.description
            .substring(1, widget.entity.description.length - 1));
    _viewsController =
        TextEditingController(text: widget.entity.views.toString());
    _likesController =
        TextEditingController(text: widget.entity.likes.toString());
    _dislikesController =
        TextEditingController(text: widget.entity.dislikes.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                Provider.of<EntityManager>(context, listen: false).updateEntity(
                  _viewsController.text,
                  _likesController.text,
                  _dislikesController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({this.controller, this.hint, this.enabled});

  final TextEditingController controller;
  final String hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200, maxHeight: 50),
      child: TextField(
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
          enabled: enabled,
          filled: true,
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(),
          labelText: hint,
        ),
      ),
    );
  }
}

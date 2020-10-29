import 'package:flutter/material.dart';

class FilterManager with ChangeNotifier {
  String _category = '';
  bool _commentsDisabled;
  String _videoName = '';
  String _views = '';
  String _comments = '';
  String _likes = '';
  String _dislikes = '';
  String _channelName = '';

  String get category => _category;
  bool get commentsDisabled => _commentsDisabled;
  String get videoName => _videoName;
  String get views => _views;
  String get likes => _likes;
  String get dislikes => _dislikes;
  String get channelName => _channelName;
  String get comments => _comments;

  set category(String category) {
    _category = category;
    notifyListeners();
  }

  set commentsDisabled(bool commentsDisabled) {
    _commentsDisabled = commentsDisabled;
    notifyListeners();
  }

  set comments(String comments) {
    _comments = comments;
    notifyListeners();
  }

  set videoName(String videoName) {
    _videoName = videoName;
    notifyListeners();
  }

  set views(String views) {
    _views = views;
    notifyListeners();
  }

  set likes(String likes) {
    _likes = likes;
    notifyListeners();
  }

  set dislikes(String dislikes) {
    _dislikes = dislikes;
    notifyListeners();
  }

  set channelName(String channelName) {
    _channelName = channelName;
    notifyListeners();
  }
}

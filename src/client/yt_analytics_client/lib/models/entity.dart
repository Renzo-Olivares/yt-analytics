import 'package:flutter/material.dart';

class Entity {
  Entity({
    @required this.title,
    @required this.channelTitle,
    @required this.category,
    @required this.publishTime,
    @required this.tags,
    @required this.views,
    @required this.likes,
    @required this.dislikes,
    @required this.commentCount,
    @required this.thumbnailLink,
    @required this.commentsDisabled,
    @required this.ratingsDisabled,
    @required this.videoErrorOrRemoved,
    @required this.description,
    @required this.videoID,
    @required this.trendingDate,
    this.selected = false,
  })  : assert(title != null),
        assert(channelTitle != null),
        assert(category != null),
        assert(publishTime != null),
        assert(tags != null),
        assert(views != null),
        assert(likes != null),
        assert(dislikes != null),
        assert(commentCount != null),
        assert(thumbnailLink != null),
        assert(commentsDisabled != null),
        assert(ratingsDisabled != null),
        assert(videoErrorOrRemoved != null),
        assert(description != null),
        assert(videoID != null),
        assert(trendingDate != null),
        assert(selected != null);

  Entity.fromJson(Map<String, dynamic> data)
      : title = data['title'] as String,
        channelTitle = data['channelTitle'] as String,
        category = data['category'] as String,
        publishTime = data['publishTime'] as String,
        tags = parseTags(data['tags'] as List<dynamic>),
        views = data['views'] as int,
        likes = data['likes'] as int,
        dislikes = data['dislikes'] as int,
        commentCount = data['commentCount'] as int,
        thumbnailLink = data['thumbnailLink'] as String,
        commentsDisabled = data['commentsDisabled'] as bool,
        ratingsDisabled = data['ratingsDisabled'] as bool,
        videoErrorOrRemoved = data['videoErrorOrRemoved'] as bool,
        description = data['description'] as String,
        videoID = data['videoID'] as String,
        trendingDate = data['trendingDate'] as String,
        selected = false;

  final String videoID;
  final String trendingDate;
  final String title;
  final String channelTitle;
  final String category;
  final String publishTime;
  final String tags;
  int views;
  int likes;
  int dislikes;
  final int commentCount;
  final String thumbnailLink;
  final bool commentsDisabled;
  final bool ratingsDisabled;
  final bool videoErrorOrRemoved;
  final String description;
  bool selected;

  static String parseTags(List<dynamic> tags) {
    var parsedStrings = <String>[];

    for (final tag in tags) {
      parsedStrings.add((tag as String));
    }

    return parsedStrings.join(' , ');
  }
}

class Entity {
  Entity({
    this.title,
    this.channelTitle,
    this.category,
    this.publishTime,
    this.tags,
    this.views,
    this.likes,
    this.dislikes,
    this.commentCount,
    this.thumbnailLink,
    this.commentsDisabled,
    this.ratingsDisabled,
    this.videoErrorOrRemoved,
    this.description,
    this.videoID,
    this.trendingDate,
    this.selected = false,
  });

  Entity.fromJson(Map<String, dynamic> data)
      : title = data['title'],
        channelTitle = data['channelTitle'],
        category = data['category'],
        publishTime = data['publishTime'],
        tags = data['tags'],
        views = data['views'],
        likes = data['likes'],
        dislikes = data['dislikes'],
        commentCount = data['commentCount'],
        thumbnailLink = data['thumbnailLink'],
        commentsDisabled = data['commentsDisabled'],
        ratingsDisabled = data['ratingsDiabled'],
        videoErrorOrRemoved = data['videoErrorOrRemoved'],
        description = data['description'],
        videoID = data['videoID'],
        trendingDate = data['trendingDate'],
        selected = false;

  final String videoID;
  final String trendingDate;
  final String title;
  final String channelTitle;
  final String category;
  final String publishTime;
  final List<dynamic> tags;
  final int views;
  final int likes;
  final int dislikes;
  final int commentCount;
  final String thumbnailLink;
  final bool commentsDisabled;
  final bool ratingsDisabled;
  final bool videoErrorOrRemoved;
  final String description;
  bool selected;
}

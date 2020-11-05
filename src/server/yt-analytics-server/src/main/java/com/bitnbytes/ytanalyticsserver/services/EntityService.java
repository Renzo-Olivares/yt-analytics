package com.bitnbytes.ytanalyticsserver.services;

import com.bitnbytes.ytanalyticsserver.database.Entity;
import com.bitnbytes.ytanalyticsserver.database.TrendingChartData;

import java.io.IOException;
import java.util.List;

public interface EntityService {
    List<Entity> getAllEntities();
    List<Entity> getEntitiesByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes);
    List<TrendingChartData> getAnalyticsByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes, String type);
    void backup(String filePath);
    void restore(String filePath) throws IOException;
    void insertData(String videoID, String trendingDate, String title, String channelTitle, String category, String publishTime, String tags, String views, String likes, String dislikes, String comments, String thumbnailLink, String commentsDisabled, String ratingsDisabled, String videoErrorOrRemoved, String description);
    void removeEntity(String videoID, String views);
    void updateEntity(String videoID, String oldViews, String views, String likes, String dislikes);
}

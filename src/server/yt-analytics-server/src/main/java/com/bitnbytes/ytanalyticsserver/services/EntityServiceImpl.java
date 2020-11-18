package com.bitnbytes.ytanalyticsserver.services;

import com.bitnbytes.ytanalyticsserver.database.Entity;
import com.bitnbytes.ytanalyticsserver.database.EntityManager;
import com.bitnbytes.ytanalyticsserver.database.EntityN;
import com.bitnbytes.ytanalyticsserver.database.TrendingChartData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;

@Component
public class EntityServiceImpl implements EntityService{
    private final EntityManager entityDatabase;

    @Autowired
    public EntityServiceImpl(@Qualifier("entityManager") EntityManager aDb){
        entityDatabase = aDb;
    }

    @Override
    public List<EntityN> getAllEntities() {
        return entityDatabase.getAllEntities();
    }

    @Override
    public List<EntityN> getEntitiesByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes) {
        return entityDatabase.getEntitiesNByFilter(channelName, category, commentsDisabled, videoName, views, likes, dislikes);
    }

    @Override
    public void backup(String filePath) {
        entityDatabase.backup(filePath);
    }

    @Override
    public void restore(String filePath) throws IOException {
        entityDatabase.restore(filePath);
    }

    @Override
    public void insertData(String videoID, String trendingDate, String title, String channelTitle, String category, String publishTime, String tags, String views, String likes, String dislikes, String comments, String thumbnailLink, String commentsDisabled, String ratingsDisabled, String videoErrorOrRemoved, String description) {
        entityDatabase.insertEntityN(videoID,trendingDate,title,channelTitle,category,publishTime,tags,views,likes,dislikes,comments,thumbnailLink,commentsDisabled,ratingsDisabled,videoErrorOrRemoved,description);
    }

    @Override
    public void removeEntity(String videoID, String views) {
        entityDatabase.removeEntityN(videoID, views);
    }

    @Override
    public void updateEntity(String videoID, String oldViews, String views, String likes, String dislikes) {
        System.out.println(videoID);
        entityDatabase.updateEntityN(videoID, oldViews, views, likes, dislikes);
    }

    @Override
    public List<TrendingChartData> getAnalyticsByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes, String type) {
        return entityDatabase.getAnalyticsByFilter(channelName, category, commentsDisabled, videoName, views, likes, dislikes, type);
    }

    @Override
    public List<EntityN> getTopTrendingN(String n) {
        return entityDatabase.getTopTrendingByLikeDislikeRatio(Integer.parseInt(n));
    }

    @Override
    public List<Entity> getTrendingNDays(String days) {
        return entityDatabase.getTrendingNDays(Integer.parseInt(days));
    }
}

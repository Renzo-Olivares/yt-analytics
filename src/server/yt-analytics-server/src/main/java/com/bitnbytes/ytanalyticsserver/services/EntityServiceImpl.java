package com.bitnbytes.ytanalyticsserver.services;

import com.bitnbytes.ytanalyticsserver.database.EntityManager;
import com.bitnbytes.ytanalyticsserver.database.Entity;
import com.bitnbytes.ytanalyticsserver.database.TrendingChartData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Set;

@Component
public class EntityServiceImpl implements EntityService{
    private final EntityManager entityDatabase;

    @Autowired
    public EntityServiceImpl(@Qualifier("entityManager") EntityManager aDb){
        entityDatabase = aDb;
    }

    @Override
    public Set<Entity> getAllEntities() {
        return entityDatabase.getAllEntities();
    }

    @Override
    public Set<Entity> getEntitiesByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes) {
        return entityDatabase.getEntitiesByFilter(channelName, category, commentsDisabled, videoName, views, likes, dislikes);
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
        entityDatabase.insertEntity(videoID,trendingDate,title,channelTitle,category,publishTime,tags,views,likes,dislikes,comments,thumbnailLink,commentsDisabled,ratingsDisabled,videoErrorOrRemoved,description);
    }

    @Override
    public void removeEntity(String videoID, String views) {
        entityDatabase.removeEntityN(videoID, views);
    }

    @Override
    public void updateEntity(String videoID, String oldViews, String views, String likes, String dislikes) {
        System.out.println(videoID);
        entityDatabase.updateEntity(videoID, oldViews, views, likes, dislikes);
    }

    @Override
    public Set<TrendingChartData> getAnalyticsByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes, String type) {
        long startTime = System.nanoTime();
        Set<TrendingChartData> random = entityDatabase.getAnalyticsByFilter(channelName, category, commentsDisabled, videoName, views, likes, dislikes, type);
        long endTime = System.nanoTime();

        long duration = (endTime - startTime) / 1000000;
        if(type.equals("Tags")){
            System.out.println("Runtime of tag average category in milliseconds");
            System.out.println(duration);
            System.out.println("Runtime of tag average category");
        }
        return random;
//        return entityDatabase.getAnalyticsByFilter(channelName, category, commentsDisabled, videoName, views, likes, dislikes, type);
    }

    @Override
    public Set<Entity> getTopTrendingN(String n) {
        return entityDatabase.getTopTrendingByLikeDislikeRatio(Integer.parseInt(n));
    }

    @Override
    public Set<Entity> getTrendingNDays(String days) {
        return entityDatabase.getTrendingNDays(Integer.parseInt(days));
    }
}

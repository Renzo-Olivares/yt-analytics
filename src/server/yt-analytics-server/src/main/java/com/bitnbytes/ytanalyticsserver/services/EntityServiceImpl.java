package com.bitnbytes.ytanalyticsserver.services;

import com.bitnbytes.ytanalyticsserver.database.Entity;
import com.bitnbytes.ytanalyticsserver.database.EntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class EntityServiceImpl implements EntityService{
    private final EntityManager entityDatabase;

    @Autowired
    public EntityServiceImpl(@Qualifier("entityManager") EntityManager aDb){
        entityDatabase = aDb;
    }

    @Override
    public List<Entity> getAllEntities() {
        return entityDatabase.getAllEntities();
    }

    @Override
    public List<Entity> getEntitiesByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes) {
        return entityDatabase.getEntitiesByFilter(channelName, category, commentsDisabled, videoName, views, likes, dislikes);
    }
}

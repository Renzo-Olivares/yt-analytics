package com.bitnbytes.ytanalyticsserver.services;

import com.bitnbytes.ytanalyticsserver.database.Entity;

import java.util.List;

public interface EntityService {
    List<Entity> getAllEntities();
    List<Entity> getEntitiesByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes);

}

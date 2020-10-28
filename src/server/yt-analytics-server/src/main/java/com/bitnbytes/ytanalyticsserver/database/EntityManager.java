package com.bitnbytes.ytanalyticsserver.database;

import com.bitnbytes.ytanalyticsserver.utils.CsvReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Component("entityManager")
public class EntityManager {
    private final List<Entity> entities = new ArrayList<>();
    private final List<Entity> filteredList = new ArrayList<>();
    private final CsvReader csvReader;

    @Autowired
    public EntityManager(CsvReader csvReader) throws IOException {
        this.csvReader = csvReader;
        this.csvReader.read("/home/renzo/USvideos.csv");
        entities.addAll(this.csvReader.getData());
    }

    public List<Entity> getAllEntities(){
        return entities;
    }

    public List<Entity> getEntitiesByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes){
        filteredList.add(entities.get(0));
        return filteredList;
    }
}
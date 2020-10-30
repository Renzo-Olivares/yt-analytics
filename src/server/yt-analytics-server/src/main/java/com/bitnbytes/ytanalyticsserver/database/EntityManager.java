package com.bitnbytes.ytanalyticsserver.database;

import com.bitnbytes.ytanalyticsserver.utils.CsvReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
        //default value for commentsDisabled is "null"
        //default value for category is "None" or ""
        //default value for all others is ""
        String channelNameParam = channelName.substring(1, channelName.length() - 1);
        String categoryParam = category.substring(1, category.length() - 1);
        String commentsDisabledParam = commentsDisabled.substring(1, commentsDisabled.length() - 1);
        String videoNameParam = videoName.substring(1, videoName.length() - 1);
        String viewsParam = views.substring(1, views.length() - 1);
        String likesParam = likes.substring(1, likes.length() - 1);
        String dislikesParam = dislikes.substring(1, dislikes.length() - 1);

        boolean commentsToggle = false;

        if(commentsDisabledParam.equals("true")){
            commentsToggle = true;
        }

        filteredList.clear();

        for (Entity entity : entities) {
            if((channelNameParam.equals("") || entity.channelTitle.equals(channelNameParam)) && (categoryParam.equals("") || (entity.getCategory()).equals(categoryParam)) && (commentsDisabledParam.equals("") || entity.commentsDisabled == commentsToggle)&& (videoNameParam.equals("") || entity.title.equals(videoNameParam)) && (viewsParam.equals("") || entity.views == Integer.parseInt(viewsParam)) && (likesParam.equals("") || entity.likes == Integer.parseInt(likesParam)) && (dislikesParam.equals("") || entity.dislikes == Integer.parseInt(dislikesParam))){
                filteredList.add(entity);
            }
        }

        System.out.println(filteredList.size());

        return filteredList;
    }
}
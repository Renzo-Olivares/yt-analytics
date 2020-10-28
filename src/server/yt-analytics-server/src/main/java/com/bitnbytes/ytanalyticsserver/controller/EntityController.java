package com.bitnbytes.ytanalyticsserver.controller;

import com.bitnbytes.ytanalyticsserver.database.Entity;
import com.bitnbytes.ytanalyticsserver.services.EntityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(path="/ytanalytics")
public class EntityController {
    final private EntityService entityService;

    @Autowired
    public EntityController(EntityService eService){
        entityService = eService;
    }

    @RequestMapping(value = "/entities", method = RequestMethod.GET)
    public ResponseEntity<List<Entity>> getMockData(){
        System.out.println("Client requesting all data from server");
        return new ResponseEntity<>(entityService.getAllEntities(), HttpStatus.OK);
    }

    @RequestMapping(value = "/entitiesFiltered/channel/{channelName}/category/{category}/commentsDisabled/{commentsDisabled}/videoName/{videoName}/views/{minViews}/likes/{minLikes}/dislikes/{minDislikes}", method = RequestMethod.GET)
    public ResponseEntity<List<Entity>> getFilteredData(@PathVariable String channelName, @PathVariable String category, @PathVariable String commentsDisabled, @PathVariable String videoName, @PathVariable String minViews, @PathVariable String minLikes, @PathVariable String minDislikes){
        System.out.println("Client requesting filtered data from server");
        System.out.println(channelName);
        System.out.println(category);
        System.out.println(commentsDisabled);
        System.out.println(videoName);
        System.out.println(minViews);
        System.out.println(minLikes);
        System.out.println(minDislikes);
        return new ResponseEntity<>(entityService.getEntitiesByFilter(channelName, category, commentsDisabled, videoName, minViews, minLikes, minDislikes), HttpStatus.OK);
    }
}

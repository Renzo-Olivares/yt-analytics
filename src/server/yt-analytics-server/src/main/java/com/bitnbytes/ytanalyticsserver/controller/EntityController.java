package com.bitnbytes.ytanalyticsserver.controller;

import com.bitnbytes.ytanalyticsserver.database.Entity;
import com.bitnbytes.ytanalyticsserver.database.TrendingChartData;
import com.bitnbytes.ytanalyticsserver.services.EntityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
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
    public ResponseEntity<List<Entity>> getAllData(){
        System.out.println("Client requesting all data from server");
        return new ResponseEntity<>(entityService.getAllEntities(), HttpStatus.OK);
    }

    @RequestMapping(value = "/analytics/trendingdays/{days}", method = RequestMethod.GET)
    public ResponseEntity<List<Entity>> getAllData(@PathVariable String days){
        System.out.println("Client trending n days");
        return new ResponseEntity<>(entityService.getTrendingNDays(days), HttpStatus.OK);
    }

    @RequestMapping(value = "/analytics/topTrendingN/{n}", method = RequestMethod.GET)
    public ResponseEntity<List<Entity>> getTopTrendingN(@PathVariable String n){
        System.out.println("Client requesting all data from server");
        return new ResponseEntity<>(entityService.getTopTrendingN(n), HttpStatus.OK);
    }

    @RequestMapping(value = "/entitiesFiltered/channel/{channelName}/category/{category}/commentsDisabled/{commentsDisabled}/videoName/{videoName}/views/{minViews}/likes/{minLikes}/dislikes/{minDislikes}", method = RequestMethod.GET)
    public ResponseEntity<List<Entity>> getFilteredData(@PathVariable String channelName, @PathVariable String category, @PathVariable String commentsDisabled, @PathVariable String videoName, @PathVariable String minViews, @PathVariable String minLikes, @PathVariable String minDislikes){
        System.out.println("Client requesting filtered data from server");
//        System.out.println(channelName);
//        System.out.println(category);
//        System.out.println(commentsDisabled);
//        System.out.println(videoName);
//        System.out.println(minViews);
//        System.out.println(minLikes);
//        System.out.println(minDislikes);
        return new ResponseEntity<>(entityService.getEntitiesByFilter(channelName, category, commentsDisabled, videoName, minViews, minLikes, minDislikes), HttpStatus.OK);
    }

    @RequestMapping(value = "/analyticsFiltered/channel/{channelName}/category/{category}/commentsDisabled/{commentsDisabled}/videoName/{videoName}/views/{minViews}/likes/{minLikes}/dislikes/{minDislikes}/type/{type}", method = RequestMethod.GET)
    public ResponseEntity<List<TrendingChartData>> getFilteredAnalytics(@PathVariable String channelName, @PathVariable String category, @PathVariable String commentsDisabled, @PathVariable String videoName, @PathVariable String minViews, @PathVariable String minLikes, @PathVariable String minDislikes, @PathVariable String type){
        System.out.println("Client requesting filtered analytics from server");
//        System.out.println(channelName);
//        System.out.println(category);
//        System.out.println(commentsDisabled);
//        System.out.println(videoName);
//        System.out.println(minViews);
//        System.out.println(minLikes);
//        System.out.println(minDislikes);
        return new ResponseEntity<>(entityService.getAnalyticsByFilter(channelName, category, commentsDisabled, videoName, minViews, minLikes, minDislikes, type), HttpStatus.OK);
    }

    @RequestMapping(value = "/backup/{filePath}", method = RequestMethod.POST)
    public ResponseEntity<String> backupData(@PathVariable String filePath){
        System.out.println("Backing data up");
        entityService.backup(filePath);
        return new ResponseEntity<>("Backup initiated", HttpStatus.OK);
    }

    @RequestMapping(value = "/remove/videoID/{videoID}/views/{views}", method = RequestMethod.POST)
    public ResponseEntity<String> removeEntity(@PathVariable String videoID, @PathVariable String views){
        System.out.println("Deleting entity");
        entityService.removeEntity(videoID, views);
        return new ResponseEntity<>("Entity deleted", HttpStatus.OK);
    }

    @RequestMapping(value = "/update/{videoID}/oldViews/{oldViews}/views/{views}/likes/{likes}/dislikes/{dislikes}", method = RequestMethod.POST)
    public ResponseEntity<String> updateEntity(@PathVariable String videoID, @PathVariable String dislikes, @PathVariable String likes, @PathVariable String oldViews, @PathVariable String views){
        System.out.println("Updating entity");
        entityService.updateEntity(videoID, oldViews, views, likes, dislikes);
        return new ResponseEntity<>("Entity updated", HttpStatus.OK);
    }

    @RequestMapping(value = "/insert/videoID/{videoID}/trendingDate/{trendingDate}/title/{title}/channelTitle/{channelTitle}/category/{category}/publishTime/{publishTime}/tags/{tags}/views/{views}/likes/{likes}/dislikes/{dislikes}/comments/{comments}/thumbnailLink/{thumbnailLink}/commentsDisabled/{commentsDisabled}/ratingsDisabled/{ratingsDisabled}/videoErrorOrRemoved/{videoErrorOrRemoved}/description/{description}", method = RequestMethod.POST)
    public ResponseEntity<String> insertData(@PathVariable String videoID,@PathVariable String trendingDate,@PathVariable String title,@PathVariable String channelTitle,@PathVariable String category,@PathVariable String publishTime,@PathVariable String tags,@PathVariable String views,@PathVariable String likes,@PathVariable String dislikes,@PathVariable String comments,@PathVariable String thumbnailLink,@PathVariable String commentsDisabled,@PathVariable String ratingsDisabled,@PathVariable String videoErrorOrRemoved,@PathVariable String description){
        System.out.println("Adding new data");
//        System.out.println(videoID);
//        System.out.println(trendingDate);
//        System.out.println(title);
//        System.out.println(channelTitle);
//        System.out.println(category);
//        System.out.println(publishTime);
//        System.out.println(tags);
//        System.out.println(views);
//        System.out.println(dislikes);
//        System.out.println(comments);
//        System.out.println(thumbnailLink);
//        System.out.println(ratingsDisabled);
//        System.out.println(videoErrorOrRemoved);
//        System.out.println(description);
        entityService.insertData(videoID,trendingDate,title,channelTitle,category,publishTime,tags,views,likes,dislikes,comments,thumbnailLink,commentsDisabled,ratingsDisabled,videoErrorOrRemoved,description);
        return new ResponseEntity<>("Data inserted", HttpStatus.OK);
    }

    @RequestMapping(value = "/restore/{filePath}", method = RequestMethod.POST)
    public ResponseEntity<String> restoreData(@PathVariable String filePath) throws IOException {
        System.out.println("Restoring data");
        entityService.restore(filePath);
        return new ResponseEntity<>("Restore initiated", HttpStatus.OK);
    }


}

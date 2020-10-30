package com.bitnbytes.ytanalyticsserver.database;

import com.bitnbytes.ytanalyticsserver.utils.CsvReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Component("entityManager")
public class EntityManager {
    private List<Entity> entities = new ArrayList<>();
    private final List<Entity> filteredList = new ArrayList<>();
    private final CsvReader csvReader;

    private void loadData(String filePath) throws IOException{
//        if(filePath.charAt(0) == '{'){
//            this.csvReader.read(filePath);
//        }else{
//            this.csvReader.read(filePath);
//        }
        this.csvReader.read(filePath);
        entities.clear();
        entities.addAll(this.csvReader.getData());
    }

    @Autowired
    public EntityManager(CsvReader csvReader) throws IOException {
        this.csvReader = csvReader;
        loadData("/home/renzo/USvideos.csv");
    }

    public List<Entity> getAllEntities(){
        return entities;
    }

    public List<Entity> getEntitiesByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes){
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
            if((channelNameParam.equals("") || entity.channelTitle.equals(channelNameParam)) && (categoryParam.equals("") || categoryParam.equals("None") || (entity.getCategory()).equals(categoryParam)) && (commentsDisabledParam.equals("") || commentsDisabled.equals("null")|| entity.commentsDisabled == commentsToggle)&& (videoNameParam.equals("") || entity.title.equals(videoNameParam)) && (viewsParam.equals("") || entity.views >= Integer.parseInt(viewsParam)) && (likesParam.equals("") || entity.likes >= Integer.parseInt(likesParam)) && (dislikesParam.equals("") || entity.dislikes >= Integer.parseInt(dislikesParam))){
                filteredList.add(entity);
            }
        }

        System.out.println(filteredList.size());

        return filteredList;
    }

    public void backup(String filePath) {
        String filePathParsed = filePath.substring(1, filePath.length() - 1);
        filePathParsed = filePathParsed.replaceAll("%2F", "/");
        System.out.println(filePathParsed);

    	ArrayList<String> data = new ArrayList<>();
    	data.add("video_id,trending_date,title,channel_title,category_id,publish_time,tags,views,likes,dislikes,comment_count,thumbnail_link,comments_disabled,ratings_disabled,video_error_or_removed,description");
    	entities.forEach(e -> data.add(e.getDataCSV()));
    	

		try {
			FileWriter writer = new FileWriter(filePathParsed);
			data.forEach(s -> {
				try {
					writer.write(s);
					writer.write('\n');
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			});
			writer.close();
		}catch(IOException e) {
			e.printStackTrace();
		}
    }

    public void restore(String filePath) throws IOException{
        String parsedFilePath = filePath.substring(1, filePath.length() - 1);
        parsedFilePath = parsedFilePath.replaceAll("%2F", "/");
        loadData(parsedFilePath);
    }

    public void insertData(String videoID, String trendingDate, String title, String channelTitle, String category, String publishTime, String tags, String views, String likes, String dislikes, String comments, String thumbnailLink, String commentsDisabled, String ratingsDisabled, String videoErrorOrRemoved, String description) {
        System.out.println(entities.size());
        String pvideoID = videoID.substring(1, videoID.length() - 1);
        DateTimeFormatter formatterTrendingDate = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter formatterPublishDate = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
        LocalDate ptrendingDate = LocalDate.parse(trendingDate.substring(1, trendingDate.length()-1),formatterTrendingDate);
        String ptitle = title.substring(1, title.length() - 1);
        String pchannelTitle = channelTitle.substring(1, channelTitle.length() - 1);
        String pcategory = category.substring(1, category.length()-1);//
        LocalDateTime ppublishTime = LocalDateTime.parse(publishTime.substring(1, publishTime.length()-1),formatterPublishDate);
        ArrayList<String> ptags = new ArrayList<>();//
        int pviews = Integer.parseInt(views.substring(1,views.length()- 1));
        int plikes = Integer.parseInt(likes.substring(1, likes.length()-1));
        int pdislikes = Integer.parseInt(dislikes.substring(1, dislikes.length()-1));
        int pcommentCount = Integer.parseInt(comments.substring(1, comments.length()-1));
        String pthumbnailLink = thumbnailLink.substring(1, thumbnailLink.length() - 1);
        boolean pcommentsDisabled = commentsDisabled.substring(1, commentsDisabled.length() - 1).equals("false");
        boolean pratingsDisabled = ratingsDisabled.substring(1, ratingsDisabled.length() - 1).equals("false");
        boolean pvideoErrorOrRemoved = videoErrorOrRemoved.substring(1, videoErrorOrRemoved.length()-1).equals("false");
        String pdescription = description.substring(1, description.length()-1);

        entities.add(new Entity(pvideoID,ptrendingDate,ptitle,pchannelTitle,pcategory,ppublishTime,ptags,pviews,plikes,pdislikes,pcommentCount,pthumbnailLink,pcommentsDisabled,pratingsDisabled,pvideoErrorOrRemoved,pdescription));
        System.out.println(entities.size());
    }

    public void removeEntity(String videoID) {
        String pvideoID = videoID.substring(1, videoID.length() -1 );
        entities.removeIf(entity -> entity.videoID.equals(pvideoID));
    }

    public void updateEntity(String videoID, String oldViews, String views, String likes, String dislikes) {
        String pvideoID = videoID.substring(1, videoID.length() - 1);
        int poldViews = Integer.parseInt(oldViews.substring(1, oldViews.length() -1));
        int pviews = Integer.parseInt(views.substring(1, views.length()-1));
        int plikes = Integer.parseInt(likes.substring(1, likes.length() -1));
        int pdislikes = Integer.parseInt(dislikes.substring(1, dislikes.length()-1));
        int entityIdx = 0;
        Entity replace = null;

        try {
            replace = new Entity("");
        } catch (Exception e) {
            e.printStackTrace();
        }

        for(Entity entity: entities){
            if(entity.videoID.equals(pvideoID) && entity.views == poldViews){
                entityIdx = entities.indexOf(entity);
                replace = new Entity(entity);
                replace.views = pviews;
                replace.likes = plikes;
                replace.dislikes = pdislikes;
            }
        }

        entities.set(entityIdx, replace);
    }
}
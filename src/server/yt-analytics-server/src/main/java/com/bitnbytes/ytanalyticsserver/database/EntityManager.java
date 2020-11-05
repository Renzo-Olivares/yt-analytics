package com.bitnbytes.ytanalyticsserver.database;

import com.bitnbytes.ytanalyticsserver.utils.CsvReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Component("entityManager")
public class EntityManager {
    private List<Entity> entities = new ArrayList<>();
    private final List<Entity> filteredList = new ArrayList<>();
    private final CsvReader csvReader;

    private void loadData(String filePath) throws IOException{
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
            if((channelNameParam.equals("") || entity.channelTitle.toLowerCase().contains(channelNameParam.toLowerCase())) &&
                    (categoryParam.equals("") || (entity.getCategory()).equals(categoryParam)) &&
                    (entity.commentsDisabled == commentsToggle) &&
                    (videoNameParam.equals("") || entity.title.toLowerCase().contains(videoNameParam.toLowerCase())) &&
                    (viewsParam.equals("") || entity.views >= Integer.parseInt(viewsParam)) &&
                    (likesParam.equals("") || entity.likes >= Integer.parseInt(likesParam)) &&
                    (dislikesParam.equals("") || entity.dislikes >= Integer.parseInt(dislikesParam))){
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
        String pcategory = category.substring(1, category.length()-1);
        LocalDateTime ppublishTime = LocalDateTime.parse(publishTime.substring(1, publishTime.length()-1),formatterPublishDate);
        String ptagss = tags.substring(1, tags.length() - 1);
        System.out.println(ptagss);
        List<String> temp = Arrays.asList(ptagss.split("\\s*,\\s*"));
        ArrayList<String> ptags = new ArrayList<>(temp);
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

    public void removeEntity(String videoID, String views) {
        String pvideoID = videoID.substring(1, videoID.length() -1 );
        int pviews = Integer.parseInt(views.substring(1, views.length() - 1));
        entities.removeIf(entity -> entity.videoID.equals(pvideoID) && entity.views == pviews);
    }

    public void updateEntity(String videoID, String oldViews, String views, String likes, String dislikes) {
        String pvideoID = videoID.substring(1, videoID.length() - 1);
        int poldViews = Integer.parseInt(oldViews.substring(1, oldViews.length() -1));
        int pviews = Integer.parseInt(views.substring(1, views.length()-1));
        int plikes = Integer.parseInt(likes.substring(1, likes.length() -1));
        int pdislikes = Integer.parseInt(dislikes.substring(1, dislikes.length()-1));
        int entityIdx = 0;
        Entity replace = null;

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

    public List<Entity> getTopTrendingByViews(int n) {
        List<Entity> sortedList = getTopTrendingByViews(this.entities);
        if(n > sortedList.size())return sortedList;
		return sortedList.subList(0, n);
    }
    
    public List<Entity> getTopTrendingByViews() {
		return getTopTrendingByViews(this.entities);
    }
	
	public List<Entity> getTopTrendingByViews(int n, List<Entity> entities) {
        List<Entity> sortedList = getTopTrendingByViews(entities);
        if(n > sortedList.size())return sortedList;
		return sortedList.subList(0, n);
	}

	public List<Entity> getTopTrendingByViews(List<Entity> entities) {
		// sort list by views
        List<Entity> sortedList = new ArrayList<Entity>(entities);
//		for(int j = 0; j < sortedList.size(); j++) {
//			int k = j;
//			for (int i = j + 1; i < sortedList.size(); i++) {
//				if(sortedList.get(k).getViews() < sortedList.get(i).getViews()) {
//					k = i;
//				}
//			}
//			Collections.swap(sortedList, j, k);
//		}
		sortedList.sort((Entity e1, Entity e2)->e2.getViews()-e1.getViews()); 
		return sortedList;
	}

	public List<Entity> getTopTrendingByLikes(int n) {
        List<Entity> sortedList = getTopTrendingByLikes(this.entities);
        if(n > sortedList.size())return sortedList;
		return sortedList.subList(0, n);
    }
    
    public List<Entity> getTopTrendingByLikes() {
		return getTopTrendingByLikes(this.entities);
    }
	
	public List<Entity> getTopTrendingByLikes(int n, List<Entity> entities) {
        List<Entity> sortedList = getTopTrendingByLikes(entities);
        if(n > sortedList.size())return sortedList;
		return sortedList.subList(0, n);
	}

	public List<Entity> getTopTrendingByLikes(List<Entity> entities) {
		// sort list by number of likes
        List<Entity> sortedList = new ArrayList<Entity>(entities);
//		for(int j = 0; j < sortedList.size(); j++) {
//			int k = j;
//			for (int i = j + 1; i < sortedList.size(); i++) {
//				if(sortedList.get(k).getLikes() < sortedList.get(i).getLikes()) {
//					k = i;
//				}
//			}
//			Collections.swap(sortedList, j, k);
//		}
		sortedList.sort((Entity e1, Entity e2)->e2.getLikes()-e1.getLikes()); 
		return sortedList;

	}

	public List<Entity> getTopTrendingByLikeDislikeRatio(int n) {
        List<Entity> sortedList = getTopTrendingByLikeDislikeRatio(this.entities);
        if(n > sortedList.size())return sortedList;
		return sortedList.subList(0, n);
    }
    
    public List<Entity> getTopTrendingByLikeDislikeRatio() {
		return getTopTrendingByLikeDislikeRatio(this.entities);
    }
	
	public List<Entity> getTopTrendingByLikeDislikeRatio(int n, List<Entity> entities) {
        List<Entity> sortedList = getTopTrendingByLikeDislikeRatio(entities);
        if(n > sortedList.size())return sortedList;
		return sortedList.subList(0, n);
	}

	public List<Entity> getTopTrendingByLikeDislikeRatio(List<Entity> entities) {
		// sort list by like/dislike ratio
        List<Entity> sortedList = new ArrayList<Entity>(entities);
		for(int j = 0; j < sortedList.size(); j++) {
			int k = j;
			for (int i = j + 1; i < sortedList.size(); i++) {
				if(sortedList.get(k).LikeDislikeRatio() < sortedList.get(i).LikeDislikeRatio()) {
					k = i;
				}else if(sortedList.get(k).LikeDislikeRatio() == sortedList.get(i).LikeDislikeRatio()) {
					if(sortedList.get(k).getLikes() < sortedList.get(i).getLikes()) {
						k = i;
					}
				}
			}
			Collections.swap(sortedList, j, k);
		}
		return sortedList;

    }

    public List<TrendingChartData> getAnalyticsByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes, String type) {
        loadFilteredList(channelName, category, commentsDisabled, videoName, views, likes, dislikes);
        if(type.equals("Categories")){
            return getTopTrendingCategories();
        }else{
            return getTopTrendingChannels();
        }
    }

    void loadFilteredList(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes){
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
            if((channelNameParam.equals("") || entity.channelTitle.toLowerCase().contains(channelNameParam.toLowerCase())) &&
                    (categoryParam.equals("") || (entity.getCategory()).equals(categoryParam)) &&
                    (entity.commentsDisabled == commentsToggle) &&
                    (videoNameParam.equals("") || entity.title.toLowerCase().contains(videoNameParam.toLowerCase())) &&
                    (viewsParam.equals("") || entity.views >= Integer.parseInt(viewsParam)) &&
                    (likesParam.equals("") || entity.likes >= Integer.parseInt(likesParam)) &&
                    (dislikesParam.equals("") || entity.dislikes >= Integer.parseInt(dislikesParam))){
                filteredList.add(entity);
            }
        }
    }

    public List<TrendingChartData> getTopTrendingChannels() {
        List<TrendingChartData> mockData = new ArrayList<TrendingChartData>();
        mockData.add(new TrendingChartData("Comedy", 200));
        mockData.add(new TrendingChartData("Entertainment", 400));
        mockData.add(new TrendingChartData("Gaming", 400));
        mockData.add(new TrendingChartData("Movies", 500));
        mockData.add(new TrendingChartData("Music", 700));
        mockData.add(new TrendingChartData("Shows", 1000));
        return mockData;
    }

    public List<TrendingChartData> getTopTrendingCategories() {
        Map<String, Integer> topCategories = new HashMap<>();
            for (int i = 1; i < 33; i++) {
                switch (i) {
                    case 1:
                        topCategories.put("Film & Animation", 0);
                    case 2:
                        topCategories.put("Autos & Vehicles", 0);
                    case 3:
                        topCategories.put("Music", 0);
                    case 4:
                        topCategories.put("Pets & Animals", 0);
                    case 5:
                        topCategories.put("Sports", 0);
                    case 6:
                        topCategories.put("Short Movies", 0);
                    case 7:
                        topCategories.put("Travel & Events", 0);
                    case 8:
                        topCategories.put("Gaming", 0);
                    case 9:
                        topCategories.put("Videoblogging", 0);
                    case 10:
                        topCategories.put("People & Blogs", 0);
                    case 11:
                        topCategories.put("Comedy", 0);
                    case 12:
                        topCategories.put("Entertainment", 0);
                    case 13:
                        topCategories.put("News & Politics", 0);
                    case 14:
                        topCategories.put("Howto & Style", 0);
                    case 15:
                        topCategories.put("Education", 0);
                    case 16:
                        topCategories.put("Science & Technology", 0);
                    case 17:
                        topCategories.put("Nonprofits & Activism", 0);
                    case 18:
                        topCategories.put("Movies", 0);
                    case 19:
                        topCategories.put("Anime/Animation", 0);
                    case 20:
                        topCategories.put("Action/Adventure", 0);
                    case 21:
                        topCategories.put("Classics", 0);
                    case 22:
                        topCategories.put("Comedy", 0);
                    case 23:
                        topCategories.put("Documentary", 0);
                    case 24:
                        topCategories.put("Drama", 0);
                    case 25:
                        topCategories.put("Family", 0);
                    case 26:
                        topCategories.put("Foreign", 0);
                    case 27:
                        topCategories.put("Horror", 0);
                    case 28:
                        topCategories.put("Sci-Fi/Fantasy", 0);
                    case 29:
                        topCategories.put("Thriller", 0);
                    case 30:
                        topCategories.put("Shorts", 0);
                    case 31:
                        topCategories.put("Shows", 0);
                    case 32:
                        topCategories.put("Trailers", 0);
                    default:
                        topCategories.put("ERROR", 0);
                }

            }

        for(Entity entity : filteredList){
            topCategories.put(entity.getCategory(), topCategories.get(entity.getCategory()) + 1);
        }

        List<TrendingChartData> realData = new ArrayList<TrendingChartData>();

        int max1 = 0;
        String max1Cat = "";

        for(Map.Entry<String, Integer> pair : topCategories.entrySet()){
            if(pair.getValue() > max1){
                max1 = pair.getValue();
                max1Cat = pair.getKey();
            }
        }

        realData.add(new TrendingChartData(max1Cat, max1));
        topCategories.remove(max1Cat, max1);

        int max2 = 0;
        String max2Cat = "";

        for(Map.Entry<String, Integer> pair : topCategories.entrySet()){
            if(pair.getValue() > max2){
                max2 = pair.getValue();
                max2Cat = pair.getKey();
            }
        }

        realData.add(new TrendingChartData(max2Cat, max2));

        topCategories.remove(max2Cat, max2);

        int max3 = 0;
        String max3Cat = "";

        for(Map.Entry<String, Integer> pair : topCategories.entrySet()){
            if(pair.getValue() > max3){
                max3 = pair.getValue();
                max3Cat = pair.getKey();
            }
        }

        realData.add(new TrendingChartData(max3Cat, max3));
        topCategories.remove(max3Cat, max3);

        int max4 = 0;
        String max4Cat = "";

        for(Map.Entry<String, Integer> pair : topCategories.entrySet()){
            if(pair.getValue() > max4){
                max4 = pair.getValue();
                max4Cat = pair.getKey();
            }
        }

        realData.add(new TrendingChartData(max4Cat, max4));
        topCategories.remove(max4Cat, max4);

        int max5 = 0;
        String max5Cat = "";

        for(Map.Entry<String, Integer> pair : topCategories.entrySet()){
            if(pair.getValue() > max5){
                max5 = pair.getValue();
                max5Cat = pair.getKey();
            }
        }
        realData.add(new TrendingChartData(max5Cat, max5));
        topCategories.remove(max5Cat, max5);

        int max6 = 0;
        String max6Cat = "";

        for(Map.Entry<String, Integer> pair : topCategories.entrySet()){
            if(pair.getValue() > max6){
                max6 = pair.getValue();
                max6Cat = pair.getKey();
            }
        }
        realData.add(new TrendingChartData(max6Cat, max6));

        topCategories.remove(max6Cat, max6);



        return realData;

//        List<TrendingChartData> mockData = new ArrayList<TrendingChartData>();
//        mockData.add(new TrendingChartData("PewDiePie", 200));
//        mockData.add(new TrendingChartData("JerryRigEverything", 400));
//        mockData.add(new TrendingChartData("CNN", 400));
//        mockData.add(new TrendingChartData("KSI", 500));
//        mockData.add(new TrendingChartData("Logan Paul", 700));
//        mockData.add(new TrendingChartData("MKBHD", 1000));
//        return mockData;
    }
}
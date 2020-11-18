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
import java.util.stream.Collector;
import java.util.stream.Collectors;

@Component("entityManager")
public class EntityManager {
    //deprecated
    private List<Entity> entities = new ArrayList<>();
    private final List<Entity> filteredList = new ArrayList<>();
    //deprecated

    private final CsvReader csvReader;

    private Set<EntityN> entitiesN = new HashSet<>();
    private Set<EntityN> filteredSet = new HashSet<>();

    private void loadData(String filePath) throws IOException{
        this.csvReader.read(filePath);
        entitiesN.clear();
        entitiesN.addAll(this.csvReader.getDataset());
    }

    @Autowired
    public EntityManager(CsvReader csvReader) throws IOException {
        this.csvReader = csvReader;
        loadData("/home/renzo/USvideos.csv");
    }

    public List<EntityN> getAllEntities(){
        return new ArrayList<>(entitiesN);
    }


    //Set functions
    public List<EntityN> getEntitiesNByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes){
        return entitiesN.stream().filter(e -> filter(e, channelName, category, commentsDisabled, videoName, views, likes, dislikes)).collect(Collectors.toList());
    }

    private boolean filter(EntityN entity, String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes){
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

        return (channelNameParam.equals("") || ((String) entity.get("channelTitle")).toLowerCase().contains(channelNameParam.toLowerCase())) &&
                (categoryParam.equals("") || entity.get("category").equals(categoryParam)) &&
                ((boolean) entity.get("commentsDisabled") == commentsToggle) &&
                (videoNameParam.equals("") || ((String) entity.get("title")).toLowerCase().contains(videoNameParam.toLowerCase())) &&
                (viewsParam.equals("") || (int) entity.get("views") >= Integer.parseInt(viewsParam)) &&
                (likesParam.equals("") || (int) entity.get("likes") >= Integer.parseInt(likesParam)) &&
                (dislikesParam.equals("") || (int) entity.get("dislikes") >= Integer.parseInt(dislikesParam));
//        return (channelName.equals("") || ((String) entity.get("channelTitle")).toLowerCase().contains(channelName.toLowerCase())) &&
//                (category.equals("") || entity.get("categoryID").equals(category)) &&
//                ((boolean) entity.get("commentsDisabled") == commentsToggle) &&
//                (videoName.equals("") || ((String) entity.get("title")).toLowerCase().contains(videoName.toLowerCase())) &&
//                (views.equals("") || (int) entity.get("views") >= Integer.parseInt(views)) &&
//                (likes.equals("") || (int) entity.get("likes") >= Integer.parseInt(likes)) &&
//                (dislikes.equals("") || (int) entity.get("dislikes") >= Integer.parseInt(dislikes));
    }

    public void removeEntityN(String videoID, String views) {
        entitiesN.removeIf(entity -> entity.get("videoID").equals(videoID) && (int) entity.get("views") == Integer.parseInt(views));
    }

    public void insertEntityN(String videoID, String trendingDate, String title, String channelTitle, String category, String publishTime, String tags, String views, String likes, String dislikes, String comments, String thumbnailLink, String commentsDisabled, String ratingsDisabled, String videoErrorOrRemoved, String description) {
        System.out.println(entitiesN.size());
        DateTimeFormatter formatterTrendingDate = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter formatterPublishDate = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
        LocalDate ptrendingDate = LocalDate.parse(trendingDate,formatterTrendingDate);
        LocalDateTime ppublishTime = LocalDateTime.parse(publishTime,formatterPublishDate);
        List<String> temp = Arrays.asList(tags.split("\\s*,\\s*"));
        ArrayList<String> ptags = new ArrayList<>(temp);

        entitiesN.add(new EntityN(videoID,ptrendingDate,title,channelTitle,category,ppublishTime,ptags,Integer.parseInt(views),Integer.parseInt(likes),Integer.parseInt(dislikes),Integer.parseInt(comments),thumbnailLink,commentsDisabled.equals("false"),ratingsDisabled.equals("false"),videoErrorOrRemoved.equals("false"),description));
        System.out.println(entitiesN.size());
    }

    public void updateEntityN(String videoID, String oldViews, String views, String likes, String dislikes) {
        int poldViews = Integer.parseInt(oldViews);
        int pviews = Integer.parseInt(views);
        int plikes = Integer.parseInt(likes);
        int pdislikes = Integer.parseInt(dislikes);

        EntityN updated = entitiesN.stream().filter(e -> e.get("videoID").equals(videoID) && ((int) e.get("views")) == poldViews).collect(Collectors.toList()).get(0);
        entitiesN.remove(updated);
        updated.put("views", pviews);
        updated.put("likes", plikes);
        updated.put("dislikes", pdislikes);
        entitiesN.add(updated);
    }

    public void backup(String filePath) {
        String filePathParsed = filePath.substring(1, filePath.length() - 1);
        filePathParsed = filePathParsed.replaceAll("%2F", "/");
        System.out.println(filePathParsed);

    	ArrayList<String> data = new ArrayList<>();
    	data.add("video_id,trending_date,title,channel_title,category_id,publish_time,tags,views,likes,dislikes,comment_count,thumbnail_link,comments_disabled,ratings_disabled,video_error_or_removed,description");
    	entitiesN.forEach(e -> data.add(e.getDataCSV()));
    	

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

    //Set Functions

	public List<EntityN> getTopTrendingByLikeDislikeRatio(int n) {
        List<EntityN> sortedList = getTopTrendingByLikeDislikeRatioHelper(n);
        if(n > sortedList.size())return sortedList;
		return sortedList.subList(0, n);
    }

    public List<EntityN> getTopTrendingByLikeDislikeRatioHelper(int n) {
        // sort list by like/dislike ratio

        Map<String, Double> topTrending = new HashMap<>();

        for(EntityN entity : entitiesN){
            try{
                topTrending.put((String) entity.get("videoID"), (double) ((int) entity.get("likes") / (int) entity.get("dislikes")));
            }catch (ArithmeticException e){
                topTrending.put((String) entity.get("videoID"), 0.0);
            }
        }

        PriorityQueue<Map.Entry<String,Double>> topN = topN(topTrending, n);

        System.out.println(topN.size());
        List<EntityN> realData = new ArrayList<>();

        while(topN.size() > 0){
            Map.Entry<String, Double> single = topN.poll();
            realData.add(entitiesN.stream().filter(e -> ((String) e.get("videoID")).contains(single.getKey())).findFirst().get());
        }


        return realData;
    }

    public List<TrendingChartData> getAnalyticsByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes, String type) {
        loadFilteredSet(channelName, category, commentsDisabled, videoName, views, likes, dislikes);
        if(type.equals("Categories")){
            return getTopTrendingCategories();
        }else if(type.equals("Channels")){
            return getTopTrendingChannels();
        }else{
            return getTagAverageCategory();
        }
    }

    void loadFilteredSet(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes){
        filteredSet = entitiesN.stream().filter(e -> filter(e, channelName, category, commentsDisabled, videoName, views, likes, dislikes)).collect(Collectors.toSet());
    }

    public List<TrendingChartData> getTopTrendingChannels() {
        Map<String, Integer> topChannels = new HashMap<>();

        for(EntityN entity : filteredSet){
            topChannels.put((String) entity.get("channelTitle"), 0);
        }

        for(EntityN entity : filteredSet){
            topChannels.put((String) entity.get("channelTitle"), topChannels.get(entity.get("channelTitle")) + 1);
        }

        return getTrendingChartData(topChannels);
    }

    private List<TrendingChartData> getTrendingChartData(Map<String, Integer> topChannels) {
        PriorityQueue<Map.Entry<String,Integer>> topN = topN(topChannels, 6);
        List<TrendingChartData> realData = new ArrayList<>();

        while(topN.size() > 0){
            Map.Entry<String, Integer> single = topN.poll();
            realData.add(new TrendingChartData(single.getKey(), single.getValue()));
        }

        return realData;
    }

    private <K, V extends Comparable<? super V>> PriorityQueue<Map.Entry<K,V>> topN(Map<K, V> map, int n){
        Comparator<? super Map.Entry<K,V>> comparator = (Comparator<Map.Entry<K, V>>) (t0, t1) -> {
            V a0 = t0.getValue();
            V a1 = t1.getValue();
            return a0.compareTo(a1);
        };

        PriorityQueue<Map.Entry<K,V>> top = new PriorityQueue<>(n, comparator);

        for (Map.Entry<K,V> entry : map.entrySet()){
            top.offer(entry);
            while(top.size() > n){
                top.poll();
            }
        }

        return top;
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

        for(EntityN entity : filteredSet){
            topCategories.put((String) entity.get("category"), topCategories.get(entity.get("category")) + 1);
        }

        return getTrendingChartData(topCategories);
    }

    public List<TrendingChartData> getTagAverageCategory(){
        List<TrendingChartData> chart = new ArrayList<>(), numVideos = new ArrayList<>();

        for(Entity e : this.filteredList) {
            boolean found = false;
            for(TrendingChartData t : chart) {
                if(t.getxVal().equals(e.getCategory())) {
                    t.setyVal(t.getyVal() + e.getTags().size());
                    found = true;
                    break;
                }
            }
            if(!found) {
                TrendingChartData t = new TrendingChartData(e.getCategory(), e.getTags().size());
                TrendingChartData n = new TrendingChartData(e.getCategory(), 1);
                chart.add(t);
                numVideos.add(n);
            }else {
                for(TrendingChartData t : numVideos) {
                    if(t.getxVal().equals(e.getCategory())) {
                        t.setyVal(t.getyVal() + 1);
                        break;
                    }
                }
            }
        }
        for(TrendingChartData t : chart) {
            for(TrendingChartData n : numVideos) {
                if(t.getxVal().equals(n.getxVal())) {
                    t.setyVal(t.getyVal()/n.getyVal());
                    break;
                }
            }

        }
        chart.sort((TrendingChartData t1, TrendingChartData t2)->t2.getyVal()-t1.getyVal());
        return chart.subList(0,6);
    }

    public List<List<Entity>> getCompressDuplicatedVideos(List<Entity> list){
        List<List<Entity>> mappedVideos = new ArrayList<>();
        for(Entity e : list) {
            boolean found = false;
            for(List<Entity> l : mappedVideos) {
                if(l.get(0).getVideoID().equals(e.getVideoID())) {
                    l.add(e);
                    found = true;
                    break;
                }
            }
            if(!found) {
                List<Entity> newVal = new ArrayList<>();
                newVal.add(e);
                mappedVideos.add(newVal);
            }
        }
        return mappedVideos;
    }

    public List<Entity> getTrendingNDays(int n){
        return getTrendingNDaysUnCompressedArg(this.entities, n);
    }

    public List<Entity> getTrendingNDaysUnCompressedArg(List<Entity> list, int n){
        return getTrendingNDaysCompressedArg(getCompressDuplicatedVideos(list), n);
    }

    public List<Entity> getTrendingNDaysCompressedArg(List<List<Entity>> compressedList, int n){//returns only the first video.
        List<Entity> list = new ArrayList<>();
        if(n < 1)return list;
        for(List<Entity> l : compressedList) {
            if(l.size() == n) {
                list.add(l.get(0));
            }
        }
        return list;
    }
}
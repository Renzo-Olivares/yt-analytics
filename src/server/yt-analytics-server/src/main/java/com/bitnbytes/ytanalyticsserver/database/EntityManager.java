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
import java.util.stream.Collectors;

@Component("entityManager")
public class EntityManager {
    private final CsvReader csvReader;

    private Set<Entity> entitiesN = new HashSet<>();
    private Set<Entity> filteredSet = new HashSet<>();

    private void loadData(String filePath) throws IOException{
        this.csvReader.read(filePath);
        entitiesN.clear();
        entitiesN.addAll(this.csvReader.getDataset());
    }

    @Autowired
    public EntityManager(CsvReader csvReader) throws IOException {
        this.csvReader = csvReader;
        this.tagAverageStore = null;
        loadData("/home/renzo/USvideos.csv");
    }

    public Set<Entity> getAllEntities(){
        return entitiesN;
    }


    public Set<Entity> getEntitiesByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes){
        return entitiesN.stream().filter(e -> filter(e, channelName, category, commentsDisabled, videoName, views, likes, dislikes)).collect(Collectors.toSet());
    }

    private boolean filter(Entity entity, String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes){
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
        Entity remove = entitiesN.stream().filter(entity -> entity.get("videoID").equals(videoID) && (int) entity.get("views") == Integer.parseInt(views)).findFirst().get();
        updateTagAverageCategory(null, remove);
        entitiesN.remove(remove);
    }

    public void insertEntity(String videoID, String trendingDate, String title, String channelTitle, String category, String publishTime, String tags, String views, String likes, String dislikes, String comments, String thumbnailLink, String commentsDisabled, String ratingsDisabled, String videoErrorOrRemoved, String description) {
//        System.out.println(entitiesN.size());
        DateTimeFormatter formatterTrendingDate = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter formatterPublishDate = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
        LocalDate ptrendingDate = LocalDate.parse(trendingDate,formatterTrendingDate);
        LocalDateTime ppublishTime = LocalDateTime.parse(publishTime,formatterPublishDate);
        List<String> temp = Arrays.asList(tags.split("\\s*,\\s*"));
        ArrayList<String> ptags = new ArrayList<>(temp);

        Entity newEntity = new Entity(videoID,ptrendingDate,title,channelTitle,category,ppublishTime,ptags,Integer.parseInt(views),Integer.parseInt(likes),Integer.parseInt(dislikes),Integer.parseInt(comments),thumbnailLink,commentsDisabled.equals("false"),ratingsDisabled.equals("false"),videoErrorOrRemoved.equals("false"),description);
        updateTagAverageCategory(newEntity, null);
        entitiesN.add(newEntity);
//        System.out.println(entitiesN.size());
    }

    public void updateEntity(String videoID, String oldViews, String views, String likes, String dislikes) {
        int poldViews = Integer.parseInt(oldViews);
        int pviews = Integer.parseInt(views);
        int plikes = Integer.parseInt(likes);
        int pdislikes = Integer.parseInt(dislikes);

        Entity updated = entitiesN.stream().filter(e -> e.get("videoID").equals(videoID) && ((int) e.get("views")) == poldViews).collect(Collectors.toList()).get(0);
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

	public Set<Entity> getTopTrendingByLikeDislikeRatio(int n) {
        Set<Entity> sortedList = getTopTrendingByLikeDislikeRatioHelper(n);
		return sortedList;
    }

    public Set<Entity> getTopTrendingByLikeDislikeRatioHelper(int n) {
        Map<String, Double> topTrending = new HashMap<>();

        for(Entity entity : entitiesN){
            try{
                topTrending.put((String) entity.get("videoID"), (double) ((int) entity.get("likes") / ((int) entity.get("likes") + (int) entity.get("dislikes"))));
            }catch (ArithmeticException e){
                topTrending.put((String) entity.get("videoID"), 0.0);
            }
        }

        PriorityQueue<Map.Entry<String,Double>> topN = topN(topTrending, n);

//        System.out.println(topN.size());
        Set<Entity> realData = new LinkedHashSet<>();

        while(topN.size() > 0){
            Map.Entry<String, Double> single = topN.poll();
            realData.add(entitiesN.stream().filter(e -> ((String) e.get("videoID")).contains(single.getKey())).findFirst().orElse(null));
        }

        return realData;
    }

    public Set<TrendingChartData> getAnalyticsByFilter(String channelName, String category, String commentsDisabled, String videoName, String views, String likes, String dislikes, String type) {
        if(type.equals("Tags") && tagAverageStore == null){
            loadFilteredSet(channelName, category, commentsDisabled, videoName, views, likes, dislikes);
        }else if(!type.equals("Tags")){
            loadFilteredSet(channelName, category, commentsDisabled, videoName, views, likes, dislikes);
        }

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

    public Set<TrendingChartData> getTopTrendingChannels() {
        Map<String, Integer> topChannels = new HashMap<>();

        for(Entity entity : filteredSet){
            topChannels.put((String) entity.get("channelTitle"), 0);
        }

        for(Entity entity : filteredSet){
            topChannels.put((String) entity.get("channelTitle"), topChannels.get(entity.get("channelTitle")) + 1);
        }

        return getTrendingChartData(topChannels);
    }

    private Set<TrendingChartData> getTrendingChartData(Map<String, Integer> topChannels) {
        PriorityQueue<Map.Entry<String,Integer>> topN = topN(topChannels, 6);
        Set<TrendingChartData> realData = new LinkedHashSet<>();

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

    public Set<TrendingChartData> getTopTrendingCategories() {
        Map<String, Integer> topCategories = new HashMap<>();

        for(Entity entity : filteredSet){
            if(!topCategories.containsKey(entity.get("category"))){
                topCategories.put((String) entity.get("category"), 1);
            }else{
                topCategories.put((String) entity.get("category"), topCategories.get(entity.get("category")) + 1);
            }
        }

        return getTrendingChartData(topCategories);
    }

    public Set<Entity> getTrendingNDays(int n){
        Map<String, Integer> topVideos = new HashMap<>();

        for(Entity entity : entitiesN){
            if(topVideos.containsKey(entity.get("videoID"))){
                topVideos.put((String) entity.get("videoID"), topVideos.get(entity.get("videoID")) + 1);
            }else{
                topVideos.put((String) entity.get("videoID"), 1);
            }
        }

        Set<Entity> realData = new LinkedHashSet<>();
        for(Map.Entry<String,Integer> compressedEntity: topVideos.entrySet()){
            if(compressedEntity.getValue() == n){
                realData.add(entitiesN.stream().filter(e -> e.get("videoID").equals(compressedEntity.getKey())).findFirst().get());
            }
        }

        return realData;
    }

    private Map<Integer, TagAverageStore> tagAverageStore;


    public Set<TrendingChartData> getTagAverageCategory() {
        Set<TrendingChartData> chart = new LinkedHashSet<>();
        if (tagAverageStore == null) {
            System.out.println("Setting up cache for first time");
            tagAverageStore = new HashMap<>();
            int categoryID, tags;

            for (Entity e : this.filteredSet) {
                categoryID = e.getCategoryId((String) e.get("category"));
                tags = ((ArrayList<String>) e.get("tags")).size();

                if(!tagAverageStore.containsKey(categoryID)){
                    tagAverageStore.put(categoryID, new TagAverageStore(0,0,categoryID));
                }

                tagAverageStore.get(categoryID).incrementVideoCount();
                tagAverageStore.get(categoryID).incrementTotalTagCount(tags);
            }
        }

        System.out.println("Incrementing");

        tagAverageStore.forEach((key, value) -> chart.add(new TrendingChartData(value.getCategory(), value.getTagAverage())));

        List<TrendingChartData> temp = new ArrayList<>(chart);
        temp.sort((TrendingChartData t1, TrendingChartData t2) -> t2.getyVal() - t1.getyVal());
        if(temp.size() > 6){
            temp = temp.subList(0,6);
        }
        Collections.reverse(temp);
        chart.clear();
        chart.addAll(temp);
        return chart;
    }

    private void updateTagAverageCategory(Entity insert, Entity remove) {
        if ((insert == null && remove == null) || this.tagAverageStore == null) {
            return;// nothing to update
        }
        int categoryID;
        int tags;
        if (insert == null) {
            categoryID = remove.getCategoryId((String) remove.get("category"));
            tags = ((ArrayList<String>) remove.get("tags")).size();
            tagAverageStore.get(categoryID).decrementVideoCount();
            tagAverageStore.get(categoryID).decrementTotalTagCount(tags);
            return;
        }
        if (remove == null) {
            categoryID = insert.getCategoryId((String) insert.get("category"));
            tags = ((ArrayList<String>) insert.get("tags")).size();
            tagAverageStore.get(categoryID).incrementVideoCount();
            tagAverageStore.get(categoryID).incrementTotalTagCount(tags);
            return;
        }
        categoryID = insert.getCategoryId((String) insert.get("category"));
        tags = ((ArrayList<String>) insert.get("tags")).size();
        tagAverageStore.get(categoryID).incrementVideoCount();
        tagAverageStore.get(categoryID).incrementTotalTagCount(tags);
        categoryID = remove.getCategoryId((String) remove.get("category"));
        tags = ((ArrayList<String>) remove.get("tags")).size();
        tagAverageStore.get(categoryID).decrementVideoCount();
        tagAverageStore.get(categoryID).decrementTotalTagCount(tags);
    }
    //Needs update
}
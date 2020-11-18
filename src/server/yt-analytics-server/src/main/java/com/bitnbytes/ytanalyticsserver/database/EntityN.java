package com.bitnbytes.ytanalyticsserver.database;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;

public class EntityN extends LinkedHashMap<String, Object> {
    public EntityN(ArrayList<String> rawData){
        this.put("videoID", rawData.get(0));

        int[] date = { 0, 0, 0 };
        for (int i = 0; i < date.length; i++) {
            date[i] = Integer.parseInt(rawData.get(1).split("\\.")[i]);
        }
        // date = {YY, DD, MM}
        date[0] += 2000;
        // date = {YYYY, DD, MM}

        this.put("trendingDate", LocalDate.of(date[0], date[2], date[1]));
        this.put("title", rawData.get(2));
        this.put("channelTitle", rawData.get(3));
        this.put("category", getCategory(Integer.parseInt(rawData.get(4))));
        this.put("publishTime", LocalDateTime.ofInstant(Instant.parse(rawData.get(5)), ZoneId.of("UTC")));
        this.put("tags", new ArrayList<>(Arrays.asList(rawData.get(6).split("\\|"))));
        this.put("views", Integer.parseInt(rawData.get(7)));
        this.put("likes", Integer.parseInt(rawData.get(8)));
        this.put("dislikes", Integer.parseInt(rawData.get(9)));
        this.put("commentCount", Integer.parseInt(rawData.get(10)));
        this.put("thumbnailLink", rawData.get(11));
        this.put("commentsDisabled",Boolean.parseBoolean(rawData.get(12)));
        this.put("ratingsDisabled", Boolean.parseBoolean(rawData.get(13)));
        this.put("videoErrorOrRemoved", Boolean.parseBoolean(rawData.get(14)));
        this.put("description", rawData.get(15));
    }

    public EntityN() {}

    public EntityN(String videoID, LocalDate trendingDate, String title, String channelTitle, String category, LocalDateTime publishTime, ArrayList<String> tags, int views, int likes, int dislikes, int comments, String thumbnailLink, boolean commentsDisabled, boolean ratingsDisabled, boolean videoErrorOrRemoved, String description){
        this.put("videoID" , videoID);
        this.put("trendingDate", trendingDate);
        this.put("title",title);
        this.put("channelTitle",channelTitle);
        this.put("category", category);
        this.put("publishTime", publishTime);
        this.put("tags", tags);
        this.put("views", views);
        this.put("likes", likes);
        this.put("dislikes", dislikes);
        this.put("commentCount",comments);
        this.put("thumbnailLink",thumbnailLink);
        this.put("commentsDisabled", commentsDisabled);
        this.put("ratingsDisabled", ratingsDisabled);
        this.put("videoErrorOrRemoved",videoErrorOrRemoved);
        this.put("description",description);
    }

    private String getCategory(int categoryID) {
        switch (categoryID) {
            case 1:
                return "Film & Animation";
            case 2:
                return "Autos & Vehicles";
            case 10:
                return "Music";
            case 15:
                return "Pets & Animals";
            case 17:
                return "Sports";
            case 18:
                return "Short Movies";
            case 19:
                return "Travel & Events";
            case 20:
                return "Gaming";
            case 21:
                return "Videoblogging";
            case 22:
                return "People & Blogs";
            case 23:
                return "Comedy";
            case 24:
                return "Entertainment";
            case 25:
                return "News & Politics";
            case 26:
                return "Howto & Style";
            case 27:
                return "Education";
            case 28:
                return "Science & Technology";
            case 29:
                return "Nonprofits & Activism";
            case 30:
                return "Movies";
            case 31:
                return "Anime/Animation";
            case 32:
                return "Action/Adventure";
            case 33:
                return "Classics";
            case 34:
                return "Comedy";
            case 35:
                return "Documentary";
            case 36:
                return "Drama";
            case 37:
                return "Family";
            case 38:
                return "Foreign";
            case 39:
                return "Horror";
            case 40:
                return "Sci-Fi/Fantasy";
            case 41:
                return "Thriller";
            case 42:
                return "Shorts";
            case 43:
                return "Shows";
            case 44:
                return "Trailers";
            default:
                return "ERROR";
        }
    }

    public int getCategoryId(String category) {
        switch (category) {
            case "Film & Animation":
                return 1;
            case "Autos & Vehicles":
                return 2;
            case "Music":
                return 10;
            case "Pets & Animals":
                return 15;
            case "Sports":
                return 17;
            case "Short Movies":
                return 18;
            case "Travel & Events":
                return 19;
            case "Gaming":
                return 20;
            case "Videoblogging":
                return 21;
            case "People & Blogs":
                return 22;
            case "Comedy":
                return 23;
            case "Entertainment":
                return 24;
            case "News & Politics":
                return 25;
            case "Howto & Style":
                return 26;
            case "Education":
                return 27;
            case "Science & Technology":
                return 28;
            case "Nonprofits & Activism":
                return 29;
            case "Movies":
                return 30;
            case "Anime/Animation":
                return 31;
            case "Action/Adventure":
                return 32;
            case "Classics":
                return 33;
            case "Documentary":
                return 35;
            case "Drama":
                return 36;
            case "Family":
                return 37;
            case "Foreign":
                return 38;
            case "Horror":
                return 39;
            case "Sci-Fi/Fantasy":
                return 40;
            case "Thriller":
                return 41;
            case "Shorts":
                return 42;
            case "Shows":
                return 43;
            case "Trailers":
                return 44;
            default:
                return 0;
        }
    }

    public String getDataCSV() {
        StringBuilder s = new StringBuilder("" + this.get("videoID") + ",");
        s.append(((LocalDate) this.get("trendingDate")).format(DateTimeFormatter.ofPattern("yy.dd.MM"))).append(",");
        s.append(this.get("title")).append(",");
        s.append(this.get("channelTitle")).append(",");
        s.append(getCategoryId((String) this.get("category"))).append(",");

        s.append(((LocalDateTime) this.get("publishTime")).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)).append(".000Z,");

        int tagsSize = ((ArrayList<String>) this.get("tags")).size();
        if (tagsSize == 0) {
            s.append("[none]");
        } else if (tagsSize == 1) {
            s.append(((ArrayList<String>) this.get("tags")).get(0));
        } else {
            s.append(((ArrayList<String>) this.get("tags")).get(0));
            for (int i = 1; i < tagsSize; i++) {
                s.append("|").append(((ArrayList<String>) this.get("tags")).get(i));
            }
        }
        s.append(",").append(this.get("views")).append(",").append(this.get("likes")).append(",").append(this.get("dislikes")).append(",").append(this.get("commentCount")).append(",");
        s.append(this.get("thumbnailLink")).append(",");
        s.append(this.get("commentsDisabled")).append(",").append(this.get("ratingsDisabled")).append(",").append(this.get("videoErrorOrRemoved")).append(",").append(this.get("description"));

        return s.toString();
    }
}

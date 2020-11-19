package com.bitnbytes.ytanalyticsserver.database;

public class TagAverageStore {
    private int videos;
    private int totalTags;
    private int category;

    public TagAverageStore() {
        this.videos = 0;
        this.totalTags = 0;
        this.category = 0;
    }

    public TagAverageStore(int videos, int totalTags, int category) {
        this.videos = videos;
        this.totalTags = totalTags;
        this.category = category;
    }

    public int getVideos() {
        return this.videos;
    }

    public int getTotalTags() {
        return this.totalTags;
    }

    public static String getCategory(int c) {
        switch (c) {
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

    public static int getCategory(String s) {
        switch (s) {
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

    public String getCategory() {
        return TagAverageStore.getCategory(this.category);
    }

    public int getCategoryID() {
        return this.category;
    }

    public void setVideos(int i) {
        this.videos = i;
    }

    public void setTotalTags(int i) {
        this.totalTags = i;
    }

    public void setCategory(int i) {
        this.category = i;
    }

    public void setCategory(String c) {
        this.category = TagAverageStore.getCategory(c);
    }

    public void incrementVideoCount(int i) {
        this.videos += i;
    }

    public void decrementVideoCount(int i) {
        this.videos -= i;
    }

    public void incrementVideoCount() {
        this.videos++;
    }

    public void decrementVideoCount() {
        this.videos--;
    }

    public void incrementTotalTagCount(int i) {
        this.totalTags += i;
    }

    public void decrementTotalTagCount(int i) {
        this.totalTags -= i;
    }

    public int getTagAverage() {
        if (this.videos == 0) {
            return 0;
        }
        return this.totalTags / this.videos;
    }

}

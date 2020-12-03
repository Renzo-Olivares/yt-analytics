package com.bitnbytes.ytanalyticsserver.database;

public class TagAverageStore {
    private int videos;
    private int totalTags;
    private int category;

    public TagAverageStore(int videos, int totalTags, int category) {
        this.videos = videos;
        this.totalTags = totalTags;
        this.category = category;
    }

    public String getCategory() {
        return Entity.getCategory(this.category);
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

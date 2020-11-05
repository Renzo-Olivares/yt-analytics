package com.bitnbytes.ytanalyticsserver.database;

public class TrendingChartData {
    private String xVal;
    private int yVal;

    TrendingChartData(String xVal, int yVal){
        this.xVal = xVal;
        this.yVal = yVal;
    }

    public String getxVal(){
        return xVal;
    }

    public int getyVal(){
        return yVal;
    }
}

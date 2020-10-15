package com.bitnbytes.ytanalyticsserver.database;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component("mockDbImpl")
public class MockDbImpl {
    private final List<String> mockData = new ArrayList<>();

    @Autowired
    public MockDbImpl(){
        mockData.add("PewdiePie");
        mockData.add("Mr.Beat");
        mockData.add("KSI");
        mockData.add("Marques Brownlee");
        mockData.add("Linus Tech Tips");
        mockData.add("Ninja");
    }

    public List<String> getMockData(){
        return mockData;
    }

    public String getTop(){
        return mockData.get(0);
    }

    public String addData(String newData){
        mockData.add(newData);
        return newData;
    }
}

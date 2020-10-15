package com.bitnbytes.ytanalyticsserver.services;

import com.bitnbytes.ytanalyticsserver.database.MockDbImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class MockServiceImpl implements MockService{
    MockDbImpl aMockDb;

    @Autowired
    public MockServiceImpl(@Qualifier("mockDbImpl") MockDbImpl aDb){
        aMockDb = aDb;
    }

    @Override
    public List<String> getMockData() {
        return aMockDb.getMockData();
    }

    @Override
    public String getTop(){
        return aMockDb.getTop();
    }

    @Override
    public String addData(String newData){
        return aMockDb.addData(newData);
    }
}

package com.bitnbytes.ytanalyticsserver.services;

import java.util.List;

public interface MockService {
    List<String> getMockData();
    String getTop();
    String addData(String newData);
}

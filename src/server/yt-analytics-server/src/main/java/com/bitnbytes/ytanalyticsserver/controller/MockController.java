package com.bitnbytes.ytanalyticsserver.controller;

import com.bitnbytes.ytanalyticsserver.services.MockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(path="/demo")
public class MockController {
    final private MockService mockService;

    @Autowired
    public MockController(MockService aMockService){
        mockService = aMockService;
    }

    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public ResponseEntity<List<String>> getMockData(){
        return new ResponseEntity<>(mockService.getMockData(), HttpStatus.OK);
    }

    @RequestMapping(value = "/top", method = RequestMethod.GET)
    public ResponseEntity<String> getTop(){
        return new ResponseEntity<>(mockService.getTop(), HttpStatus.OK);
    }

    @RequestMapping(value = "/add", method = RequestMethod.POST)
    public String addData(@RequestBody String newData){
        System.out.printf("Adding new data: %s%n", newData);
        return (mockService.addData(newData));
    }
}

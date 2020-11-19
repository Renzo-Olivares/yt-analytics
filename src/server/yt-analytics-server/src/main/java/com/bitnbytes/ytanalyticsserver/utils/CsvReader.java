package com.bitnbytes.ytanalyticsserver.utils;

import com.bitnbytes.ytanalyticsserver.database.Entity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

@Component("csvReader")
public class CsvReader {

	private Set<Entity> newData;

	@Autowired
	public CsvReader() {
		newData = new HashSet<>();
	}

	public void read(String file) throws IOException {
		System.out.println("Removing old data");
		newData.clear();
		System.out.println("Old data removed\nReading in new data");
		StringBuilder line;

		BufferedReader br = new BufferedReader(new FileReader(file));
		br.readLine();// ignore first line
		int i = 0;
		while ((line = Optional.ofNullable(br.readLine()).map(StringBuilder::new).orElse(null)) != null) {
			while(line.charAt(line.length() - 1) != '"' && br.ready()) {
				line.append(br.readLine());
			}
			try {
				process(line.toString());
			} catch (Exception e) {
				i++;
			}

		}
		br.close();
		System.out.println("New data loaded, " + i + " errors, "  + newData.size() + " entries.");
	}

	public final Set<Entity> getDataset() {
		return newData;
	}

	private void process(String rawEntity) throws Exception {
		ArrayList<String> parse = new ArrayList<>();
		for (String s : rawEntity.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1)) {
			if(s.charAt(0) == ' ') {
				parse.set(parse.size() - 1, parse.get(parse.size() - 1) + s);
			}else {
				parse.add(s);
			}
		}
		initialize(parse);
	}

	private void initialize(ArrayList<String> rawData) throws Exception {
		if (rawData.size() != 16) {
			StringBuilder badData = new StringBuilder();
			for(String s : rawData) {
				badData.append(s).append(",");
			}

			throw new Exception("Bad Format\tSize: " + rawData.size() + "\tData:\t" + badData);
		}

		newData.add(new Entity(rawData));
	}

}
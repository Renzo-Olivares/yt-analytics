package com.bitnbytes.ytanalyticsserver.utils;

import com.bitnbytes.ytanalyticsserver.database.Entity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Optional;

@Component("csvReader")
public class CsvReader {
	private ArrayList<Entity> data;

	@Autowired
	public CsvReader() {
		data = new ArrayList<>();
	}

	public void read(String file) throws IOException {
		System.out.println("Removing old data");
		data.clear();
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
				data.add(new Entity(line.toString()));
			} catch (Exception e) {
				i++;
			}

		}
		br.close();
		System.out.println("New data loaded, " + i + " errors, "  + data.size() + " entries.");
	}

	public final ArrayList<Entity> getData() {
		return data;
	}

}
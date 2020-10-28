package com.bitnbytes.ytanalyticsserver.database;

import java.util.ArrayList;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.Instant;
import java.time.LocalDate;
import java.util.Arrays;

public class Entity {
	protected String videoID;
	protected LocalDate trendingDate;//
	protected String title;
	protected String channelTitle;
	protected int categoryId;//
	protected LocalDateTime publishTime;//
	protected ArrayList<String> tags;//
	protected int views;
	protected int likes;
	protected int dislikes;
	protected int commentCount;
	protected String thumbnailLink;
	protected boolean commentsDisabled;
	protected boolean ratingsDisabled;
	protected boolean videoErrorOrRemoved;
	protected String description;

	public Entity(String data) throws Exception {
		ArrayList<String> parse = new ArrayList<>();
		for (String s : data.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1)) {
			if(s.charAt(0) == ' ') {
				parse.set(parse.size() - 1, parse.get(parse.size() - 1) + s);
			}else {
				parse.add(s);
			}
		}
		initialize(parse);
	}

	public Entity(Entity updatedEntry){
		this.videoID = updatedEntry.videoID;
		this.trendingDate = updatedEntry.trendingDate;
		this.title = updatedEntry.title;
		this.channelTitle = updatedEntry.channelTitle;
		this.categoryId = updatedEntry.categoryId;
		this.publishTime = updatedEntry.publishTime;
		this.tags = new ArrayList<>(updatedEntry.tags);
		this.views = updatedEntry.views;
		this.likes = updatedEntry.likes;
		this.dislikes = updatedEntry.dislikes;
		this.commentCount = updatedEntry.commentCount;
		this.thumbnailLink = updatedEntry.thumbnailLink;
		this.commentsDisabled = updatedEntry.commentsDisabled;
		this.ratingsDisabled = updatedEntry.ratingsDisabled;
		this.videoErrorOrRemoved = updatedEntry.videoErrorOrRemoved;
		this.description = updatedEntry.description;
	}

	private void initialize(ArrayList<String> data) throws Exception {

		if (data.size() != 16) {
			StringBuilder badData = new StringBuilder();
			for(String s : data) {
				badData.append(s).append(",");
			}
			
			throw new Exception("Bad Format\tSize: " + data.size() + "\tData:\t" + badData);
		}
		

		videoID = data.get(0);

		int[] date = { 0, 0, 0 };
		for (int i = 0; i < date.length; i++) {
			date[i] = Integer.parseInt(data.get(1).split("\\.")[i]);
		}
		// date = {YY, DD, MM}
		date[0] += 2000;
		// date = {YYYY, DD, MM}
		trendingDate = LocalDate.of(date[0], date[2], date[1]);// YYYY, MM, DD

		title = data.get(2);

		channelTitle = data.get(3);

		categoryId = Integer.parseInt(data.get(4));

		publishTime = LocalDateTime.ofInstant(Instant.parse(data.get(5)), ZoneId.of("UTC"));

		tags = new ArrayList<>();
		tags.addAll(Arrays.asList(data.get(6).split("|")));

		views = Integer.parseInt(data.get(7));

		likes = Integer.parseInt(data.get(8));

		dislikes = Integer.parseInt(data.get(9));

		commentCount = Integer.parseInt(data.get(10));

		thumbnailLink = data.get(11);

		commentsDisabled = Boolean.parseBoolean(data.get(12));

		ratingsDisabled = Boolean.parseBoolean(data.get(13));

		videoErrorOrRemoved = Boolean.parseBoolean(data.get(14));

		description = data.get(15);

	}

	public LocalDate getTrendingDate(){
		return trendingDate;
	}

	public LocalDateTime getPublishTime(){
		return publishTime;
	}

	public ArrayList<String> getTags(){
		return tags;
	}

	public String getVideoID() {
		return videoID;
	}

	public String getTitle(){
		return title;
	}

	public String getChannelTitle(){
		return channelTitle;
	}

	public String getThumbnailLink(){
		return thumbnailLink;
	}

	public String getDescription(){
		return description;
	}

	public int getViews(){
		return views;
	}

	public int getLikes(){
		return likes;
	}

	public int getDislikes(){
		return dislikes;
	}

	public int getCommentCount(){
		return commentCount;
	}

	public boolean getCommentsDisabled(){
		return commentsDisabled;
	}

	public boolean getRatingsDisabled(){
		return ratingsDisabled;
	}

	public boolean getVideoErrorOrRemoved(){
		return videoErrorOrRemoved;
	}

	public String getCategory() {
		switch (categoryId) {
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

	public String toString() {
		StringBuilder print = new StringBuilder(videoID + ",\t" + trendingDate + ",\t" + title + ",\t" + channelTitle + ",\t" + getCategory()
				+ ",\t" + publishTime + ",\t");
		for (String s : tags) {
			print.append(s).append("|");
		}
		print.append(",\t").append(views).append(",\t").append(likes).append(",\t").append(dislikes).append(",\t").append(commentCount).append(",\t").append(thumbnailLink).append(",\t").append(commentsDisabled).append(",\t").append(ratingsDisabled).append(",\t").append(videoErrorOrRemoved).append(",\t").append(description).append("\n");

		return print.toString();
	}
}
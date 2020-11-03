package com.bitnbytes.ytanalyticsserver.database;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.Instant;
import java.time.LocalDate;
import java.util.Arrays;

public class Entity {
	protected String videoID;
	protected LocalDate trendingDate;
	protected String title;
	protected String channelTitle;
	protected int categoryId;
	protected LocalDateTime publishTime;
	protected ArrayList<String> tags;
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

	public Entity(String videoID, LocalDate trendingDate, String title, String channelTitle, String category, LocalDateTime publishTime, ArrayList<String> tags, int views, int likes, int dislikes, int comments, String thumbnailLink, boolean commentsDisabled, boolean ratingsDisabled, boolean videoErrorOrRemoved, String description){
		this.videoID = videoID;
		this.trendingDate = trendingDate;
		this.title = title;
		this.channelTitle = channelTitle;
		this.categoryId = getCategoryId(category);
		this.publishTime = publishTime;
		this.tags = tags;
		this.views = views;
		this.likes = likes;
		this.dislikes = dislikes;
		this.commentCount = comments;
		this.thumbnailLink = thumbnailLink;
		this.commentsDisabled = commentsDisabled;
		this.ratingsDisabled = ratingsDisabled;
		this.videoErrorOrRemoved = videoErrorOrRemoved;
		this.description = description;
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

	public String getDataCSV() {
		StringBuilder s = new StringBuilder("" + videoID + ",");
		s.append(trendingDate.format(DateTimeFormatter.ofPattern("yy.dd.MM"))).append(",");
		s.append(title).append(",");
		s.append(channelTitle).append(",");
		s.append(categoryId).append(",");

		s.append(publishTime.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)).append(".000Z,");

		int tagsSize = tags.size();
		if (tagsSize == 0) {
			s.append("[none]");
		} else if (tagsSize == 1) {
			s.append(tags.get(0));
		} else {
			s.append(tags.get(0));
			for (int i = 1; i < tagsSize; i++) {
				s.append("|").append(tags.get(i));
			}
		}
		s.append(",").append(views).append(",").append(likes).append(",").append(dislikes).append(",").append(commentCount).append(",");
		s.append(thumbnailLink).append(",");
		s.append(commentsDisabled).append(",").append(ratingsDisabled).append(",").append(videoErrorOrRemoved).append(",").append(description);

		return s.toString();
	}

	public boolean equals(Entity e) {
		if(!this.videoID.equals(e.videoID))return false;
		if(!this.trendingDate.equals(e.trendingDate))return false;
		if(!this.title.equals(e.title))return false;
		if(!this.channelTitle.equals(e.channelTitle))return false;
		if(this.categoryId != e.categoryId)return false;
		if(!this.publishTime.equals(e.publishTime))return false;
		if(!this.tags.equals(e.tags))return false;
		if(this.views != e.views)return false;
		if(this.likes != e.likes)return false;
		if(this.dislikes != e.dislikes)return false;
		if(this.commentCount != e.commentCount)return false;
		if(!this.thumbnailLink.equals(e.thumbnailLink))return false;
		if(this.commentsDisabled != e.commentsDisabled)return false;
		if(this.ratingsDisabled != e.ratingsDisabled)return false;
		if(this.videoErrorOrRemoved != e.videoErrorOrRemoved)return false;
		if(!this.description.equals(e.description))return false;

		return true;
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
		tags.addAll(Arrays.asList(data.get(6).split("\\|")));

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

	public int getCategoryId(String category) {
		switch (category) {
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
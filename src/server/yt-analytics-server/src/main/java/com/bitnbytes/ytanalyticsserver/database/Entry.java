import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.Instant;
import java.time.LocalDate;
import java.util.Locale;
import java.util.TimeZone;

public class Entry {
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

	public Entry(ArrayList<String> data) throws Exception {
		initialize(data);
	}

	public Entry(Entry e){
		this.videoID = new String(e.videoID);
		this.trendingDate = e.trendingDate;
		this.title = new String(e.title);
		this.channelTitle = new String(e.channelTitle);
		this.categoryId = e.categoryId;
		this.publishTime = e.publishTime;
		this.tags = new ArrayList<String>(e.tags);
		this.views = e.views;
		this.likes = e.likes;
		this.dislikes = e.dislikes;
		this.commentCount = e.commentCount;
		this.thumbnailLink = new String(e.thumbnailLink);
		this.commentsDisabled = e.commentsDisabled;
		this.ratingsDisabled = e.ratingsDisabled;
		this.videoErrorOrRemoved = e.videoErrorOrRemoved;
		this.description = new String(e.description);
	}

	public Entry(String data) throws Exception {
		ArrayList<String> parse = new ArrayList<String>();
		for (String s : data.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1)) {
			if(s.charAt(0) == ' ') {
				parse.set(parse.size() - 1, parse.get(parse.size() - 1) + s);
			}else {
				parse.add(s);
			}	
		}
		initialize(parse);
	}

	private void initialize(ArrayList<String> data) throws Exception {

		if (data.size() != 16) {
			String badData = "";
			for(String s : data) {
				badData += s + ",";
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

		tags = new ArrayList<String>();
		for (String s : data.get(6).split("|")) {
			tags.add(s);
		}

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
			return "Hoto & Style";
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
		String print = videoID + ",\t" + trendingDate + ",\t" + title + ",\t" + channelTitle + ",\t" + getCategory()
				+ ",\t" + publishTime + ",\t";
		for (String s : tags) {
			print += s + "|";
		}
		print += ",\t" + views + ",\t" + likes + ",\t" + dislikes + ",\t" + commentCount + ",\t" + thumbnailLink + ",\t"
				+ commentsDisabled + ",\t" + ratingsDisabled + ",\t" + videoErrorOrRemoved + ",\t" + description + "\n";

		return print;
	}
}
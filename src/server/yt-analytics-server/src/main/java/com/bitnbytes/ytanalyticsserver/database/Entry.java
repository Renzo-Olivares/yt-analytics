import java.util.ArrayList;
import java.util.Date;

public class Entry{
    protected String videoID;
    protected Date trending_date;
    protected String title;
    protected String channelTitle;
    protected int category_id;
    protected Date publish_time;
    protected ArrayList<String> tags;
    protected int views;
    protected int likes;
    protected int dislikes;
    protected int comment_count;
    protected String thumbnail_link;
    protected boolean commentsDisabled;
    protected boolean ratingsDisabled;
    protected boolean video_error_or_removed;
    protected String description;  
    
    public Entry(ArrayList<String> data){
    	
    }
    
    public Entry(String data) {
    	
    }
}
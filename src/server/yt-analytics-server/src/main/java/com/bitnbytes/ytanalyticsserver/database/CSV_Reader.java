import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class CSV_Reader {
	// File (data - rows X columns)
	private ArrayList<ArrayList<String>> data;
	private static final String CSV_SPLIT_BY = ",";
	

	public CSV_Reader() {
		data = new ArrayList<ArrayList<String>>();
	}

	public void read(String file) throws IOException{
    	System.out.println("Removing old data");
        data.clear();
        System.out.println("Old data removed\nReading in new data");
        String line = "";

        BufferedReader br = new BufferedReader(new FileReader(file));

            while ((line = br.readLine()) != null) {
                ArrayList<String> parse = new ArrayList<String>();
                for(String s : line.split(CSV_SPLIT_BY)){
                	parse.add(s);
                }
                data.add(parse);
                
            }

        
        System.out.println("New data loaded");
    }
	public final ArrayList<ArrayList<String>> getData() {
		return data;
	}
	
}
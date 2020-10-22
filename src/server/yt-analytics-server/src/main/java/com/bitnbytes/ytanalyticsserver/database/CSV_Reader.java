import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class CSV_Reader {
	private ArrayList<Entry> data;

	public CSV_Reader() {
		data = new ArrayList<Entry>();
	}

	public void read(String file) throws IOException {
		System.out.println("Removing old data");
		data.clear();
		System.out.println("Old data removed\nReading in new data");
		String line = "";

		BufferedReader br = new BufferedReader(new FileReader(file));
		br.readLine();// ignore first line
		int i = 0;
		while ((line = br.readLine()) != null) {
			while(line.charAt(line.length() - 1) != '"' && br.ready()) {
				line += br.readLine();
			}
			try {
				data.add(new Entry(line));
			} catch (Exception e) {
				i++;
			}

		}
		br.close();
		System.out.println("New data loaded, " + i + " errors, "  + data.size() + " entries.");
	}

	public final ArrayList<Entry> getData() {
		return data;
	}

}
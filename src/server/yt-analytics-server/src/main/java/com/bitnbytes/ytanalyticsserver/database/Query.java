import java.util.ArrayList;
import java.lang.NullPointerException;
public class Query{
    private ArrayList<Entry> data;//to be updated with a seperate class soon.
    public Query(){
        data = NULL;
    }

    public void load(ArrayList<Entry> data){
        this.data = data;
    }

    public void unload(){
        data = NULL;
    }

    private void verifyData(){
        if(data == NULL)throw NullPointerException;
    }

}
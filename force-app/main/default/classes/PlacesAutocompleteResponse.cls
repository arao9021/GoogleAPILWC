public class PlacesAutocompleteResponse {
    
    public List<Predictions> predictions;
    public String status;
    
    public class Predictions {
        public String description;
        public String id;
        public List<Matched_substrings> matched_substrings;
        public String place_id;
        public String reference;
        public Structured_formatting structured_formatting;
        public List<Terms> terms;
        public List<String> types;
    }
    public class Matched_substrings {
        public Integer length;
        public Integer offset;
    }
    
    public class Structured_formatting {
        public String main_text;
        public List<Matched_substrings> main_text_matched_substrings;
        public String secondary_text;
    }

    public class Terms {
        public Integer offset;
        public String value;
    }
      
    public static List<Address> parse(String json) {
        PlacesAutocompleteResponse result = (PlacesAutocompleteResponse) System.JSON.deserialize(json, PlacesAutocompleteResponse.class);
        List<predictions> pList = result.predictions;
        List<Address> aList = new List<Address>();
        for(predictions p : pList){
            Address a = new Address();
            a.placeId = p.place_id;
            a.placeLabel = p.description;
            aList.add(a);
        }
        return aList;
    }
    
    public class Address {
        public String placeId;
        public String placeLabel;
    }
}
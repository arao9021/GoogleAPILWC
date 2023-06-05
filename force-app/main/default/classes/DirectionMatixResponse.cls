public class DirectionMatixResponse {
	
    public List<String> destination_addresses;
	public List<String> origin_addresses;
	public List<Rows> rows;
	public String status;

    public class Rows {
		public List<Elements> elements;
	}
    
	public class Elements {
		public Distance distance;
		public Distance duration;
		public Distance duration_in_traffic;
		public String status;
	}

	public class Distance {
		public String text;
		public Decimal value;
	}

	public static DistanceTimeWrapper parse(String json) {
		DirectionMatixResponse result = (DirectionMatixResponse) System.JSON.deserialize(json, DirectionMatixResponse.class);
        System.debug(result);
        DistanceTimeWrapper wrapperObj = new DistanceTimeWrapper();
        if(result != null && result.rows != null && !result.rows.isEmpty() && 
           result.rows[0].elements != null && !result.rows[0].elements.isEmpty()) {
               Elements temp = result.rows[0].elements[0];
               if(temp.distance != null) {
                   wrapperObj.distanceText = temp.distance.text;
                   wrapperObj.distanceValue = temp.distance.value;
               }
               if(temp.duration != null) {
                   wrapperObj.durationText = temp.duration.text;
                   wrapperObj.durationValue = temp.duration.value;
               }
        }
        return wrapperObj;
	}
    
    public class DistanceTimeWrapper {
        public String distanceText;
		public Decimal distanceValue;
        
        public String durationText;
		public Decimal durationValue;
    }
    
}
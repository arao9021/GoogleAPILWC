public with sharing class AddressDirectionDetailsService {

    @AuraEnabled
    public static DistanceTimeCostWrapper getDistanceTimeCost(String originAddress, String destinationAddress) {
        System.debug(originAddress);
        System.debug(destinationAddress);
        DirectionMatixResponse.DistanceTimeWrapper distanceTimeWrapper = GoogleMapsAPIService.getDistanceAndTime(originAddress, destinationAddress);
        DistanceTimeCostWrapper result = new DistanceTimeCostWrapper(distanceTimeWrapper.distanceText, distanceTimeWrapper.durationText);
        if(distanceTimeWrapper.distanceValue != null) {
            result.costs = getTransportationCosts(distanceTimeWrapper.distanceValue);
        }
        return result;
    }
    
    public static List<TransportationCost> getTransportationCosts(Decimal distance) {
        List<TransportationCost> costs = new List<TransportationCost>();
        
     	List<Transportation_Cost__mdt> settings = MetadataSelector.getAllTransportationCosts();
        for(Transportation_Cost__mdt setting : settings) {
            costs.add(new TransportationCost(setting.Label, setting.Cost_per_Mile__c * distance));
        }
        return costs;
    }
    
    public class DistanceTimeCostWrapper {
        @AuraEnabled public String distanceText {get; set;}
        @AuraEnabled public String timeText {get; set;}
        @AuraEnabled public List<TransportationCost> costs {get; set;}

        public DistanceTimeCostWrapper(String distanceText, String timeText) {
            this.distanceText = distanceText;
            this.timeText = timeText;
            this.costs = new List<TransportationCost>();
        }
    }
    
    public class TransportationCost {
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public Decimal cost {get; set;}

        public TransportationCost(String label, Decimal cost) {
            this.label = label;
            this.cost = cost;
        }
    }
}
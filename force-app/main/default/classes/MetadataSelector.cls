public class MetadataSelector {
	
    public static Integration_Settings__mdt getIntegrationSetting(String devName) {
        return [SELECT Label, DeveloperName, URL__c, API_Key__c FROM Integration_Settings__mdt WHERE DeveloperName = :devName LIMIT 1];
    }
    
    public static List<Transportation_Cost__mdt> getAllTransportationCosts() {
        return [SELECT Label, DeveloperName, Cost_per_Mile__c FROM Transportation_Cost__mdt];
    }
    
}
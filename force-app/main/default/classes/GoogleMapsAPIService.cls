public class GoogleMapsAPIService {
    public static final String ADDRESS_AUTOCOMPLETE_SETTING_NAME = 'Address_Autocomplete';
    public static final String DISTANCE_MATRIX_SETTING_NAME = 'Distance_Matrix_API';
    
    public static List<PlacesAutocompleteResponse.Address> searchPlaces(string searchKey) {
        Integration_Settings__mdt setting = MetadataSelector.getIntegrationSetting(ADDRESS_AUTOCOMPLETE_SETTING_NAME);
        if(setting == null) {
        	throw new AuraHandledException('Address Autocomplete API Details are not configured. Please reach out to System Administrator.');
        }

        String url = setting.URL__c + '?types=geocode&' + 
                                       'input=' + EncodingUtil.urlEncode(searchKey, 'UTF-8') + '&' +
                                       'key=' + setting.API_Key__c;
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(url);
        req.setTimeout(120000);
        res = h.send(req);
        if(res == null || res.getStatusCode() != 200) {
            throw new AuraHandledException('Failed to get address suggestions.');
        }
        
        return PlacesAutocompleteResponse.parse(res.getBody());
    }
    
    public static DirectionMatixResponse.DistanceTimeWrapper getDistanceAndTime(String address1, String address2) {
        Integration_Settings__mdt setting = MetadataSelector.getIntegrationSetting(DISTANCE_MATRIX_SETTING_NAME);
        if(setting == null) {
        	throw new AuraHandledException('Distance Matrix API Details are not configured. Please reach out to System Administrator.');
        }

        String url = setting.URL__c + '?origins=' + EncodingUtil.urlEncode(address1, 'UTF-8') + '&' + 
                                       'destinations=' + EncodingUtil.urlEncode(address2, 'UTF-8') + '&' +
                                       'key=' + setting.API_Key__c;
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(url);
        req.setTimeout(120000);
        res = h.send(req);
        if(res == null || res.getStatusCode() != 200) {
            throw new AuraHandledException('Failed to get Distance details.');
        }
        
        return DirectionMatixResponse.parse(res.getBody());
    }
}
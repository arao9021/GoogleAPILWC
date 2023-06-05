public with sharing class InputAddressService {
	
    @AuraEnabled
    public static List<AddressSuggestion> getAddressSuggestions(String searchKey) {
        List<AddressSuggestion> results = new List<AddressSuggestion>();
		List<PlacesAutocompleteResponse.Address> suggestedAddresses = GoogleMapsAPIService.searchPlaces(searchKey);
        for(PlacesAutocompleteResponse.Address suggestedAddress : suggestedAddresses) {
            results.add(new AddressSuggestion(suggestedAddress.placeId, suggestedAddress.placeLabel));
        }
        return results;
    }
    
    public class AddressSuggestion {
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String icon {get; set;}
        @AuraEnabled public String title {get; set;}

        public AddressSuggestion(String id, String title) {
            this.id = id;
            this.icon = 'custom:custom106';
            this.title = title;
        }
    }
}
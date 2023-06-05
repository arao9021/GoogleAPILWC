@isTest
public class InputAddressServiceTest {

    private static final String SUCCESS_RESPONSE = '{' +
        '"predictions":' +
        	'[' +
              '{' + 
                '"description": "Paris, France",' + 
                '"matched_substrings": [{ "length": 5, "offset": 0 }],' + 
                '"place_id": "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",' + 
                '"reference": "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",' + 
                '"structured_formatting":' + 
                  '{' + 
                    '"main_text": "Paris",' + 
                    '"main_text_matched_substrings": [{ "length": 5, "offset": 0 }],' + 
                    '"secondary_text": "France"' + 
                  '},' + 
                '"terms":' + 
                  '[' + 
                    '{ "offset": 0, "value": "Paris" },' + 
                    '{ "offset": 7, "value": "France" }' + 
                  '],' + 
                '"types": ["locality", "political", "geocode"]' + 
              '}' + 
            '],' + 
          '"status": "OK"' + 
        '}';
    
    static testmethod void testAddressSuggestionsSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, SUCCESS_RESPONSE));
        List<InputAddressService.AddressSuggestion> results = InputAddressService.getAddressSuggestions('Test');
        System.assertEquals(1, results.size());
    }
    
    static testmethod void testAddressSuggestionsFailure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, ''));
        try {
            InputAddressService.getAddressSuggestions('Test');
            System.assert(false);
        }
        catch(Exception e) {
            System.assert(true);
        }
    }
}
@isTest
public class AddressDirectionDetailsServiceTest {

    private static final String SUCCESS_RESPONSE = '{' +
          '"destination_addresses": ["New York, NY, USA"],' +
          '"origin_addresses": ["Washington, DC, USA"],' +
          '"rows":' +
            '[' +
              '{' +
                '"elements":' +
                  '[' +
                    '{' +
                      '"distance": { "text": "228 mi", "value": 367654 },' +
                      '"duration": { "text": "3 hours 55 mins", "value": 14078 },' +
                      '"status": "OK"' +
                    '}' +
                  ']' +
              '}' +
            '],' +
          '"status": "OK"' +
        '}';
    
    static testmethod void testGetDistanceTimeCostSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, SUCCESS_RESPONSE));
        AddressDirectionDetailsService.DistanceTimeCostWrapper result = AddressDirectionDetailsService.getDistanceTimeCost('Address 1', 'Address 2');
        System.assertEquals('228 mi', result.distanceText);
        System.assertEquals('3 hours 55 mins', result.timeText);
    }
    
    static testmethod void testGetDistanceTimeCostFailure() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(500, ''));
        try {
            AddressDirectionDetailsService.getDistanceTimeCost('Address 1', 'Address 2');
            System.assert(false);
        }
        catch(Exception e) {
            System.assert(true);
        }
    }
}
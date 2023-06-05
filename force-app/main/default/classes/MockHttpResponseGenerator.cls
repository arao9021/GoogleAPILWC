@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
	
    Integer responseCode;
    String responseBody;
    
    public MockHttpResponseGenerator(Integer responseCode, String responseBody) {
    	this.responseCode = responseCode;
        this.responseBody = responseBody;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseBody);
        res.setStatusCode(responseCode);
        return res;
    }
}
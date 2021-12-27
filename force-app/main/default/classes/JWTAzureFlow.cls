public class JWTAzureFlow {

    public static String getAccessToken(String clientId, String tenantId, String scopes, JWTAzure jwt) {
        // nothing to do if no parameters to post
        if (null == jwt) return null;

        // add to params
        Map<String,String> params = new Map<String,String>();
        params.put('client_assertion', jwt.issue());
        params.put('grant_type', 'client_credentials');
        params.put('client_assertion_type', 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer');
        params.put('client_id', clientId);
        if (String.isNotEmpty(scopes)) params.put('scope', scopes);

        // build body of request
        String body = '';
        for (String key : params.keySet()) {
            if (String.isNotEmpty(body)) body += '&';
            String value = params.get(key);
            body += (key + '=' + EncodingUtil.urlEncode(value, 'utf-8'));
        }

        // exchange JWT for access token
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://login.microsoftonline.com/' + tenantId + '/oauth2/v2.0/token');
        req.setHeader('Content-type', 'application/x-www-form-urlencoded');
        req.setBody(body);
        Http http = new Http();
        HttpResponse res = http.send(req);

        String access_token = null;
        if ( res.getStatusCode() == 200 ) {
            System.JSONParser parser = System.JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'access_token')) {
                    parser.nextToken();
                    access_token = parser.getText();
                    break;
                }
            }
        }else {
            System.debug('::: error ::: ' + res.getBody());
        }
        return access_token;
    }

}
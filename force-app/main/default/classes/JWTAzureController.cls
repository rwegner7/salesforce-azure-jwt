public with sharing class JWTAzureController {
    @AuraEnabled(Cacheable=false)
    public static String getAccessToken(){
        //get org custom setting for callout
        CS_AzureSSO__c CS = CS_AzureSSO__c.getOrgDefaults();

        //setup auth parameters
        JWTAzure jwt = new JWTAzure();
        jwt.cert = 'AzureSSO'; //put the name of your cert here
        jwt.iss = CS.ClientId__c;
        jwt.sub = CS.ClientId__c;
        jwt.aud = 'https://login.microsoftonline.com/' + CS.TenantId__c + '/oauth2/v2.0/token';
        jwt.x5t = CS.Thumbprint__c;

        // invoke the flow and obtain an access_token
        String access_token = JWTAzureFlow.getAccessToken(CS.ClientId__c, CS.TenantId__c, CS.Scope__c, jwt);
        CS.Token1__c = access_token.length() > 255 ? access_token.substring(0,255) : access_token;
        CS.Token2__c = access_token.length() > 510 ? access_token.substring(255,510) : access_token.substring(255,access_token.length());
        CS.Token3__c = access_token.length() > 765 ? access_token.substring(510,765) : access_token.substring(510,access_token.length());
        CS.Token4__c = access_token.length() > 1020 ? access_token.substring(765,1020) : access_token.substring(765,access_token.length());
        CS.Token5__c = access_token.length() > 1275 ? access_token.substring(1020,1275) : access_token.substring(1020,access_token.length());

        //update the custom setting
        try{
            update CS;
        }catch (DmlException e){
            System.debug('Error updating custom setting: ' + e.getMessage());
        }

        System.debug('Access Token: ' + access_token);
        System.debug('Access Token Length: ' + access_token.length()); //about 1250 characters
        return access_token;
    }
}
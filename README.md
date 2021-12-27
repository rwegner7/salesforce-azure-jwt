# salesforce-azure-jwt
Base code for calling Azure JWT SSO from Salesforce using Apex

## Setup Instructions
1. Create an app in Azure to authenticate against. Skip this step if you already have one.
2. Create a Self-Signed Certificate in Salesforce (e.g. *AzureSSO*). After creating the certificate, download it to your desktop. Use the following commands in a terminal window to get the thumbprint from the certificate. Remember to copy and store the thumbprint output from the last command, you'll need it later.
```
openssl x509 -in AzureSSO.crt -fingerprint -noout
echo $(openssl x509 -in AzureSSO.crt -fingerprint -noout) | sed "s/SHA1 Fingerprint=//g" | sed "s/://g" | xxd -r -ps | base64
```
3. Go to your Azure app and upload the .crt file in the section 'Certificates and Secrets'.
4. Create a new Remote Site Setting in Salesforce for the url 'https://login.microsoftonline.com'. This will allow us to make the callout to Azure.
5. Import the components from the *force-app* folder in this repository. 
	1. Note that you'll need to change line 9 of the Apex Class 'JWTAzureController' to the name of your certificate (e.g. *AzureSSO* if that's what you called your certificate).
6. Create an Org Default custom setting configuration for the custom setting object CS_AzureSSO__c.
	1. Client Id should be the Application (client) ID from your Azure app.
	2. Tenant Id should be the Directory (tenant) ID from your Azure app.
	3. Thumbprint should be the thumbprint output from step 2.
	4. Scope should be the Client Id + '/.default'.
7. Add the LWC component azureSSO to any lightning page in Salesforce. 
	1. You can test getting the token by clicking the 'Token' button. If a token is returned, the custom setting will be updated with the token value, and will also display on the screen.


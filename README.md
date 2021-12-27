# salesforce-azure-jwt
Base code for calling Azure JWT SSO from Salesforce using Apex

#Setup
1. Create an app in Azure to authenticate against.
2. Create a Self-Signed Certificate in Salesforce. After creating the certificate, download it to your desktop. Use the following commands to get the thumbprint from the key. Store the thumbprint output from the last command, you'll need it later.
- openssl x509 -in <certname>.crt -fingerprint -noout
- echo $(openssl x509 -in <certname>.crt -fingerprint -noout) | sed "s/SHA1 Fingerprint=//g" | sed "s/://g" | xxd -r -ps | base64
3. Go to your Azure app and upload the .crt file in the section 'Certificates and Secrets'.
4. Create a new Remote Site Setting in Salesforce for 'https://login.microsoftonline.com'. This will allow us to make the callout to Azure.
5. Import the components from the remote repository. Note that you'll need to change line 9 of the Apex Class 'JWTAzureController' to the name of your certificate.
6. Create an Org Default custom setting configuration for the custom setting object Azure SSO
7. Add the LWC component azureSSO to any lightning page in Salesforce. Test getting the token by clicking the 'Token' button. If a token is returned, the custom setting will be updated with the token value, and will also display on the screen.


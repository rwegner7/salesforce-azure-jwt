public class JWTAzure {
    public String alg {get;set;}
    public String iss {get;set;}
    public String sub {get;set;}
    public String aud {get;set;}
    public String exp {get;set;}
    public String iat {get;set;}
    public String typ {get;set;}
    public Map<String,String> claims {get;set;}
    public Integer validFor {get;set;}
    public String cert {get;set;}
    public String pkcs8 {get;set;}
    public String privateKey {get;set;}
    public String x5t {get;set;}

    // constants
    public static final String RS256 = 'RS256';

    public JWTAzure() {
        this.alg = RS256;
        this.validFor = 300;
        this.typ = 'JWT';
    }

    public String issue() {
        // resulting jwt
        String jwt = '';

        // generate the header
        JSONGenerator header = JSON.createGenerator(false);
        header.writeStartObject();
        header.writeStringField('alg', this.alg);
        header.writeStringField('typ', this.typ);
        if (!String.isEmpty(this.x5t)) header.writeStringField('x5t', this.x5t);
        header.writeEndObject();
        String encodedHeader = base64URLEncode(Blob.valueOf(header.getAsString()));

        // generate the payload
        JSONGenerator body = JSON.createGenerator(false);
        body.writeStartObject();
        body.writeStringField('iss', this.iss);
        body.writeStringField('sub', this.sub);
        body.writeStringField('aud', this.aud);
        Long rightNow = (dateTime.now().getTime()/1000)+1;
        body.writeNumberField('iat', rightNow);
        body.writeNumberField('exp', (rightNow + validFor));
        if (claims != null) {
            for (String claim : claims.keySet()) {
                body.writeStringField(claim, claims.get(claim));
            }
        }
        body.writeEndObject();
        jwt = encodedHeader + '.' + base64URLEncode(Blob.valueOf(body.getAsString()));

        // generate the signature
        Blob signature = null;
        if (cert != null ) {
            signature = Crypto.signWithCertificate('rsa-sha256', Blob.valueOf(jwt), cert);
        } else {
            Blob privateKey = EncodingUtil.base64Decode(pkcs8);
            signature = Crypto.sign('rsa-sha256', Blob.valueOf(jwt), privateKey);
        }
        jwt += '.' + base64URLEncode(signature);
        // return
        return jwt;
    }

    public String base64URLEncode(Blob input) {
        String output = EncodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while ( output.endsWith('=')){
            output = output.substring(0, output.length()-1);
        }
        return output;
    }


}
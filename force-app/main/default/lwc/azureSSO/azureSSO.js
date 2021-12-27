import {LightningElement} from 'lwc';
import getAccessToken from '@salesforce/apex/JWTAzureController.getAccessToken';

export default class AzureSSO extends LightningElement {
    token;
    error;

    get hasToken(){
        return this.token && this.token !== '';
    }

    get hasError(){
        return this.error && this.token !== '';
    }

    getToken(){
        getAccessToken()
            .then(result => {
                this.token = result;
                this.error = '';
            })
            .catch(error => {
                this.error = error;
                this.token = '';
            });
    }

}
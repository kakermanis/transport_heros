import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import getRTWDays from '@salesforce/apex/ReturnToWorkController.getReturnToWorkDaysCommunities';


export default class ReturnToWorkTimer extends LightningElement {
    @api recordId;
    @api CardTitle;
    @api CardIcon;
    @api ShowProgressBar;
    @api objectApiName;
    userId = Id;
    daysLeft = '4';
    percentComplete = '75';

    @wire(getRTWDays, {userId:'$userId'})
    wiredRTW({ error, data }) {
        if (data) {
          this.daysLeft = data.daysLeft;
          this.percentComplete = data.percentComplete;
        } else if (error) {
            this.error = error;
            this.daysLeft = '14';
            this.percentComplete = '0';
        }
    };


}
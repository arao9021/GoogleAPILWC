import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getDistanceTimeCost from '@salesforce/apex/AddressDirectionDetailsService.getDistanceTimeCost';

const COST_TABLE_COLUMNS = [
    { label: 'Transportation Type', fieldName: 'label' },
    { label: 'Transportation Cost', fieldName: 'cost', type: 'currency' }
];

export default class AddressesDirectionDetails extends LightningElement {

    @track loading = false;

    originAddress = '';
    destinationAddress = '';

    costTableColumns = COST_TABLE_COLUMNS;
    showResults = false;
    @track distanceTimeCostDetails;

    handleAddressSelection(event) {
        console.error(event.target.dataset);
        console.error(event.detail.value);
        this[event.target.dataset.target] = event.detail.value?.title;
    }

    handleGetDirectionsClick() {
        this.showResults = false;
        if(!this.originAddress || !this.destinationAddress) {
            this.showToast("Error!", "Please select Origin Address and Destination Address before clicking Get Directions.", "error");
            return;
        }
        
        this.loading = true;
        getDistanceTimeCost({
            originAddress: this.originAddress,
            destinationAddress: this.destinationAddress
        })
        .then(result => {
            this.distanceTimeCostDetails = result;
            this.showResults = true;
            this.loading = false;
        })
        .catch(error => {
            console.error(error);
            this.showToast("Error!", "An error occured while retrieving details.", "error");
            this.loading = false;
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
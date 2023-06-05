import { LightningElement, track, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getAddressSuggestions from '@salesforce/apex/InputAddressService.getAddressSuggestions';

export default class InputAddress extends LightningElement {
    @api label = 'Address';
    @api placeholder = 'Enter Address';

    handleSearch(event) {
        let searchKey = event.detail.searchTerm;
        getAddressSuggestions({
            searchKey: searchKey
        })
        .then(data => {
            console.log(data);
            this.template.querySelector("c-input-lookup").setSearchResults(data);
        })
        .catch(error => {
            console.error(error);
            this.showToast("Error!", "An error occured while searching addresses.", "error");
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    handleSelectionChange(event) {
        event.target.errors = [];
        console.log(event.detail);
        this.dispatchEvent(new CustomEvent('addressselection', {
            detail: {
                value: event.detail.value
            }
        }));
    }

}
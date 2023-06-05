import { LightningElement, track, api } from 'lwc';

const MINIMAL_SEARCH_TERM_LENGTH = 3; // Min number of chars required to search
const SEARCH_DELAY = 300; // Wait 300 ms after user stops typing then, peform search

export default class InputLookup extends LightningElement {
    @api label;
    @api selectedValue;
    @api placeholder = '';
    @api errors = [];
    @api scrollAfterNItems;

    @track searchTerm = '';
    @track searchResults = [];
    @track hasFocus = false;
    @track loading = false;

    cleanSearchTerm;
    blurTimeout;
    searchThrottlingTimeout;

    @api
    setSearchResults(results) {
        // Reset the spinner
        this.loading = false;

        this.searchResults = results.map(result => {
            // Clone and complete search result if icon is missing
            if (typeof result.icon === 'undefined') {
                const { id, sObjectType, title, subtitle } = result;
                return {
                    id,
                    sObjectType,
                    icon: 'standard:default',
                    title,
                    subtitle
                };
            }
            return result;
        });
    }

    updateSearchTerm(newSearchTerm) {
        this.searchTerm = newSearchTerm;

        // Compare clean new search term with current one and abort if identical - to avoid unnecessary calls
        const newCleanSearchTerm = newSearchTerm.trim().replace(/\*/g, '').toLowerCase();
        if (this.cleanSearchTerm === newCleanSearchTerm) {
            return;
        }

        // Save clean search term
        this.cleanSearchTerm = newCleanSearchTerm;

        // Ignore search terms that are too small
        if (newCleanSearchTerm.length < MINIMAL_SEARCH_TERM_LENGTH) {
            this.searchResults = [];
            return;
        }

        // Apply search throttling (prevents search if user is still typing)
        if (this.searchThrottlingTimeout) {
            clearTimeout(this.searchThrottlingTimeout);
        }
        
        this.searchThrottlingTimeout = setTimeout(() => {
            // Send search event if search term is long enougth
            if (this.cleanSearchTerm.length >= MINIMAL_SEARCH_TERM_LENGTH) {
                // Display spinner until results are returned
                this.loading = true;

                const searchEvent = new CustomEvent('search', {
                    detail: {
                        searchTerm: this.cleanSearchTerm
                    }
                });
                this.dispatchEvent(searchEvent);
            }
            this.searchThrottlingTimeout = null;
        }, SEARCH_DELAY);
    }

    isSelectionAllowed() {
        return !this.hasSelection();
    }

    hasResults() {
        return this.searchResults.length > 0;
    }

    hasSelection() {
        return this.selectedValue;
    }

    handleInput(event) {
        // Prevent action if selection is not allowed
        if (!this.isSelectionAllowed()) {
            return;
        }
        this.updateSearchTerm(event.target.value);
    }

    handleResultClick(event) {
        const recordId = event.currentTarget.dataset.recordid;

        // Save selection
        let selectedItem = this.searchResults.filter(
            result => result.id === recordId
        );
        if (selectedItem.length === 0) {
            return;
        }
        this.selectedValue = selectedItem[0];
        
        // Reset search
        this.searchTerm = '';
        this.searchResults = [];

        // Notify parent components that selection has changed
        debugger;
        this.dispatchEvent(new CustomEvent('selectionchange', {
            detail: {
                value: this.selectedValue
            }
        }));
    }

    handleComboboxClick() {
        // Hide combobox immediatly
        if (this.blurTimeout) {
            window.clearTimeout(this.blurTimeout);
        }
        this.hasFocus = false;
    }

    handleFocus() {
        // Prevent action if selection is not allowed
        if (!this.isSelectionAllowed()) {
            return;
        }
        this.hasFocus = true;
    }

    handleBlur() {
        // Prevent action if selection is not allowed
        if (!this.isSelectionAllowed()) {
            return;
        }
        // Delay hiding combobox so that we can capture selected result
        this.blurTimeout = window.setTimeout(() => {
            this.hasFocus = false;
            this.blurTimeout = null;
        }, 300);
    }

    handleClearSelection() {
        this.selectedValue = null;
        // Notify parent components that selection has changed
        this.dispatchEvent(new CustomEvent('selectionchange', {
            detail: {
                value: this.selectedValue
            }
        }));
    }

    get getContainerClass() {
        let css = 'slds-combobox_container slds-has-inline-listbox ';
        if (this.hasFocus && this.hasResults()) {
            css += 'slds-has-input-focus ';
        }
        if (this.errors.length > 0) {
            css += 'has-custom-error';
        }
        return css;
    }

    get getDropdownClass() {
        let css =
            'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click ';
        if (
            this.hasFocus &&
            this.cleanSearchTerm &&
            this.cleanSearchTerm.length >= MINIMAL_SEARCH_TERM_LENGTH
        ) {
            css += 'slds-is-open';
        }
        return css;
    }

    get getInputClass() {
        return 'slds-combobox__input-value slds-input slds-combobox__input has-custom-height ' +
                (this.errors.length === 0 ? '' : 'has-custom-error ') +
                (this.hasSelection() ? ' has-custom-border' : '');
    }

    get getComboboxClass() {
        return 'slds-combobox__form-element slds-input-has-icon ' + 
                (this.hasSelection() ? 'slds-input-has-icon_left-right' : 'slds-input-has-icon_right');
    }

    get getSearchIconClass() {
        return 'slds-input__icon slds-input__icon_right ' + (this.hasSelection() ? 'slds-hide' : '');
    }

    get getClearSelectionButtonClass() {
        return (
            'slds-button slds-button_icon slds-input__icon slds-input__icon_right ' +
            (this.hasSelection() ? '' : 'slds-hide')
        );
    }

    get getSelectIconName() {
        return this.hasSelection() ? this.selectedValue.icon : 'standard:default';
    }

    get getSelectIconClass() {
        return ('slds-combobox__input-entity-icon ' + (this.hasSelection() ? '' : 'slds-hide'));
    }

    get getInputValue() {
        return this.hasSelection() ? 
                this.selectedValue.title + (this.selectedValue.subtitle ? (', ' + this.selectedValue.subtitle) : ''): 
                this.searchTerm;
    }

    get getInputTitle() {
        return this.hasSelection() ? this.selectedValue.title : '';
    }

    get getListboxClass() {
        return (
            'slds-listbox slds-listbox_vertical slds-dropdown slds-dropdown_fluid ' +
            (this.scrollAfterNItems
                ? 'slds-dropdown_length-with-icon-' + this.scrollAfterNItems
                : '')
        );
    }

    get isInputReadonly() {
        return this.hasSelection();
    }

    get isExpanded() {
        return this.hasResults();
    }
}
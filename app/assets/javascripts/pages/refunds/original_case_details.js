var originalCaseDetails = (function() {
    function publishCurrentAddressChanged() {
        var val = $('.main-content.refunds_original_case_details [name=\'refunds_original_case_details[address_changed]\']:checked').val();
        $.publish('address_changed', val);
    }
    function publishCurrentHadRepresentative() {
        var val = $('.main-content.refunds_original_case_details [name=\'refunds_original_case_details[claim_had_representative]\']:checked').val();
        $.publish('claim_had_representative', val);
    }
    function publishCurrentValues() {
        publishCurrentAddressChanged();
        publishCurrentHadRepresentative();
    }
    publishCurrentValues();
});
(function() {
    $(document).ready(originalCaseDetails);
})();

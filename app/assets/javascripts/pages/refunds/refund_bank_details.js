var refundBankDetailsPage = (function() {
    var refundBankDetailsPage = {};
    function publishCurrentAccountType() {
        val = $('.main-content.refunds_bank_details [name=\'refunds_bank_details[payment_account_type]\']').val();
        $.publish('payment_account_type', val);
    }
    function publishCurrentValues() {
        publishCurrentAccountType();
    }


    function enableContinueWhenAllowed() {
        $.subscribe('payment_account_type', function (event, val) {
            $('.main-content.refunds_bank_details [data-behavior=\'continue_button\']').prop('disabled', val == '');
        });
    }

    refundBankDetailsPage.init = function() {
        enableContinueWhenAllowed();
        publishCurrentValues();
    }
    return refundBankDetailsPage;
})();

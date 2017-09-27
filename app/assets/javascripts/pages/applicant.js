var applicant = (function() {
    function disableContinue() {
        $('.main-content.refunds_applicant [data-behavior=\'continue_button\']').prop('disabled', true);

    }
    function publishCurrentValues() {
        val = $('.main-content.refunds_applicant [name=\'refunds_applicant[has_name_changed]\']:checked').val();
        $.publish('has_name_changed', val);
    }
    function enableContinueWhenAllowed() {
        $.subscribe('has_name_changed', function (event, val) {
            $('.main-content.refunds_applicant [data-behavior=\'continue_button\']').prop('disabled', val != 'false');
        });
    }
    //disableContinue();
    enableContinueWhenAllowed();
    publishCurrentValues();
});
(function() {
    $(document).ready(applicant);
})();

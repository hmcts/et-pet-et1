var refundApplicantPage = (function() {
    var refundApplicantPage = {};

    function selectedOptionEl() {
        return $('.main-content.refunds_applicant [name=\'refunds_applicant[has_name_changed]\']:checked');
    }

    function publishCurrentValues() {
        var val = selectedOptionEl().val();
        $.publish('has_name_changed', val);
    }
    function enableContinueWhenAllowed() {
        $.subscribe('has_name_changed', setCurrentState);
    }

    function continueButtonEl() {
        return $('.main-content.refunds_applicant [data-behavior=\'continue_button\']');
    }

    function setCurrentState() {
        val = selectedOptionEl().val()
        continueButtonEl().prop('disabled', val !== 'false');
    }
    refundApplicantPage.init = function () {
        setCurrentState();
        enableContinueWhenAllowed();
        publishCurrentValues();
    };
    return refundApplicantPage
})();

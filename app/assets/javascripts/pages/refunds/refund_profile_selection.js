var refundProfileSelectionPage = (function() {
    var refundProfileSelectionPage = {};
    function setCurrentState() {
        var disabled = !selectedProfileTypeEl().val();
        $('.main-content.refunds_profile_selection [data-behavior=\'continue_button\']').prop('disabled', disabled);
    }

    function selectedProfileTypeEl() {
        return $('.main-content.refunds_profile_selection [data-behavior=\'profile_type\']:checked');
    }

    function profileTypeEl() {
        return $('.main-content.refunds_profile_selection [data-behavior=\'profile_type\']');
    }

    function updateStateWhenRequired() {
        profileTypeEl().on('click change', setCurrentState);
    }
    refundProfileSelectionPage.init = function() {
        setCurrentState();
        updateStateWhenRequired();
    };
    return refundProfileSelectionPage;
})();

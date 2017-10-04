var refundReviewPage = (function() {
    var refundReview = {};
    function disableContinue() {

        $('.main-content.refunds_review [data-behavior=\'continue_button\']').prop('disabled', true)
    }
    function enableContinueWhenAllowed() {
        acceptDeclarationEl().on('click', function(a, b, c) {
            $('[data-behavior=\'continue_button\']').prop('disabled', false)
        })
    }
    function acceptDeclarationEl() {
        return $('.main-content.refunds_review [data-behavior=\'accept_declaration\']');
    }
    refundReview.init = function() {
        disableContinue();
        enableContinueWhenAllowed();
    }
    return refundReview;
})();

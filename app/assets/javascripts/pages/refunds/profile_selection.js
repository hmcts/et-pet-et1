var profileSelection = (function() {
    $('.main-content.refunds_profile_selection [data-behavior=\'continue_button\']').prop('disabled', true);
    $('.main-content.refunds_profile_selection [data-behavior=\'profile_type\']').on('click', function() {
        $('[data-behavior=\'continue_button\']').prop('disabled', false)
    });
});
(function() {
    $(document).ready(profileSelection);
})();

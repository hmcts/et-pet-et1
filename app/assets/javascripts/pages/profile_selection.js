var profileSelection = (function() {
    $('.main-content.profile_selection [data-behavior=\'continue_button\']').prop('disabled', true)
    $('.main-content.profile_selection [data-behavior=\'profile_type\']').on('click', function(a, b, c) {
        $('[data-behavior=\'continue_button\']').prop('disabled', false)
    })
});
(function() {
    $(document).ready(profileSelection);
})()

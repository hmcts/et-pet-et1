var refundFeesPage = (function() {
    var refundFeesPage = {};
    function updateTotalFees() {
        var values = [];
        values.push($('.main-content.refunds_fees [name=\'refunds_fees[et_issue_fee]\']').val());
        values.push($('.main-content.refunds_fees [name=\'refunds_fees[et_hearing_fee]\']').val());
        values.push($('.main-content.refunds_fees [name=\'refunds_fees[et_reconsideration_fee]\']').val());
        values.push($('.main-content.refunds_fees [name=\'refunds_fees[eat_issue_fee]\']').val());
        values.push($('.main-content.refunds_fees [name=\'refunds_fees[eat_hearing_fee]\']').val());
        const total = values.reduce(function(sum, value) {
            if(value == '') {
                return sum;
            }
            return sum + parseFloat(value);
        }, 0);
        $('.main-content.refunds_fees span[data-behavior=\'total_fees\']').text(total.toFixed(2));
    }
    function updateTotalFeesOnChange() {
        $('.main-content.refunds_fees form input[data-behavior=\'fee_field\']').on('change keyup keypress', updateTotalFees);
    }
    refundFeesPage.init = function() {
        updateTotalFees();
        updateTotalFeesOnChange();
    }
    return refundFeesPage;
})();
